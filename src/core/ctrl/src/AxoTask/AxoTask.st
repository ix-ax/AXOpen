USING AXOpen.Logging;
USING AXOpen.Timers;

USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Core

    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoTask EXTENDS AxoTaskLight IMPLEMENTS IAxoTask, IAxoTaskState

        VAR PUBLIC
              ///<summary>
            /// Remote requests for invoke of this task.
            /// When 'TRUE' this task will be invoked.
            ///</summary>
            RemoteInvoke : BOOL;

            ///<summary>
            /// Remote requests for restore of this task.
            /// When 'TRUE' this task will be restored.
            ///</summary>
            RemoteRestore : BOOL;

            ///<summary>
            /// Remote requests for abort of this task.
            /// When 'TRUE' this task will be aborted.
            ///</summary>
            RemoteAbort : BOOL;

            ///<summary>
            /// Remote requests for resume of this task.
            /// When 'TRUE' this task will be resumed.
            ///</summary>
            RemoteResume : BOOL;
            ///<summary>
            /// Provides some error messages.            
            ///</summary> 
            {#ix-set:AttributeName = "<#Messenger#>"}
            {#ix-set:PlcTextList = "[1]:'<#Execute method is not called cyclically.#>':'<#Check task calling in the code, task is not calling cyclically.#>'';
                                    [2]:'<#Execute method is called more then once inside one PLC cycle.#>':'<#Check task calling in the code, task is called more then once.#>';
                                    [3]:'<#Invalid Rtm.#>':'<#Check the inicialization of the Rtm.#>'"}
            _messenger : AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

    
        ///<summary>
        /// Sets the flag to suspend or resume multiple execute check operations.
        ///</summary>
        ///<param name="Suspend">A boolean value indicating whether multiple execute check operations should be suspended (TRUE) or resumed (FALSE).</param>
        ///<remarks>
        /// This method allows dynamic control over the multiple execute check operations.
        /// When suspended (TRUE), the system stops processing multiple execute check operations.
        /// When resumed (FALSE), the system resumes processing multiple execute check operations.
        ///</remarks>
        METHOD PUBLIC SetSuspendMultipleExecuteCallCheck
            VAR_INPUT
                Suspend : BOOL; // Input parameter to suspend or resume multiple execute check operations.
            END_VAR
            _suspendMultipleExecuteCallCheck := Suspend; // Assign the input value to the variable.
        END_METHOD

        ///<summary>
        /// Retrieves the current state of the flag indicating whether multiple execute check operations are suspended or resumed.
        ///</summary>
        ///<returns>A boolean value indicating whether multiple execute check operations are suspended (TRUE) or resumed (FALSE).</returns>
        ///<remarks>
        /// This method provides the current state of the flag controlling multiple execute check operations.
        /// It returns TRUE if multiple execute check operations are suspended, indicating that processing is halted.
        /// It returns FALSE if multiple execute check operations are resumed, allowing normal processing to occur.
        ///</remarks>
        METHOD PUBLIC GetSuspendMultipleExecuteCallCheckState : BOOL
            GetSuspendMultipleExecuteCallCheckState := _suspendMultipleExecuteCallCheck; // Returns the current state of the flag.
        END_METHOD

        ///<summary>
        /// Enables or disables the suspension of cyclic execute check operations.
        ///</summary>
        ///<param name="Suspend">
        /// A boolean value that controls the execution state:
        /// - TRUE: Suspends execute check operations, preventing further execution.
        /// - FALSE: Resumes execute check operations, allowing normal execution.
        ///</param>
        ///<remarks>
        /// This method allows dynamic control over cyclic execution checks.
        /// Setting the flag to TRUE halts execution, while setting it to FALSE resumes normal operation.
        ///</remarks>
        METHOD PUBLIC OVERRIDE SetSuspendCyclicExecuteIsNotCalledCheck
            VAR_INPUT
                Suspend : BOOL; // TRUE to suspend execution, FALSE to resume.
            END_VAR
            _suspendCyclicExecuteIsNotCalledCheck := Suspend; // Update the system state based on input.
        END_METHOD

        ///<summary>
        /// Retrieves the current state of the cyclic execute check suspension flag.
        ///</summary>
        ///<returns>
        /// A boolean value indicating whether execution checks are suspended:
        /// - TRUE: Execution checks are suspended.
        /// - FALSE: Execution checks are active.
        ///</returns>
        ///<remarks>
        /// This method provides visibility into the current execution state.
        /// It returns TRUE if execution is suspended and FALSE if execution is running normally.
        ///</remarks>
        METHOD PUBLIC OVERRIDE GetSuspendCyclicExecuteIsNotCalledCheckState : BOOL
            GetSuspendCyclicExecuteIsNotCalledCheckState := _suspendCyclicExecuteIsNotCalledCheck; // Return the current flag state.
        END_METHOD

        
        ///<summary>
        /// Invokes this task.
        ///</summary>    
        METHOD PUBLIC OVERRIDE Invoke : IAxoTaskState
            VAR_INPUT
                inParent    :   IAxoObject;
            END_VAR
            VAR
                _isNullContext : BOOL;
                // _cyclicExecuteIsNotCalled : BOOL;
                _context : IAxoContext;
            END_VAR;
            SUPER.Run(inParent);
            _context := THIS.GetContext(); 
            _cyclicExecuteIsNotCalled := FALSE;
            Invoke := SUPER.Invoke();
            _messenger.Serve(THIS);            
            _messenger.ActivateOnCondition(ULINT#1,_cyclicExecuteIsNotCalled,eAxoMessageCategory#ProgrammingError);
            Invoke := THIS;
        END_METHOD    

                   
        ///<summary>
        /// Returns `TRUE` if the task is Busy, otherwise false.
        ///	This method needs to be called cyclically.
        ///</summary>    
        METHOD PUBLIC OVERRIDE Execute : BOOL    
            VAR_INPUT
                inParent    :   IAxoObject;
            END_VAR
            VAR 
                _stateKicking : BOOL;
                _openCycleCount : ULINT;      
                _rtmInvalid : BOOL;
                _context : IAxoContext;
            END_VAR

            SUPER.Run(inParent);                    
            _context := THIS.GetContext(); 
            IF(_context = NULL) THEN
                _context := THIS.GetContext();
            END_IF;

            IF(_context = NULL) THEN 
                RETURN; 
            END_IF;
            IF( RemoteInvoke) THEN 
                THIS.Invoke(); 
                RemoteInvoke := FALSE; 
            END_IF;
            IF _RemoteRestoreEnabled THEN
                IF( RemoteRestore) THEN 
                    THIS.Restore(); 
                    RemoteRestore := FALSE; 
                END_IF;
            ELSE
                RemoteRestore := FALSE;
            END_IF;
            IF _RemoteAbortEnabled THEN
                IF( RemoteAbort ) THEN 
                    THIS.Abort(); 
                    RemoteAbort := FALSE; 
                END_IF;
            ELSE
                RemoteAbort := FALSE;
            END_IF;
            IF( RemoteResume) THEN 
                THIS.Resume(); 
                RemoteResume := FALSE; 
            END_IF;
            
            _messenger.Serve(THIS);
            _multipleExecuteIsCalled := FALSE;
            Execute := SUPER.Execute(inParent);

            _messenger.ActivateOnCondition(ULINT#2,_multipleExecuteIsCalled,eAxoMessageCategory#ProgrammingError);       
        END_METHOD    
        
       
        ///<summary>
        /// Sets the remote restore functionality based on the provided input.
        /// Enables or disables remote restoration based on the value of the 'Enable' parameter.
        ///</summary>
        ///<param name="Enable">A boolean value indicating whether remote restore functionality should be enabled (TRUE) or disabled (FALSE).</param>
        ///<remarks>
        /// This method allows dynamic control over the ability to perform remote restoration tasks.
        /// When enabled, remote restoration functionality is activated, allowing tasks to be restored remotely.
        /// When disabled, remote restoration functionality is deactivated, preventing tasks from being restored remotely.
        ///</remarks>
        METHOD PUBLIC OVERRIDE SetRemoteRestoreEnabled
            VAR_INPUT
                Enable : BOOL; // Input parameter to enable or disable remote restore.
            END_VAR
            _RemoteRestoreEnabled := Enable; // Assign the input value to the variable.
        END_METHOD

        ///<summary>
        /// Retrieves the current status of remote restore functionality.
        ///</summary>
        ///<returns>A boolean value indicating whether remote restore functionality is enabled (TRUE) or disabled (FALSE).</returns>
        ///<remarks>
        /// This method provides the current status of remote restore functionality.
        /// It returns TRUE if remote restoration is enabled, allowing tasks to be restored remotely.
        /// It returns FALSE if remote restoration is disabled, preventing tasks from being restored remotely.
        ///</remarks>
        METHOD PUBLIC GetRemoteRestoreEnabled : BOOL
            GetRemoteRestoreEnabled := _RemoteRestoreEnabled; // Returns the current status of remote restore functionality.
        END_METHOD

        ///<summary>
        /// Sets the remote abort functionality based on the provided input.
        /// Enables or disables remote abort based on the value of the 'Enable' parameter.
        ///</summary>
        ///<param name="Enable">A boolean value indicating whether remote abort functionality should be enabled (TRUE) or disabled (FALSE).</param>
        ///<remarks>
        /// This method allows dynamic control over the ability to perform remote abort tasks.
        /// When enabled, remote abort functionality is activated, allowing tasks to be aborted remotely.
        /// When disabled, remote abort functionality is deactivated, preventing tasks from being aborted remotely.
        ///</remarks>
        METHOD PUBLIC SetRemoteAbortEnabled
            VAR_INPUT
                Enable : BOOL; // Input parameter to enable or disable remote abort.
            END_VAR
            _RemoteAbortEnabled := Enable; // Assign the input value to the variable.
        END_METHOD

        ///<summary>
        /// Retrieves the current status of remote abort functionality.
        ///</summary>
        ///<returns>A boolean value indicating whether remote abort functionality is enabled (TRUE) or disabled (FALSE).</returns>
        ///<remarks>
        /// This method provides the current status of remote abort functionality.
        /// It returns TRUE if remote abort is enabled, allowing tasks to be aborted remotely.
        /// It returns FALSE if remote abort is disabled, preventing tasks from being aborted remotely.
        ///</remarks>
        METHOD PUBLIC GetRemoteAbortEnabled : BOOL
            GetRemoteAbortEnabled := _RemoteAbortEnabled; // Returns the current status of remote abort functionality.
        END_METHOD      
    END_CLASS    
END_NAMESPACE

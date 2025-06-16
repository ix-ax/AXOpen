USING AXOpen.Logging;
USING AXOpen.Timers;

USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Core

    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoTaskLight EXTENDS AxoObject IMPLEMENTS IAxoTask, IAxoTaskState
        VAR PUBLIC
            ///<summary>
            /// Gets the state of this task.
            ///</summary>
            {#ix-set:AttributeName = "<#Command state#>"}
            {#ix-attr:[ReadOnly()]}
            Status : eAxoTaskState;     
             
            ///<summary>
            /// Gets or sets whether this task is disabled for execution.
            ///</summary>
            IsDisabled : BOOL;      

            ///<summary>
            /// Contains contex cycle number when this task started.            
            ///</summary>           
            StartSignature : ULINT;

            ///<summary>
            /// Gets elapsed time of last task execution.
            ///</summary>  
            {#ix-attr:[ReadOnly()]}         
            Duration : LTIME;

            ///<summary>
            /// Gets date and time when the task started.
            ///</summary>  
            {#ix-attr:[ReadOnly()]}         
            StartTimeStamp : LDATE_AND_TIME;

            ///<summary>
            /// Contains details about the error.            
            ///</summary>                       
            ErrorDetails : STRING[254];          
        END_VAR    
        
        VAR PROTECTED
            _openCycleCountInvoke : ULINT;
            _openCycleCountExecute : ULINT;            
            _taskTimer : AXOpen.Timers.OnDelayTimer;          
            _isFirstExecutionCycle   : BOOL;
            
            _suspendCyclicExecuteIsNotCalledCheck   : BOOL := FALSE;
            _suspendMultipleExecuteCallCheck        : BOOL := FALSE;          
            _RemoteRestoreEnabled                   : BOOL := TRUE;
            _RemoteAbortEnabled                     : BOOL := FALSE;

            _restoreCycleCount  :  ULINT;
            _doneCycleCount     :  ULINT;
            _startCycleCount    :  ULINT;
            _errorCycleCount    :  ULINT;
            _abortCycleCount    :  ULINT;
            _resumeCycleCount   :  ULINT;  
            
            _cyclicExecuteIsNotCalled : BOOL;
            _multipleExecuteIsCalled : BOOL;
        END_VAR 

      

        ///<summary>
        /// Gets the actual state of this task.
        ///</summary>    
        METHOD PUBLIC GetState : eAxoTaskState          
           IF IsDisabled THEN 
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                END_IF;
            END_IF;

            GetState := Status;
        END_METHOD

        METHOD PUBLIC GetErrorDetails : STRING[254]
            GetErrorDetails := ErrorDetails;            
        END_METHOD    

        ///<summary>
        /// Gets true when the task is ready.
        ///</summary>
        METHOD PUBLIC IsReady : BOOL 
            IF IsDisabled THEN 
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
                IsReady := false; 
                RETURN;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    IsReady := TRUE; 
                    RETURN;
                END_IF;
            END_IF;

            IsReady := Status = eAxoTaskState#Ready; 
        END_METHOD   

        ///<summary>
        /// Gets true when the task is done.
        ///</summary>
        METHOD PUBLIC IsDone : BOOL 
            IF IsDisabled THEN 
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
                IsDone := false; 
                RETURN;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    IsDone := false; 
                    RETURN;
                END_IF;
            END_IF;

            IsDone := Status = eAxoTaskState#Done ; 
        END_METHOD
                    
        ///<summary>
        /// Gets true when the task is busy/executing.
        ///</summary>
        METHOD PUBLIC IsBusy : BOOL 
            IF IsDisabled THEN
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
                IsBusy := false; 
                RETURN;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    IsBusy := false; 
                    RETURN;
                END_IF;
            END_IF;

            IsBusy := Status = eAxoTaskState#Busy; 
        END_METHOD
            
        ///<summary>
        /// Gets true when the task is aborted.
        ///</summary>
        METHOD PUBLIC IsAborted : BOOL 
            IF IsDisabled THEN 
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
                IsAborted := false; 
                RETURN;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    IsAborted := false; 
                    RETURN; 
                END_IF;
            END_IF;
            
            IsAborted := Status = eAxoTaskState#Aborted; 
        END_METHOD
            
        ///<summary>
        /// Gets true when the task has error.
        ///</summary>
        METHOD PUBLIC HasError : BOOL 
            IF IsDisabled THEN 
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                    HasError := FALSE; 
                    RETURN; 
                ELSE
                    HasError := TRUE; 
                    RETURN; 
                END_IF;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    HasError := FALSE; 
                    RETURN; 
                END_IF;
            END_IF;

            HasError := Status = eAxoTaskState#Error; 
        END_METHOD   

        ///<summary>
        /// Checks if the current execution cycle is the first cycle.
        ///</summary>
        ///<returns>A boolean value indicating whether the current execution cycle is the first cycle (TRUE) or not (FALSE).</returns>
        ///<remarks>
        /// This method provides information about whether the current execution cycle is the initial cycle.
        /// It returns TRUE if the code is being executed for the first time in the cycle.
        /// It returns FALSE if the code is not in the first execution cycle.
        ///</remarks>
        METHOD PUBLIC IsFirstExecutionCycle : BOOL 
            IsFirstExecutionCycle := _isFirstExecutionCycle; // Returns the status of the first execution cycle flag.
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
        METHOD PUBLIC SetSuspendCyclicExecuteIsNotCalledCheck
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
        METHOD PUBLIC GetSuspendCyclicExecuteIsNotCalledCheckState : BOOL
            GetSuspendCyclicExecuteIsNotCalledCheckState := _suspendCyclicExecuteIsNotCalledCheck; // Return the current flag state.
        END_METHOD

        METHOD PROTECTED IsNewInvokeCall : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
           
            _context := THIS.GetContext();
                 
            IF _context <> NULL THEN
                IsNewInvokeCall := _openCycleCountInvoke < _context.OpenCycleCount() - ULINT#1;
            ELSE
                IsNewInvokeCall := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PROTECTED IsNewExecuteCall : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
           
            _context := THIS.GetContext();
                 
            IF _context <> NULL THEN
                IsNewExecuteCall := _openCycleCountExecute < _context.OpenCycleCount() - ULINT#1;
            ELSE
                IsNewExecuteCall := FALSE;
            END_IF;     
        END_METHOD 

        METHOD PROTECTED IsExecuteCalledInThisPlcCycle : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext();     
            IF _context <> NULL THEN
                IsExecuteCalledInThisPlcCycle := _openCycleCountExecute = _context.OpenCycleCount();
            ELSE
                IsExecuteCalledInThisPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PROTECTED WasExecuteCalledInPreviousPlcCycle : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext(); 
            
            IF(_context = NULL) THEN
                _context := THIS.GetContext();
            END_IF;      
            IF _context <> NULL THEN
                WasExecuteCalledInPreviousPlcCycle := _openCycleCountExecute + ULINT#1 = _context.OpenCycleCount();
            ELSE
                WasExecuteCalledInPreviousPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
  

        ///<summary>
        /// Invokes this task.
        ///</summary>    
        METHOD PUBLIC Invoke : IAxoTaskState
            VAR_INPUT
                inParent    :   IAxoObject;
            END_VAR
            VAR
                _isNullContext : BOOL;
                _context : IAxoContext;
            END_VAR;

            SUPER.Run(inParent);
              
            _context := THIS.GetContext(); 
            IF(_context = NULL) THEN
                _context := THIS.GetContext();
            END_IF;

            IF _context = NULL THEN
                Status := eAxoTaskState#Error;
                ErrorDetails := 'NULL CONTEXT'; 
                RETURN;               
            END_IF;

            IF IsDisabled THEN 
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                END_IF;
            END_IF;

            
           
            IF Status = eAxoTaskState#Done AND THIS.IsNewInvokeCall() THEN
                Status := eAxoTaskState#Ready; 
            END_IF;

            _openCycleCountInvoke := _context.OpenCycleCount();

            // task should not be Invoked, if the execute method was not called in this or previous PLC cycle
            IF Status = eAxoTaskState#Ready THEN
                IF (THIS.IsExecuteCalledInThisPlcCycle() OR THIS.WasExecuteCalledInPreviousPlcCycle()) THEN
                        Status := eAxoTaskState#Kicking;      
                        _context.GetLogger().Log('Task invoked', eLogLevel#Verbose, THIS);
                ELSE                                         
                    IF(NOT _suspendCyclicExecuteIsNotCalledCheck) THEN 
                        _cyclicExecuteIsNotCalled := TRUE;
                        Status := eAxoTaskState#Error;
                        ErrorDetails := 'CyclicExecuteIsNotCalled'; 
                    END_IF;                     
                END_IF;     
            END_IF;     
           
            Invoke := THIS;
        END_METHOD    

        ///<summary>
        /// Restores this task.
        ///</summary>    
        METHOD PUBLIC Restore : IAxoTaskState
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext(); 
            IF(Status <> eAxoTaskState#Ready AND Status <> eAxoTaskState#Disabled) THEN
                IF(_context = NULL) THEN
                    _context := THIS.GetContext();
                END_IF;      
                _context.GetLogger().Log('Task restored', eLogLevel#Verbose, THIS);
                _restoreCycleCount :=  _context.OpenCycleCount();
            END_IF;    
            Status := eAxoTaskState#Ready; 
            ErrorDetails := '';               

            IF IsDisabled THEN 
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                END_IF;
            END_IF;

            Restore := THIS;
            THIS.OnRestore();
        END_METHOD    
            
        ///<summary>
        ///  Makes this task to transition in `Done` state 
        ///  when `Condition` argument is `TRUE`.
        ///</summary>    
        METHOD PUBLIC DoneWhen
            VAR_INPUT
                Condition : BOOL;
            END_VAR
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext(); 
            IF Condition AND Status = eAxoTaskState#Busy THEN 
                IF(_context = NULL) THEN
                    _context := THIS.GetContext();
                END_IF;        
                _context.GetLogger().Log('Task done.', eLogLevel#Verbose, THIS);
                Status := eAxoTaskState#Done;
                THIS.OnDone();
                _doneCycleCount :=  _context.OpenCycleCount();
            END_IF;    
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if the task is Busy, otherwise false.
        ///	This method needs to be called cyclically.
        ///</summary>    
        METHOD PUBLIC Execute : BOOL    
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
            
            _openCycleCount :=  _context.OpenCycleCount();

            IF NOT _suspendMultipleExecuteCallCheck THEN
                IF _openCycleCountExecute = _openCycleCount THEN
                    _multipleExecuteIsCalled := TRUE;
                    Status := eAxoTaskState#Error;
                    ErrorDetails := 'MultipleExecuteIsCalled';   
                END_IF;
            END_IF;
           

            _openCycleCountExecute := _openCycleCount;
        
                
            // If the Invoke() method was called in more then one PLC cycle back without calling the Execute() method
            // and the Execute() is subsequently called without calling the Invoke() method in the same PLC cycle,
            // CommandTask is set back to ready and does not start the execution.
            //IF Status = eAxoTaskState#Kicking AND NOT THIS.IsInvokeCalledInThisPlcCycle() AND NOT THIS.WasInvokeCalledInPreviousPlcCycle() THEN
            
            _stateKicking :=  Status = eAxoTaskState#Kicking;
            
            _isFirstExecutionCycle := FALSE; 

            IF _stateKicking then 
                IF  (_openCycleCountInvoke <> _openCycleCountExecute) then
                    IF  ((_openCycleCountInvoke + ULINT#1) <> _openCycleCountExecute) THEN            
                        Status := eAxoTaskState#Ready;  
                        _stateKicking := false;    
                    END_IF; 
                END_IF;
            END_IF;

            IF _stateKicking THEN
                Status := eAxoTaskState#Busy; 

                // This null check is due to implementation of RTC in unit tests
                IF(_context.GetRtc() <> NULL) THEN
                    StartTimeStamp := _context.GetRtc().NowUTC();
                END_IF;  
                  
                // Don't touch this, it is used for remote execs.
                StartSignature := _openCycleCountExecute;//_context.OpenCycleCount();    
                _context.GetLogger().Log('Task started.', eLogLevel#Verbose, THIS);                       
                THIS.OnStart();
                _isFirstExecutionCycle := TRUE; 
                _startCycleCount :=  _context.OpenCycleCount();
            END_IF;    

            IF(Status = eAxoTaskState#Error) THEN
                THIS.WhileError();
            END_IF;   

            IF IsDisabled THEN 
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                END_IF;
            END_IF;

            Execute := Status = eAxoTaskState#Busy;

            _taskTimer.OnDelay(THIS,  Execute, LT#99999D);

            IF(Execute) THEN 
                Duration := _taskTimer.ElapsedTime;  
            END_IF;  

            // IF(NOT _suspendRtmCheck) THEN 
            //     IF(_context.GetRtm() = NULL) THEN
            //         _rtmInvalid := TRUE;
            //         Status := eAxoTaskState#Error;
            //         ErrorDetails := 'RtmInvalid'; 
            //     END_IF;                     
            // END_IF;                
            // _messenger.ActivateOnCondition(ULINT#3,_rtmInvalid,eAxoMessageCategory#ProgrammingError);
        END_METHOD    
        
        ///<summary>
        /// Makes this task enter into `Error` state, when `HasErrorState` argument is `TRUE`
        /// task in error state stops its execution.
        ///</summary>    
        METHOD PUBLIC ThrowWhen
            VAR_INPUT
                HasErrorState : BOOL;
            END_VAR
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext(); 
            IF(HasErrorState) THEN
                IF(_context = NULL) THEN
                    _context := THIS.GetContext();
                END_IF;      
                Status := eAxoTaskState#Error;  
                _context.GetLogger().Log('Task failed', eLogLevel#Error, THIS);             
                THIS.OnError();  
                THIS.WhileError();   
                _errorCycleCount :=  _context.OpenCycleCount();
            END_IF;    
        END_METHOD    
    
        ///<summary>
        /// Makes this task enter into `Error` state, when `HasErrorState` argument is `TRUE`
        /// task in error state stops its execution.
        ///</summary>    
        METHOD PUBLIC ThrowWhen
            VAR_INPUT
                HasErrorState : BOOL;
                ErrorDescription : STRING[254];
            END_VAR  
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext(); 

            IF(HasErrorState) THEN      
                IF(_context = NULL) THEN
                    _context := THIS.GetContext();
                END_IF;                
                ErrorDetails :=  ErrorDescription; 
                _context.GetLogger().Log(ErrorDetails, eLogLevel#Error, THIS);  
            END_IF;    
            THIS.ThrowWhen(HasErrorState);        
        END_METHOD    

        ///<summary>
        /// Sets the value of the `IsDisabled` variable
        ///</summary>
        METHOD PUBLIC SetIsDisabled
            VAR_INPUT
                Disabled : BOOL;
            END_VAR
            IsDisabled := Disabled;
        END_METHOD

        ///<summary>
        /// Returns the value of the `IsDisabled` variable
        ///</summary>
        METHOD PUBLIC GetIsDisabled : BOOL
            GetIsDisabled := IsDisabled;
        END_METHOD
    
        ///<summary>
        /// Aborts the execution of the task if running and sets its state to aborted.
        ///</summary>
        METHOD PUBLIC Abort 
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext(); 

            IF THIS.Status = eAxoTaskState#Busy THEN
                IF(_context = NULL) THEN
                    _context := THIS.GetContext();
                END_IF;      
                THIS.Status := eAxoTaskState#Aborted;
                THIS.OnAbort();
                _abortCycleCount :=  _context.OpenCycleCount();
            END_IF;
        END_METHOD
    
        ///<summary>
        /// Resume the execution of the task if aborted and sets its state to busy.
        ///</summary>
        METHOD PUBLIC Resume 
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext(); 

            IF THIS.Status = eAxoTaskState#Aborted THEN
                 
                THIS.Status := eAxoTaskState#Busy;
                THIS.OnResume();
                _resumeCycleCount :=  _context.OpenCycleCount();
            END_IF;
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
        METHOD PUBLIC SetRemoteRestoreEnabled
            VAR_INPUT
                Enable : BOOL; // Input parameter to enable or disable remote restore.
            END_VAR
            _RemoteRestoreEnabled := Enable; // Assign the input value to the variable.
        END_METHOD


        ///<summary>
        /// Executes once when the task is aborted.
        ///</summary>
        METHOD PROTECTED OnAbort 
            ;
        END_METHOD

        ///<summary>
        /// Executes once when the task is resumed.
        ///</summary>
        METHOD PROTECTED OnResume 
            ;
        END_METHOD

        ///<summary>
        /// Executes once when the task reaches the `Done` state.
        ///</summary>
        METHOD PROTECTED OnDone 
            ;
        END_METHOD
    
        ///<summary>
        /// Executes once when the task reaches the `Error` state.
        ///</summary>
        METHOD PROTECTED OnError 
            ;
        END_METHOD
    
        ///<summary>
        /// Executes once when the task is restored.
        ///</summary>
        METHOD PROTECTED OnRestore 
            ;
        END_METHOD
    
        ///<summary>
        /// Executes once when the task starts (at the moment of transition from the `Kicking` state into the `Busy` state).
        ///</summary>
        METHOD PROTECTED OnStart 
            ;
        END_METHOD
    
        ///<summary>
        /// Executes repeatedly while the task is in `Error` state (and `Execute()` method is called).
        ///</summary>
        METHOD PROTECTED WhileError 
            ;
        END_METHOD    

        ///<summary>
        /// Returns `TRUE` when the task has been aborted in this or previous PLC cycle.
        ///</summary>
        METHOD PUBLIC AbortTriggered : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext();               
            AbortTriggered := _abortCycleCount > ULINT#0 AND _abortCycleCount >= _context.OpenCycleCount() - ULINT#1;
        END_METHOD

        ///<summary>
        /// Returns `TRUE` when the task has been resumed in this or previous PLC cycle.
        ///</summary>
        METHOD PUBLIC ResumeTriggered : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext();   
            ResumeTriggered := _resumeCycleCount> ULINT#0 AND _resumeCycleCount >= _context.OpenCycleCount() - ULINT#1;
        END_METHOD

        ///<summary>
        /// Returns `TRUE` when the task has reached the `Done` state in this or previous PLC cycle.
        ///</summary>
        METHOD PUBLIC DoneReached : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext();   
            DoneReached := _doneCycleCount > ULINT#0 AND _doneCycleCount >= _context.OpenCycleCount() - ULINT#1;
        END_METHOD
    
        ///<summary>
        /// Returns `TRUE` when the task has reached the `Error` state in this or previous PLC cycle.
        ///</summary>
        METHOD PUBLIC ErrorOccured : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext();    
            ErrorOccured := _errorCycleCount > ULINT#0 AND _errorCycleCount >= _context.OpenCycleCount() - ULINT#1;
        END_METHOD
    
        ///<summary>
        /// Returns `TRUE` when the task has been restored in this or previous PLC cycle.
        ///</summary>
        METHOD PUBLIC RestoreTriggered : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext();   
            RestoreTriggered := _restoreCycleCount > ULINT#0 AND _restoreCycleCount >= _context.OpenCycleCount() - ULINT#1;
        END_METHOD
    
        ///<summary>
        /// Returns `TRUE` when the task has been started in this or previous PLC cycle.
        ///</summary>
        METHOD PUBLIC StartTriggered : BOOL
            VAR
                _context : IAxoContext;
            END_VAR    
            _context := THIS.GetContext();     
            StartTriggered := _startCycleCount > ULINT#0 AND _startCycleCount >= _context.OpenCycleCount() - ULINT#1;
        END_METHOD
    END_CLASS    
END_NAMESPACE

USING AXOpen.Logging;
USING AXOpen.Timers;

USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.Core

    CLASS PUBLIC AxoTask EXTENDS AxoObject IMPLEMENTS IAxoTask, IAxoTaskState

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
        
        VAR PRIVATE
            _openCycleCountInvoke : ULINT;
            _openCycleCountExecute : ULINT;            
            _taskTimer : AXOpen.Timers.OnDelayTimer;          
            ///<summary>
            /// Enable error message when task is not calling cyclically .            
            ///</summary> 
            {#ix-set:MessageText = "<#Cyclic Execute is not called.#>"}
            {#ix-set:Help = "<#Check task calling in the code, task is not calling cyclically #>"}
            _CyclicExecuteIsNotCalled : AXOpen.Messaging.Static.AxoMessenger;  
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
                IsReady := false; RETURN;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    IsReady := false; RETURN;
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
                IsDone := false; RETURN;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    IsDone := false; RETURN;
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
                IsBusy := false; RETURN;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    IsBusy := false; RETURN;
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
                IsAborted := false; RETURN;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                    IsAborted := false; RETURN; 
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
                    HasError := FALSE; RETURN; 
                ELSE
                    HasError := TRUE; RETURN; 
                END_IF;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                END_IF;
            END_IF;

            HasError := Status = eAxoTaskState#Error; 
        END_METHOD   

        METHOD PRIVATE IsNewInvokeCall : BOOL
            IF _context_ <> NULL THEN
                IsNewInvokeCall := _openCycleCountInvoke < _context_.OpenCycleCount() - ULINT#1;
            ELSE
                IsNewInvokeCall := FALSE;
            END_IF;     
        END_METHOD 

        // METHOD PRIVATE IsInvokeCalledInThisPlcCycle1 : BOOL
        //     IF _context_ <> NULL THEN
        //         IsInvokeCalledInThisPlcCycle := _openCycleCountInvoke = _context_.OpenCycleCount();
        //     ELSE
        //         IsInvokeCalledInThisPlcCycle := FALSE;
        //     END_IF;     
        // END_METHOD 
        
        // METHOD PRIVATE WasInvokeCalledInPreviousPlcCycle1 : BOOL
        //     IF _context_ <> NULL THEN
        //         WasInvokeCalledInPreviousPlcCycle := _openCycleCountInvoke +ULINT#1 = _context_.OpenCycleCount();
        //     ELSE
        //         WasInvokeCalledInPreviousPlcCycle := FALSE;
        //     END_IF;     
        // END_METHOD 
        
        METHOD PRIVATE IsNewExecuteCall : BOOL
            IF _context_ <> NULL THEN
                IsNewExecuteCall := _openCycleCountExecute < _context_.OpenCycleCount() - ULINT#1;
            ELSE
                IsNewExecuteCall := FALSE;
            END_IF;     
        END_METHOD 

        METHOD PRIVATE IsExecuteCalledInThisPlcCycle : BOOL
            IF _context_ <> NULL THEN
                IsExecuteCalledInThisPlcCycle := _openCycleCountExecute = _context_.OpenCycleCount();
            ELSE
                IsExecuteCalledInThisPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PRIVATE WasExecuteCalledInPreviousPlcCycle : BOOL
            IF _context_ <> NULL THEN
                WasExecuteCalledInPreviousPlcCycle := _openCycleCountExecute + ULINT#1 = _context_.OpenCycleCount();
            ELSE
                WasExecuteCalledInPreviousPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PRIVATE UpdateState 
            // IF Status <> eAxoTaskState#Error AND IsDisabled THEN
            //     Status := eAxoTaskState#Disabled; 
            // ELSIF Status = eAxoTaskState#Disabled AND NOT IsDisabled THEN
            //     Status := eAxoTaskState#Ready; 
            // END_IF;

            IF IsDisabled THEN // on 1515 1ms for 5000 cals
                IF Status <> eAxoTaskState#Error THEN
                    Status := eAxoTaskState#Disabled; 
                END_IF;
            ELSE
                IF  Status = eAxoTaskState#Disabled THEN
                    Status := eAxoTaskState#Ready; 
                END_IF;
            END_IF;
        END_METHOD        

        ///<summary>
        /// Invokes this task.
        ///</summary>    
        METHOD PUBLIC Invoke : IAxoTaskState
            VAR
                _isNullContext : BOOL;
            END_VAR;
            
            _isNullContext := _context_ = NULL;


            IF _isNullContext THEN
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

            _CyclicExecuteIsNotCalled.Serve(THIS); 
           
            IF Status = eAxoTaskState#Done AND THIS.IsNewInvokeCall() THEN
                Status := eAxoTaskState#Ready; 
            END_IF;

            _openCycleCountInvoke := _context_.OpenCycleCount();

            // task should not be Invoked, if the execute method was not called in this or previous PLC cycle
            IF Status = eAxoTaskState#Ready THEN
                IF (THIS.IsExecuteCalledInThisPlcCycle() OR THIS.WasExecuteCalledInPreviousPlcCycle()) THEN
                    Status := eAxoTaskState#Kicking;      
                    THIS.LogTask('Task invoked', eLogLevel#Verbose, THIS);                                             
                  ELSE                                         
                    _CyclicExecuteIsNotCalled.Activate(eAxoMessageCategory#ProgrammingError);                     
                 END_IF;     
            END_IF;     

            Invoke := THIS;
        END_METHOD    

        ///<summary>
        /// Restores this task.
        ///</summary>    
        METHOD PUBLIC Restore : IAxoTaskState
            IF(Status <> eAxoTaskState#Ready AND Status <> eAxoTaskState#Disabled) THEN
                THIS.LogTask('Task restored', eLogLevel#Verbose, THIS);
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
              
            IF Condition AND Status = eAxoTaskState#Busy THEN   
                THIS.LogTask('Task done.', eLogLevel#Verbose, THIS);
                Status := eAxoTaskState#Done;
                THIS.OnDone();
            END_IF;    
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if the task is Busy, otherwise false.
        ///	This method needs to be called cyclically.
        ///</summary>    
        METHOD PUBLIC Execute : BOOL            
            
            VAR 
                _stateKicking : BOOL;
            END_VAR
            
            IF(_context_ = NULL) THEN RETURN; END_IF;
            IF( RemoteInvoke) THEN THIS.Invoke(); RemoteInvoke := FALSE; END_IF;
            IF( RemoteRestore) THEN THIS.Restore(); RemoteRestore := FALSE; END_IF;
            IF( RemoteAbort) THEN THIS.Abort(); RemoteAbort := FALSE; END_IF;
            IF( RemoteResume) THEN THIS.Resume(); RemoteResume := FALSE; END_IF;

            _openCycleCountExecute := _context_.OpenCycleCount();
                
            // If the Invoke() method was called in more then one PLC cycle back without calling the Execute() method
            // and the Execute() is subsequently called without calling the Invoke() method in the same PLC cycle,
            // CommandTask is set back to ready and does not start the execution.
            //IF Status = eAxoTaskState#Kicking AND NOT THIS.IsInvokeCalledInThisPlcCycle() AND NOT THIS.WasInvokeCalledInPreviousPlcCycle() THEN
            
            _stateKicking :=  Status = eAxoTaskState#Kicking;
            
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
                IF(_context_.GetRtc() <> NULL) THEN
                    StartTimeStamp := _context_.GetRtc().NowUTC();
                END_IF;  
                  
                // Don't touch this, it is used for remote execs.
                StartSignature := _openCycleCountExecute;//_context_.OpenCycleCount();    
                THIS.LogTask('Task started.', eLogLevel#Verbose, THIS);                       
                THIS.OnStart();
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

            IF(Execute) THEN Duration := _taskTimer.ElapsedTime;  END_IF;             
        END_METHOD    

        METHOD PRIVATE LogTask 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;
                _sender : IAxoObject;
            END_VAR
            VAR
                _castIIAxoStep : IAxoStep;
            END_VAR               
            _castIIAxoStep ?= _sender;
            IF(_castIIAxoStep <> NULL) THEN RETURN; END_IF;            
            _context_.GetLogger().Log(_message, _level, THIS);       
        END_METHOD

        ///<summary>
        /// Makes this task enter into `Error` state, when `HasErrorState` argument is `TRUE`
        /// task in error state stops its execution.
        ///</summary>    
        METHOD PUBLIC ThrowWhen
            VAR_INPUT
                HasErrorState : BOOL;
            END_VAR

            IF(HasErrorState) THEN
                Status := eAxoTaskState#Error;  
                THIS.LogTask('Task failed', eLogLevel#Error, THIS);             
                THIS.OnError();  
                THIS.WhileError();   
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
            IF(HasErrorState) THEN                
                ErrorDetails :=  ErrorDescription; 
                THIS.LogTask(ErrorDetails, eLogLevel#Verbose, THIS);  
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
            IF THIS.Status = eAxoTaskState#Busy THEN
                THIS.Status := eAxoTaskState#Aborted;
                THIS.OnAbort();
            END_IF;
        END_METHOD
    
        ///<summary>
        /// Resume the execution of the task if aborted and sets its state to busy.
        ///</summary>
        METHOD PUBLIC Resume 
            IF THIS.Status = eAxoTaskState#Aborted THEN
                THIS.Status := eAxoTaskState#Busy;
                THIS.OnResume();
            END_IF;
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
    END_CLASS    
END_NAMESPACE
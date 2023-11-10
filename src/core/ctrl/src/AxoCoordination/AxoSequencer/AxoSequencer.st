NAMESPACE AXOpen.Core
    CLASS AxoSequencer EXTENDS AxoTask IMPLEMENTS IAxoSequencer
        VAR PUBLIC                  
            {#ix-set:AttributeName = "<#Stepping mode#>"}
            SteppingMode : eAxoSteppingMode;
            {#ix-set:AttributeName = "<#Sequence mode#>"}
            SequenceMode : eAxoSequenceMode;
            CurrentOrder : ULINT;
            {#ix-set:AttributeName = ">>"}
            StepForwardCommand : AxoTask;
            {#ix-set:AttributeName = "<#Run step#>"}
            StepIn : AxoTask;
            {#ix-set:AttributeName = "<<"}
            StepBackwardCommand : AxoTask;
            BeforeStep : AxoStep;
            CurrentStep : AxoStep;
            AfterStep : AxoStep;
        END_VAR   
        VAR PRIVATE
            _configurationFlowOrder : ULINT;   
            _numberOfConfiguredSteps : ULINT;   
            _coordinatorState : AxoCoordinatorStates;
            _step : IAxoStep;
            _openCycleCounter : ULINT;    
            _closeCycleCounter : ULINT;    
            _refBeforeStep : REF_TO AxoStep;
            _refCurrentStep : REF_TO AxoStep;
            _refAfterStep : REF_TO AxoStep;
        END_VAR     

        ///<summary>
        /// Opens sequencers operations.
        /// This method must be called prior to any other calls of this instance of 
        /// sequencer.
        ///</summary>
        METHOD PUBLIC Open : BOOL
        VAR
            tContext : IAxoContext;
        end_var


            Open := FALSE;
            
            SUPER.SetSuspendMultipleExecuteCallCheck(TRUE);

            StepForwardCommand.SetSuspendMultipleExecuteCallCheck(TRUE);
            StepIn.SetSuspendMultipleExecuteCallCheck(TRUE);
            StepBackwardCommand.SetSuspendMultipleExecuteCallCheck(TRUE);

            IF SUPER.Execute() THEN
                IF _context_ = NULL THEN RETURN; END_IF;         
                _openCycleCounter := _context_.OpenCycleCount();
                CASE _coordinatorState OF
                    AxoCoordinatorStates#Idle :
                        _configurationFlowOrder := ULINT#0;
                        _numberOfConfiguredSteps := ULINT#0;
                        _coordinatorState := AxoCoordinatorStates#Configuring;


                        tContext := StepForwardCommand.GetContextUnsafe();
                        
                        if  tContext = NULL then
                            StepForwardCommand.Initialize(_context_);
                            StepIn.Initialize(_context_);
                            StepBackwardCommand.Initialize(_context_);
                        end_if;

                        // IF(StepForwardCommand.GetContext() = NULL) THEN // asi to robi problem
                        //     StepForwardCommand.Initialize(_context_);
                        //     StepIn.Initialize(_context_);
                        //     StepBackwardCommand.Initialize(_context_);
                        // END_IF;    

                    AxoCoordinatorStates#Configuring :
                        THIS.OnBeforeSequenceStart();
                        CurrentOrder := ULINT#1;
                        _coordinatorState := AxoCoordinatorStates#Running;
                        _context_.GetLogger().Log('Sequence in config state :', AXOpen.Logging.eLogLevel#Verbose, THIS);
                END_CASE;    
                Open := TRUE;
            END_IF;            
        END_METHOD    
        
        METHOD INTERNAL Execute : BOOL
            VAR_INPUT
                step : IAxoStep;                
                Enable : BOOL;
            END_VAR

            IF SUPER.Execute() THEN               
                IF step.GetContext() = NULL THEN Execute := FALSE; RETURN; END_IF;     
                
                _step := step;
                            
                IF(_coordinatorState = AxoCoordinatorStates#Configuring) THEN
                    THIS.DetermineOrder(step);  
                END_IF;                                                            
                    
                // Stepping inside the sequence
                IF _coordinatorState = AxoCoordinatorStates#Running THEN
                    // Stepping is possible only in StepByStepMode
                    IF SteppingMode = eAxoSteppingMode#StepByStep THEN
                        // Stepping Forwards and Backwards commands cannot be executed simultaneously
                        StepForwardCommand.IsDisabled := StepBackwardCommand.IsBusy() 
                                                            // Stepping Forwards disabled from last step
                                                            OR CurrentOrder >= _numberOfConfiguredSteps;
                        StepIn.IsDisabled :=  FALSE;
                        StepBackwardCommand.IsDisabled := StepForwardCommand.IsBusy() 
                                                            // Stepping Backwards disabled from first step
                                                            OR CurrentOrder <= ULINT#1;
                        // StepForward command increments the CurrentOrder just to a maximum value of _numberOfConfiguredSteps 
                        IF StepForwardCommand.Execute() THEN
                            IF CurrentOrder < _numberOfConfiguredSteps THEN
                                THIS.AbortCurrentStep();
                                CurrentOrder := CurrentOrder + ULINT#1;
                            END_IF;
                            StepForwardCommand.DoneWhen(TRUE);
                        END_IF;
                        // StepBackward command decrements the CurrentOrder just to a minimum value of 1 
                        IF StepBackwardCommand.Execute() THEN
                            IF CurrentOrder > ULINT#1 THEN
                                THIS.AbortCurrentStep();
                                CurrentOrder := CurrentOrder - ULINT#1;
                            END_IF;
                            StepBackwardCommand.DoneWhen(TRUE);
                        END_IF;
                    ELSE
                        THIS.DisableAllSteppingComands();
                    END_IF;
                ELSE
                    THIS.DisableAllSteppingComands();
                END_IF;
               
                IF _coordinatorState = AxoCoordinatorStates#Running && (CurrentOrder = step.GetStepOrder()) && step.IsCalledJustOnceInThisPlcCycle() THEN
                    IF Enable THEN
                        step.SetIsActive(TRUE);
                    ELSE
                        CurrentOrder := CurrentOrder + ULINT#1;
                        // Finalize the StepIn Command in a case of step mode
                        StepIn.DoneWhen(SteppingMode = eAxoSteppingMode#StepByStep);
                    END_IF;
                ELSE
                    step.SetIsActive(FALSE);
                END_IF;
                
                step.SetIsEnabled(Enable);
                
                IF NOT step.IsDone() THEN
                    step.SetIsDisabled(NOT step.GetIsActive());
                END_IF;
                
                IF step.GetIsActive() AND (step.IsReady() OR step.IsDone() OR SteppingMode = eAxoSteppingMode#StepByStep) THEN
                    IF (SteppingMode = eAxoSteppingMode#Continous) THEN
                        step.Invoke();
                        _context_.GetLogger().Log('Starts step :', AXOpen.Logging.eLogLevel#Verbose, step);
                    // Invoke the step in a case of step mode when StepIn Command is invoked
                    ELSIF (SteppingMode = eAxoSteppingMode#StepByStep) THEN
                        IF StepIn.Execute() THEN
                            IF _step.HasError() THEN
                                _step.Restore();
                            END_IF;
                            step.Invoke();
                        END_IF;
                    END_IF;
                END_IF;

                Execute := step.Execute();                                                              
            END_IF;

            IF(THIS.CurrentOrder = step.GetStepOrder()) THEN
                _refCurrentStep ?= step;
                CurrentStep := _refCurrentStep^;
            END_IF;   

            IF(THIS.CurrentOrder + ULINT#1 = step.GetStepOrder() OR (THIS.CurrentOrder = THIS.GetNumberOfConfiguredSteps() AND step.GetStepOrder() = UINT#1)) THEN
                _refAfterStep ?= step;
                AfterStep := _refAfterStep^;
            END_IF;

            IF(THIS.CurrentOrder - ULINT#1 = step.GetStepOrder() OR (THIS.CurrentOrder = UINT#1 AND step.GetStepOrder() = THIS.GetNumberOfConfiguredSteps())) THEN
                _refBeforeStep ?= step;
                BeforeStep := _refBeforeStep^;
            END_IF; 
        END_METHOD
                
        ///<summary>
        /// Moves the execution to the next step.                        
        ///</summary>
        METHOD PUBLIC MoveNext 
            IF SUPER.Execute() THEN
                IF _step.GetContext() = NULL THEN RETURN; END_IF;       
                IF _coordinatorState = AxoCoordinatorStates#Running THEN
                    _context_.GetLogger().Log('Step done :', AXOpen.Logging.eLogLevel#Verbose, _step);
                    _step.DoneWhen(_step.IsBusy());
                    _step.SetIsActive(FALSE);
                    CurrentOrder := CurrentOrder + ULINT#1;
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(SteppingMode = eAxoSteppingMode#StepByStep);
                END_IF;
            END_IF;
        END_METHOD

      
  
        ///<summary>
        /// Terminates the currently executed step and initiates the RequestedStep to be executed
        ///</summary>
        METHOD PUBLIC RequestStep
            VAR_INPUT
                RequestedStep : IAxoStep;
            END_VAR
            IF SUPER.Execute() THEN
                IF RequestedStep.GetContext() = NULL THEN RETURN; END_IF;               
                IF RequestedStep.GetStepOrder() <> ULINT#0 AND                    
                    _coordinatorState = AxoCoordinatorStates#Running THEN
                    _context_.GetLogger().Log('Step request to step :', AXOpen.Logging.eLogLevel#Verbose, RequestedStep);
                    _step.DoneWhen(_step.IsBusy());
                    _step.SetIsActive(FALSE);
                    CurrentOrder := RequestedStep.GetStepOrder();
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(SteppingMode = eAxoSteppingMode#StepByStep);
                END_IF;
            END_IF;
        END_METHOD

        ///<summary>
        /// Completes (finishes) the execution of this sequencer and set the coordination state to Idle.               
        /// If the `SequenceMode` of the sequencer is set to `RunOnce`, terminates also execution of the sequencer itself.
        ///</summary>
        METHOD PUBLIC CompleteSequence   
            IF SUPER.Execute() THEN
                IF _step.GetContext() = NULL THEN RETURN; END_IF;         
                IF _coordinatorState = AxoCoordinatorStates#Running THEN
                    _step.DoneWhen(TRUE);
                    _step.SetIsActive(FALSE);
                    _coordinatorState := AxoCoordinatorStates#Idle;
                    CurrentOrder := ULINT#1;
                    SUPER.DoneWhen(SequenceMode =eAxoSequenceMode#RunOnce);
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(SteppingMode = eAxoSteppingMode#StepByStep);
                    THIS.OnCompleteSequence();
                    _context_.GetLogger().Log('Sequence completed :', AXOpen.Logging.eLogLevel#Verbose, THIS);
                END_IF;
            END_IF;
        END_METHOD    
        ///<summary>
        /// Executes once when the sequence starts.
        ///</summary>
        METHOD PROTECTED OnBeforeSequenceStart
            ;
            END_METHOD    
                        
        ///<summary>
        /// Executes once when the sequence is completed.
        ///</summary>
        METHOD PROTECTED OnCompleteSequence
        ;
        END_METHOD    
            
        ///<summary>
        /// Gets the state of the coordinator                        
        ///</summary>
        METHOD PUBLIC GetCoordinatorState : AxoCoordinatorStates           
            GetCoordinatorState := _coordinatorState;
        END_METHOD    

        METHOD PRIVATE DetermineOrder : ULINT
            VAR_INPUT
                step : IAxoStep;
            END_VAR   

            //IF(_coordinatorState = AxoCoordinatorStates#Configuring) THEN
                step.Restore();
                _step := step;
                _configurationFlowOrder := _configurationFlowOrder + ULINT#1;
                _numberOfConfiguredSteps := _configurationFlowOrder;

                step.SetStepOrder(THIS,_configurationFlowOrder);
                IF NOT step.IsCalledJustOnceInThisPlcCycle() THEN 
                    _coordinatorState := AxoCoordinatorStates#Idle;
                    step.SetStepOrder(THIS,ULINT#0);
               END_IF;
            //END_IF;
                        
            DetermineOrder := step.GetStepOrder();            
        END_METHOD      
        
        ///<summary>
        /// Gets the number of the configured steps in the sequence.                        
        ///</summary>
        METHOD PUBLIC GetNumberOfConfiguredSteps : ULINT
            IF _coordinatorState = AxoCoordinatorStates#Running THEN
                _numberOfConfiguredSteps := _configurationFlowOrder;
                GetNumberOfConfiguredSteps := _numberOfConfiguredSteps;
            ELSE
                GetNumberOfConfiguredSteps := ULINT#0;
            END_IF;
        END_METHOD  
        
        // METHOD PROTECTED InvalidContext1 : BOOL
        //     IF _context_ = NULL THEN 
        //         InvalidContext := TRUE;  // TODO: We will need to message this, when messaging ready.            
        //     ELSE
        //         InvalidContext := FALSE;
        //     END_IF;
        // END_METHOD
        
        // METHOD PROTECTED InvalidContext1 : BOOL
        //     VAR_INPUT
        //         step : IAxoStep;                
        //     END_VAR
        //     IF _context_ = NULL THEN 
        //         InvalidContext := TRUE;  // TODO: We will need to message this, when messaging ready.            
        //     ELSIF step.GetContext() = NULL THEN
        //         InvalidContext := TRUE;  // TODO: We will need to message this, when messaging ready.            
        //     ELSE
        //         InvalidContext := FALSE;
        //     END_IF;
        // END_METHOD
       
        METHOD PROTECTED DisableAllSteppingComands 
            StepForwardCommand.IsDisabled := TRUE;
            StepIn.IsDisabled := TRUE;
            StepBackwardCommand.IsDisabled := TRUE;
        END_METHOD

        METHOD PROTECTED AbortCurrentStep 
            // Abort current step if running
            IF _step.IsBusy() THEN
                _step.Abort();
            END_IF;
            // Abort step in command if running, otherwise this command will be executed on the following step
            IF StepIn.IsBusy() THEN
                StepIn.Abort();
            END_IF;
            _step.SetIsActive(FALSE);
        END_METHOD
    
        METHOD PROTECTED OVERRIDE OnRestore 
            _configurationFlowOrder := ULINT#0;
            _numberOfConfiguredSteps := ULINT#0;
            _coordinatorState := AxoCoordinatorStates#Idle;
        END_METHOD

        
        METHOD PUBLIC AndThen
            VAR_IN_OUT
                step : AxoStep;
            END_VAR    
            VAR_INPUT                    
                tsk : IAxoTask;
            END_VAR   


            IF(step.Execute(THIS)) THEN                
                IF(tsk.Invoke().IsDone()) THEN
                    THIS.MoveNext();
                END_IF;    
            END_IF;    
        END_METHOD
        
        METHOD Close 
            VAR_IN_OUT
                step : AxoStep;
            END_VAR 
            IF(step.Execute(THIS)) THEN                               
               THIS.CompleteSequence();               
            END_IF;  
        END_METHOD
    END_CLASS    
END_NAMESPACE

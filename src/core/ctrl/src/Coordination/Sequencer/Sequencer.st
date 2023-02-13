NAMESPACE ix.framework.core
    CLASS Sequencer EXTENDS CommandTask IMPLEMENTS ISequencer
        VAR PUBLIC                  
            {#ix-set:AttributeName = "<#Stepping mode#>"}
            SteppingMode : eSteppingMode;
            {#ix-set:AttributeName = "<#Sequence mode#>"}
            SequenceMode : eSequenceMode;
            CurrentOrder : ULINT;
            {#ix-set:AttributeName = ">>"}
            StepForwardCommand : CommandTask;
            {#ix-set:AttributeName = "<#Run step#>"}
            StepIn : CommandTask;
            {#ix-set:AttributeName = "<<"}
            StepBackwardCommand : CommandTask;
        END_VAR   
        VAR PRIVATE
            _configurationFlowOrder : ULINT;   
            _numberOfConfiguredSteps : ULINT;   
            _coordinatorState : CoordinatorStates;
            _step : IStep;
            _openCycleCounter : ULINT;    
            _closeCycleCounter : ULINT;    
        END_VAR     

        ///<summary>
        /// Opens sequencers operations.
        /// This method must be called prior to any other calls of this instance of 
        /// sequencer.
        ///</summary>
        METHOD PUBLIC Open 
            IF SUPER.Execute() THEN
                IF THIS. InvalidContext() THEN RETURN; END_IF;         
                _openCycleCounter := THIS.GetContext().OpenCycleCount();
                CASE _coordinatorState OF
                    CoordinatorStates#Idle :
                        _configurationFlowOrder := ULINT#0;
                        _numberOfConfiguredSteps := ULINT#0;
                        _coordinatorState := CoordinatorStates#Configuring;
                        StepForwardCommand.Initialize(THIS.GetContext());
                        StepIn.Initialize(THIS.GetContext());
                        StepBackwardCommand.Initialize(THIS.GetContext());
                    CoordinatorStates#Configuring :
                        THIS.OnBeforeSequenceStart();
                        CurrentOrder := ULINT#1;
                        _coordinatorState := CoordinatorStates#Running;
                END_CASE;    
            END_IF;
        END_METHOD    
        
        METHOD INTERNAL Execute : BOOL
            VAR_INPUT
                step : IStep;                
                Enable : BOOL;
            END_VAR

            IF SUPER.Execute() THEN
                IF THIS.InvalidContext(step) THEN Execute := FALSE; RETURN; END_IF;     
                
                _step := step;

                THIS.DetermineOrder(step);   

                // Stepping inside the sequence
                IF _coordinatorState = CoordinatorStates#Running THEN
                    // Stepping is possible only in StepByStepMode
                    IF SteppingMode = eSteppingMode#StepByStep THEN
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
               
                IF _coordinatorState = CoordinatorStates#Running AND (CurrentOrder = step.GetStepOrder()) AND step.IsCalledJustOnceInThisPlcCycle() THEN
                    IF Enable THEN
                        step.SetIsActive(TRUE);
                    ELSE
                        CurrentOrder := CurrentOrder + ULINT#1;
                        // Finalize the StepIn Command in a case of step mode
                        StepIn.DoneWhen(SteppingMode = eSteppingMode#StepByStep);
                    END_IF;
                ELSE
                    step.SetIsActive(FALSE);
                END_IF;
                
                step.SetIsEnabled(Enable);
                
                IF NOT step.IsDone() THEN
                    step.SetIsDisabled(NOT step.GetIsActive());
                END_IF;
                
                IF step.GetIsActive() AND (step.IsReady() OR step.IsDone()) THEN
                    IF (SteppingMode = eSteppingMode#Continous) THEN
                        step.Invoke();
                    // Invoke the step in a case of step mode when StepIn Command is invoked
                    ELSIF (SteppingMode = eSteppingMode#StepByStep) THEN
                        IF StepIn.Execute() THEN
                            step.Invoke();
                        END_IF;
                    END_IF;
                END_IF;

                Execute := step.Execute();                                                              
            END_IF;
        END_METHOD
                
        ///<summary>
        /// Moves the execution to the next step.                        
        ///</summary>
        METHOD PUBLIC MoveNext 
            IF SUPER.Execute() THEN
                IF THIS.InvalidContext(_step) THEN RETURN; END_IF;         
                IF _coordinatorState = CoordinatorStates#Running THEN
                    _step.DoneWhen(_step.IsBusy());
                    _step.SetIsActive(FALSE);
                    CurrentOrder := CurrentOrder + ULINT#1;
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(SteppingMode = eSteppingMode#StepByStep);
                END_IF;
            END_IF;
        END_METHOD

        ///<summary>
        /// Terminates the currently executed step and initiates the RequestedStep to be executed
        ///</summary>
        METHOD PUBLIC RequestStep
            VAR_INPUT
                RequestedStep : IStep;
            END_VAR
            IF SUPER.Execute() THEN
                IF THIS.InvalidContext(RequestedStep) THEN RETURN; END_IF;         
                IF RequestedStep.GetStepOrder() <> ULINT#0 AND
                    _coordinatorState = CoordinatorStates#Running THEN
                    _step.DoneWhen(_step.IsBusy());
                    _step.SetIsActive(FALSE);
                    CurrentOrder := RequestedStep.GetStepOrder();
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(SteppingMode = eSteppingMode#StepByStep);
                END_IF;
            END_IF;
        END_METHOD

        ///<summary>
        /// Completes (finishes) the execution of this sequencer and set the coordination state to Idle.               
        /// If the `SequenceMode` of the sequencer is set to `RunOnce`, terminates also execution of the sequencer itself.
        ///</summary>
        METHOD PUBLIC CompleteSequence   
            IF SUPER.Execute() THEN
                IF THIS.InvalidContext(_step) THEN RETURN; END_IF;         
                IF _coordinatorState = CoordinatorStates#Running THEN
                    _step.DoneWhen(TRUE);
                    _step.SetIsActive(FALSE);
                    _coordinatorState := CoordinatorStates#Idle;
                    CurrentOrder := ULINT#1;
                    SUPER.DoneWhen(SequenceMode =eSequenceMode#RunOnce);
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(SteppingMode = eSteppingMode#StepByStep);
                    THIS.OnCompleteSequence();
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
        METHOD PUBLIC GetCoordinatorState : CoordinatorStates           
            GetCoordinatorState := _coordinatorState;
        END_METHOD    

        METHOD PROTECTED DetermineOrder : ULINT
            VAR_INPUT
                step : IStep;
            END_VAR   

            IF(_coordinatorState = CoordinatorStates#Configuring) THEN
                step.Restore();
                _step := step;
                _configurationFlowOrder := _configurationFlowOrder + ULINT#1;
                _numberOfConfiguredSteps := _configurationFlowOrder;

                step.SetStepOrder(THIS,_configurationFlowOrder);
                IF NOT step.IsCalledJustOnceInThisPlcCycle() THEN 
                    _coordinatorState := CoordinatorStates#Idle;
                    step.SetStepOrder(THIS,ULINT#0);
               END_IF;
            END_IF;
                        
            DetermineOrder := step.GetStepOrder();            
        END_METHOD      
        
        ///<summary>
        /// Gets the number of the configured steps in the sequence.                        
        ///</summary>
        METHOD PUBLIC GetNumberOfConfiguredSteps : ULINT
            IF _coordinatorState = CoordinatorStates#Running THEN
                _numberOfConfiguredSteps := _configurationFlowOrder;
                GetNumberOfConfiguredSteps := _numberOfConfiguredSteps;
            ELSE
                GetNumberOfConfiguredSteps := ULINT#0;
            END_IF;
        END_METHOD  
        
        METHOD PROTECTED InvalidContext : BOOL
            IF THIS.GetContext() = NULL THEN 
                InvalidContext := TRUE;  // TODO: We will need to message this, when messaging ready.            
            ELSE
                InvalidContext := FALSE;
            END_IF;
        END_METHOD
        
        METHOD PROTECTED InvalidContext : BOOL
            VAR_INPUT
                step : IStep;                
            END_VAR
            IF THIS.GetContext() = NULL THEN 
                InvalidContext := TRUE;  // TODO: We will need to message this, when messaging ready.            
            ELSIF IsNullContext(step.GetContext()) THEN
                InvalidContext := TRUE;  // TODO: We will need to message this, when messaging ready.            
            ELSE
                InvalidContext := FALSE;
            END_IF;
        END_METHOD
       
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
            _coordinatorState := CoordinatorStates#Idle;
        END_METHOD
    END_CLASS    
END_NAMESPACE

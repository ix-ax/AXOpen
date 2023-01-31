NAMESPACE ix.framework.core
    // CLASS Sequencer EXTENDS Object IMPLEMENTS ISequencer
    CLASS Sequencer EXTENDS CommandTask IMPLEMENTS ISequencer
        VAR PUBLIC                  
            CurrentOrder : ULINT;
            {#ix-set:AttributeName = ">>"}
            StepForwardCommand : CommandTask;
            {#ix-set:AttributeName = "<#Run#>"}
            StepIn : CommandTask;
            {#ix-set:AttributeName = "<<"}
            StepBackwardCommand : CommandTask;
        END_VAR   
        VAR PRIVATE
            _configurationFlowOrder : ULINT;    
            _coordinatorState : CoordinatorStates;
            _step : IStep;
            _steppingMode : eSteppingMode;
            _sequenceMode : eSequenceMode;
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
                IF THIS.InvalidContext() THEN RETURN; END_IF;         
                _openCycleCounter := THIS.GetContext().OpenCycleCount();
                CASE _coordinatorState OF
                    CoordinatorStates#Idle :
                        _configurationFlowOrder := ULINT#0;
                        _coordinatorState := CoordinatorStates#Configuring;
                    CoordinatorStates#Configuring :
                        CurrentOrder := ULINT#1;
                        _coordinatorState := CoordinatorStates#Running;
                END_CASE;    
            END_IF;
        END_METHOD    
        
        ///<summary>
        /// Completes (finishes) the execution of this sequencer.                
        /// Returns the `order of execution` pointer to the first step of the sequence.
        ///</summary>
        METHOD PUBLIC CompleteSequence   
            IF SUPER.Execute() THEN
                IF THIS.InvalidContext(_step) THEN RETURN; END_IF;         
                    IF _coordinatorState = CoordinatorStates#Running THEN
                    _step.DoneWhen(TRUE);
                    _coordinatorState := CoordinatorStates#Idle;
                    CurrentOrder := ULINT#1;
                    SUPER.DoneWhen(_sequenceMode =eSequenceMode#RunOnce);
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(_steppingMode = eSteppingMode#StepByStep);
                END_IF;
            END_IF;
        END_METHOD    
        
        ///<summary>
        /// Moves the execution to the next step.                        
        ///</summary>
        METHOD PUBLIC MoveNext 
            IF SUPER.Execute() THEN
                IF THIS.InvalidContext(_step) THEN RETURN; END_IF;         
                IF _coordinatorState = CoordinatorStates#Running THEN
                    _step.DoneWhen(TRUE);
                    CurrentOrder := CurrentOrder + ULINT#1;
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(_steppingMode = eSteppingMode#StepByStep);
                END_IF;
            END_IF;
        END_METHOD

        ///<summary>
        /// Gets the state of the coordinator                        
        ///</summary>
        METHOD PUBLIC GetCoordinatorState : CoordinatorStates           
            GetCoordinatorState := _coordinatorState;
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
                    _step.DoneWhen(TRUE);
                    CurrentOrder := RequestedStep.GetStepOrder();
                    // Finalize the StepIn Command in a case of step mode
                    StepIn.DoneWhen(_steppingMode = eSteppingMode#StepByStep);
                END_IF;
            END_IF;
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if the specified step is currently executing.
        ///</summary>
        METHOD PUBLIC Execute : BOOL
            VAR_INPUT
                step : IStep;                
                Enable : BOOL;
            END_VAR

            IF SUPER.Execute() THEN
                IF THIS.InvalidContext(step) THEN Execute := FALSE; RETURN; END_IF;     
                
                _step := step;

                THIS.DetermineOrder(step);   
                
                IF _coordinatorState = CoordinatorStates#Running AND (CurrentOrder = step.GetStepOrder()) AND step.IsCalledJustOnceInThisPlcCycle() THEN
                    IF Enable THEN
                        step.SetIsActive(TRUE);
                    ELSE
                        CurrentOrder := CurrentOrder + ULINT#1;
                        // Finalize the StepIn Command in a case of step mode
                        StepIn.DoneWhen(_steppingMode = eSteppingMode#StepByStep);
                    END_IF;
                ELSE
                    step.SetIsActive(FALSE);
                END_IF;
                
                step.SetIsEnabled(Enable);
                
                IF NOT step.IsDone() THEN
                    step.SetIsDisabled(NOT step.GetIsActive());
                END_IF;
                
                IF step.GetIsActive() AND (step.IsReady() OR step.IsDone()) THEN
                    IF (_steppingMode = eSteppingMode#Continous) THEN
                        step.Invoke();
                    // Invoke the step in a case of step mode when StepIn Command is invoked
                    ELSIF (_steppingMode = eSteppingMode#StepByStep) THEN
                        IF StepIn.Execute() THEN
                            step.Invoke();
                        END_IF;
                    END_IF;
                END_IF;

                Execute := step.Execute();                                                              
            END_IF;
    END_METHOD
                  
        ///<summary>
        /// Sets the stepping mode of the sequencer                        
        ///</summary>
        METHOD PUBLIC SetSteppingMode
            VAR_INPUT
                SteppingMode : eSteppingMode;
            END_VAR
            _steppingMode := SteppingMode;
        END_METHOD

        ///<summary>
        /// Gets the stepping mode of the sequencer                        
        ///</summary>
        METHOD PUBLIC GetSteppingMode : eSteppingMode           
            GetSteppingMode := _steppingMode;
        END_METHOD    

        ///<summary>
        /// Sets the sequence mode of the sequencer                        
        ///</summary>
        METHOD PUBLIC SetSequenceMode
            VAR_INPUT
                SequenceMode : eSequenceMode;
            END_VAR
            _sequenceMode := SequenceMode;
        END_METHOD
        
        ///<summary>
        /// Gets the sequence mode of the sequencer                        
        ///</summary>
        METHOD PUBLIC GetSequenceMode : eSequenceMode           
            GetSequenceMode := _sequenceMode;
        END_METHOD    

        METHOD PROTECTED DetermineOrder : ULINT
            VAR_INPUT
                step : IStep;
            END_VAR   

            IF(_coordinatorState = CoordinatorStates#Configuring) THEN
                step.Restore();
                _step := step;
                _configurationFlowOrder := _configurationFlowOrder + ULINT#1;

                step.SetStepOrder(THIS,_configurationFlowOrder);
                IF NOT step.IsCalledJustOnceInThisPlcCycle() THEN 
                    _coordinatorState := CoordinatorStates#Idle;
                    step.SetStepOrder(THIS,ULINT#0);
               END_IF;
            END_IF;
                        
            DetermineOrder := step.GetStepOrder();            
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
        
    END_CLASS    
END_NAMESPACE



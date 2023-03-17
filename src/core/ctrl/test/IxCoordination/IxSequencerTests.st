USING AxUnit;
USING AxUnit;
USING ix.core.IxContext_Tests;
USING ix.framework.core;
USING AxUnit;
USING ix.framework.core;
USING AxUnit;

NAMESPACE ix.core.IxSequencer_Tests  
    
    CLASS TestContext IMPLEMENTS ix.framework.core.IIxContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
         END_VAR       
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;
        END_METHOD
                
        METHOD PUBLIC ClosedCycleCount : ULINT
            ClosedCycleCount := _closeCounter;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT            
            _identityCounter := _identityCounter + ULINT#1;
            CreateIdentity := _identityCounter;
        END_METHOD        
        METHOD PUBLIC RealTimeClock : IIxRtc ; END_METHOD
    END_CLASS  

    CLASS MySequencer EXTENDS IxSequencer
        VAR PRIVATE
            OnBeforeSequenceStartCounter : ULINT;
            OnCompleteSequenceCounter : ULINT;
        END_VAR
        METHOD PROTECTED OVERRIDE OnBeforeSequenceStart
            OnBeforeSequenceStartCounter := OnBeforeSequenceStartCounter + ULINT#1;
        END_METHOD
        
        METHOD PROTECTED OVERRIDE OnCompleteSequence
            OnCompleteSequenceCounter := OnCompleteSequenceCounter + ULINT#1;
        END_METHOD 
        
        METHOD PUBLIC GetOnBeforeSequenceStartCounter : ULINT
            GetOnBeforeSequenceStartCounter := OnBeforeSequenceStartCounter;
        END_METHOD
        
        METHOD PUBLIC GetOnCompleteSequenceCounter : ULINT
            GetOnCompleteSequenceCounter := OnCompleteSequenceCounter;
        END_METHOD
    END_CLASS


    {TestFixture}
    CLASS SequencerTests
        VAR PROTECTED        
            _context   : TestContext;
            _sequencer : MySequencer;
            _step_1    : IxStep;
            _step_2    : IxStep;
            _step_3    : IxStep;
            _orderCounter : ULINT;
            _stepState  :   eIxTaskState;
            _counter : ULINT;
        END_VAR    

        METHOD Equal : BOOL
            VAR_INPUT
                 expected:  eIxTaskState;
                 actual:  eIxTaskState;
            END_VAR
            Equal := expected = actual;
        END_METHOD         
        
        METHOD Equal : BOOL
            VAR_INPUT
                expected:  CoordinatorStates;
                actual:  CoordinatorStates;
            END_VAR
            Equal := expected = actual;
        END_METHOD 

        METHOD Equal : BOOL
            VAR_INPUT
                 expected:  eIxSteppingMode;
                 actual:  eIxSteppingMode;
            END_VAR
            Equal := expected = actual;
        END_METHOD         
        
        METHOD Equal : BOOL
            VAR_INPUT
                 expected:  eIxSequenceMode;
                 actual:  eIxSequenceMode;
            END_VAR
            Equal := expected = actual;
        END_METHOD         
        
        METHOD PUBLIC GetSequencerState : CoordinatorStates
            GetSequencerState := _sequencer.GetCoordinatorState();
        END_METHOD
                
        METHOD PRIVATE InitializeSequence
            _context.Open();
            _sequencer.Initialize(_context);
        END_METHOD
       
        METHOD PRIVATE InvokeSequence
            THIS.InitializeSequence();
            _step_1.Initialize(_context);
            _step_2.Initialize(_context);
            _step_3.Initialize(_context);        
            _sequencer.Invoke();
        END_METHOD
       
        METHOD PRIVATE PrepareSequence
            THIS.InvokeSequence();

            _sequencer.Open();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);           
            _context.Close();
        END_METHOD

        METHOD PRIVATE ExecuteSequence
            VAR_INPUT
                CompleteStep : BOOL;
                CompleteSequence : BOOL;
            END_VAR

            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();

            IF _step_1.Execute(_sequencer) THEN
                IF CompleteStep THEN
                    _sequencer.MoveNext();
                END_IF;
            END_IF;
            IF _step_2.Execute(_sequencer) THEN
                IF CompleteStep THEN
                    _sequencer.MoveNext();
                END_IF;
            END_IF;
            IF _step_3.Execute(_sequencer) THEN
                IF CompleteSequence THEN
                    _sequencer.CompleteSequence();
                END_IF;
            END_IF;
            _context.Close();
        END_METHOD
       
        {Test}
        METHOD PUBLIC should_be_in_idle
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}
        METHOD PUBLIC should_be_in_idle_after_initialization
            THIS.InitializeSequence();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}        
        METHOD PUBLIC Open_when_idle_should_transit_to_configuring
            THIS.InvokeSequence();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            _sequencer.Open();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}        
        METHOD PUBLIC Open_when_configuring_should_transit_to_running
            THIS.InvokeSequence();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            _sequencer.Open();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            _sequencer.Open();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Running , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}        
        METHOD PUBLIC order_of_steps_should_be_assigned_after_first_sequence_cycle
            THIS.InvokeSequence();
            _sequencer.Open();
            // Configuring steps no step should execute
             _step_1.Execute(_sequencer);
             _step_2.Execute(_sequencer);
             _step_3.Execute(_sequencer);           
             Assert.Equal(ULINT#1,_step_1.Order);
             Assert.Equal(ULINT#2,_step_2.Order);
             Assert.Equal(ULINT#3,_step_3.Order);
        END_METHOD

        {Test}        
        METHOD PUBLIC no_step_should_be_executed_when_configuring
            THIS.InvokeSequence();
            _sequencer.Open();
            // Configuring steps no step should execute
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            Assert.Equal(FALSE,_step_1.Execute(_sequencer));
            Assert.Equal(FALSE,_step_2.Execute(_sequencer));
            Assert.Equal(FALSE,_step_3.Execute(_sequencer));           
        END_METHOD

        {Test}        
        METHOD PUBLIC Execute_should_return_true_when_the_step_is_executing
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            Assert.Equal(TRUE , _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
        END_METHOD

        {Test}        
        METHOD PUBLIC IsActive_should_be_true_when_the_step_is_in_the_order_of_the_execution
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);
            Assert.Equal(TRUE , _step_1.IsActive);
            Assert.Equal(FALSE, _step_2.IsActive);
            Assert.Equal(FALSE, _step_3.IsActive);
        END_METHOD

        {Test}        
        METHOD PUBLIC Currently_executed_step_should_be_Busy
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);
            Assert.Equal(TRUE , _step_1.IsBusy());
            Assert.Equal(FALSE, _step_2.IsBusy());
            Assert.Equal(FALSE, _step_3.IsBusy());
        END_METHOD

        {Test}        
        METHOD PUBLIC All_steps_except_the_currently_executed_one_should_be_Disabled
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);
            Assert.Equal(FALSE, _step_1.IsDisabled);
            Assert.Equal(TRUE , _step_2.IsDisabled);
            Assert.Equal(TRUE , _step_3.IsDisabled);
        END_METHOD

        {Test}        
        METHOD PUBLIC MoveNext_should_set_currently_executed_step_to_Done
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            _step_1.Execute(_sequencer);
            Assert.Equal(FALSE, _step_1.IsDone());
            _sequencer.MoveNext();
            Assert.Equal(TRUE, _step_1.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC MoveNext_should_reset_the_Busy_state_of_the_currently_executed_step
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            _step_1.Execute(_sequencer);
            Assert.Equal(TRUE, _step_1.IsBusy());
            _sequencer.MoveNext();
            Assert.Equal(FALSE, _step_1.IsBusy());
        END_METHOD

        {Test}        
        METHOD PUBLIC MoveNext_should_increment_the_Current_Order
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
            _step_1.Execute(_sequencer);
            _sequencer.MoveNext();
            Assert.Equal(ULINT#2, _sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC MoveNext_should_trigger_the_execution_of_the_following_step
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            Assert.Equal(TRUE, _step_1.Execute(_sequencer));
            _sequencer.MoveNext();
            Assert.Equal(TRUE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
            _context.Close();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(TRUE, _step_2.Execute(_sequencer));
            _sequencer.MoveNext();
            Assert.Equal(TRUE, _step_3.Execute(_sequencer));  
            _context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC RequestStep_should_not_affect_the_sequence_when_the_coordinator_is_in_idle
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            _sequencer.RequestStep(_step_3); 
            _sequencer.Open();
            // Configuring steps no step should execute
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
        END_METHOD

        {Test}
        METHOD PUBLIC RequestStep_should_not_affect_the_sequence_when_the_coordinator_is_in_configuring
            THIS.InvokeSequence();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            _sequencer.Open();
            // Configuring steps no step should execute
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            _sequencer.RequestStep(_step_3); 
            _context.Close();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            Assert.Equal(TRUE , _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));          
        END_METHOD

        {Test}        
        METHOD PUBLIC RequestStep_should_set_currently_executed_step_to_Done
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            _step_1.Execute(_sequencer);
            Assert.Equal(FALSE, _step_1.IsDone());
            _sequencer.RequestStep(_step_3);
            Assert.Equal(TRUE, _step_1.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC RequestStep_should_reset_the_Busy_state_of_the_currently_executed_step
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            _step_1.Execute(_sequencer);
            Assert.Equal(TRUE, _step_1.IsBusy());
            _sequencer.RequestStep(_step_3);
            Assert.Equal(FALSE, _step_1.IsBusy());
        END_METHOD

        {Test}        
        METHOD PUBLIC RequestStep_should_change_the_Current_Order_to_the_order_of_the_required_step
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
            _step_1.Execute(_sequencer);
            _sequencer.RequestStep(_step_3);
            Assert.Equal(_step_3.GetStepOrder(), _sequencer.CurrentOrder);
        END_METHOD

        {Test}
        METHOD PUBLIC RequestStep_should_start_the_execution_of_the_required_step_when_the_coordinator_is_running
            THIS.PrepareSequence();

            _context.Open();
           _sequencer.Open();
            // Steps are configured first step should execute
            Assert.Equal(TRUE , _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
            _context.Close();

            _context.Open();
           _sequencer.Open();
            // RequestStep should finish execution of the _stepOne and start the execution of the _stepThree
            _sequencer.RequestStep(_step_3); 
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(TRUE , _step_3.Execute(_sequencer));          
            _context.Close();

            _context.Open();
            _sequencer.Open();
            // RequestStep should finish execution of the _stepThree and start the execution of the _stepTwo
            _sequencer.RequestStep(_step_2); 
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(TRUE,  _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));          
        END_METHOD

        {Test}
        METHOD PUBLIC Step_order_assignement_should_be_performed_even_when_the_steps_are_disabled
            THIS.InvokeSequence();
            _sequencer.Open();
            Assert.Equal(ULINT#0,_step_1.GetStepOrder());
            Assert.Equal(ULINT#0,_step_2.GetStepOrder());
            Assert.Equal(ULINT#0,_step_3.GetStepOrder());
            // Configuring steps no step should execute no mather if Enabled or Disabled
            Assert.Equal(FALSE,_step_1.Execute(_sequencer,FALSE));
            Assert.Equal(FALSE,_step_2.Execute(_sequencer,FALSE));
            Assert.Equal(FALSE,_step_3.Execute(_sequencer,FALSE));  

            Assert.Equal(ULINT#1,_step_1.GetStepOrder());
            Assert.Equal(ULINT#2,_step_2.GetStepOrder());
            Assert.Equal(ULINT#3,_step_3.GetStepOrder());
        END_METHOD

        {Test}
        METHOD PUBLIC Disabled_step_should_be_skipped_even_when_it_is_in_the_order_of_the_execution
            THIS.PrepareSequence();

            // Steps are configured, so the first Enabled step should execute
            _context.Open();
            _sequencer.Open();
            Assert.Equal(ULINT#1,_sequencer.CurrentOrder);
            Assert.Equal(FALSE,_step_1.Execute(_sequencer,FALSE));
            Assert.Equal(ULINT#2,_sequencer.CurrentOrder);
            Assert.Equal(TRUE,_step_2.Execute(_sequencer,TRUE));
            Assert.Equal(FALSE,_step_3.Execute(_sequencer,TRUE));  
        END_METHOD

        {Test}
        METHOD PUBLIC RequestStep_should_not_start_the_disabled_step_but_the_next_one_enabled
            THIS.PrepareSequence();

           // Steps are configured, so the first Enabled step (in this case _stepTwo) should be executed
            _context.Open();
            _sequencer.Open();
            Assert.Equal(FALSE,_step_1.Execute(_sequencer,FALSE));
            Assert.Equal(TRUE ,_step_2.Execute(_sequencer,TRUE));
            Assert.Equal(FALSE,_step_3.Execute(_sequencer,TRUE));  
            _context.Close();

            // After MoveNext() method is called, _stepThree should start to be executed, as it is Enabled
            _context.Open();
            _sequencer.Open();
            Assert.Equal(FALSE,_step_1.Execute(_sequencer,FALSE));
            Assert.Equal(TRUE ,_step_2.Execute(_sequencer,TRUE));
            _sequencer.MoveNext();
            Assert.Equal(TRUE ,_step_3.Execute(_sequencer,TRUE));  
            _context.Close();

            // RequestStep to _stepOne should finish the execution of the _stepThree and prepare for the execution of the _stepOne
            // As _stepOne is disabled, its next proceeding step enabled (in our cas _stepTwo) starts to be executed
            _context.Open();
            _sequencer.Open();
            _sequencer.RequestStep(_step_1);
            Assert.Equal(ULINT#1,_sequencer.CurrentOrder);
            Assert.Equal(FALSE,_step_1.Execute(_sequencer,FALSE));
            Assert.Equal(ULINT#2,_sequencer.CurrentOrder);
            Assert.Equal(TRUE,_step_2.Execute(_sequencer,TRUE));
            Assert.Equal(FALSE,_step_3.Execute(_sequencer,TRUE));  
        END_METHOD

        METHOD MAIN_12x 
            _step_1.Initialize(_context);
            _step_2.Initialize(_context);
            _step_3.Initialize(_context);
            _sequencer.Initialize(_context);
            _sequencer.Invoke();

            _sequencer.Open();
            
            IF(_step_1.Execute(_sequencer)) THEN  
                _orderCounter := _orderCounter + _step_1.GetStepOrder();
                _sequencer.MoveNext();
            END_IF;    
           
            IF(_step_2.Execute(_sequencer)) THEN
                _orderCounter := _orderCounter + _step_2.GetStepOrder();
                _sequencer.MoveNext();
            END_IF; 
        END_METHOD

        METHOD MAIN_12 
            THIS.MAIN_12x();
            _sequencer.CompleteSequence();
        END_METHOD

        METHOD MAIN_123 
            THIS.MAIN_12x();
            IF(_step_3.Execute(_sequencer)) THEN
                _orderCounter := _orderCounter + _step_3.GetStepOrder();
                _sequencer.MoveNext();
            END_IF; 
            _sequencer.CompleteSequence();
        END_METHOD

        METHOD MAIN_122 
            THIS.MAIN_12x();

            IF(_step_2.Execute(_sequencer)) THEN
                _orderCounter := _orderCounter + ULINT#1000;
                _sequencer.MoveNext();
            END_IF; 
            _sequencer.CompleteSequence();
        END_METHOD

        {Test}
        METHOD PUBLIC step_called_more_then_once_inside_the_running_sequence_should_not_be_executed
            VAR 
                StepOrderLastValue : ULINT;
            END_VAR
            Assert.Equal(ULINT#0, _orderCounter);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            //First sequence run, no step is executed
            _context.Open();
            THIS.MAIN_123();
            _context.Close();
            Assert.Equal(ULINT#0, _orderCounter);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            StepOrderLastValue := _orderCounter;
            //Second sequence run, steps are going already to be executed.
            //Steps are called in the order: step_1, step_2, step_3.
            //Step body should be executed for step_1, step_2 and step_3
            //Sequence should stay in the Idle state as the CompleteSequence() was called on running sequence
            _context.Open();
            THIS.MAIN_123();
            _context.Close();
            Assert.Equal(ULINT#6, _orderCounter - StepOrderLastValue);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            StepOrderLastValue := _orderCounter;
            //First sequence run after CompleteSequence() call on running sequence
            //No steps are going to be executed, as the orders of the steps need to be assign again
            _context.Open();
            THIS.MAIN_123();
            _context.Close();
            Assert.Equal(ULINT#0, _orderCounter - StepOrderLastValue);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            StepOrderLastValue := _orderCounter;
            //Steps are called in the order: step_1,step_2, step_2.
            //Step body should be executed only for step_1 and for first call of the step_2 
            //Sequence should stay in the Idle state as the CompleteSequence() was called on running sequence
            _context.Open();
            THIS.MAIN_122();
            _context.Close();
            Assert.Equal(ULINT#3, _orderCounter - StepOrderLastValue);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}
        METHOD PUBLIC step_called_more_then_once_inside_the_configuring_sequence_should_set_the_sequence_to_idle //TODO error state
            Assert.Equal(ULINT#0, _orderCounter);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            //First sequence run, no step is executed
            _context.Open();
            THIS.MAIN_12x();
            Assert.Equal(FALSE, _step_1.IsActive);
            Assert.Equal(FALSE, _step_2.IsActive);
            Assert.Equal(FALSE, _step_3.IsActive); 
            Assert.Equal(ULINT#1, _step_1.Order);
            Assert.Equal(ULINT#2, _step_2.Order);
            Assert.Equal(ULINT#0, _step_3.Order); 
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            _step_2.Execute(_sequencer);
            _context.Close();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            Assert.Equal(FALSE, _step_1.IsActive);
            Assert.Equal(FALSE, _step_2.IsActive);
            Assert.Equal(FALSE, _step_3.IsActive); 
            Assert.Equal(ULINT#1, _step_1.Order);
            Assert.Equal(ULINT#0, _step_2.Order);
            Assert.Equal(ULINT#0, _step_3.Order); 
        END_METHOD

        {Test}
        METHOD PUBLIC step_that_was_not_called_in_the_previous_PLC_cycle_should_not_be_executed_even_if_it_is_on_the_order_of_the_execution
            VAR 
                StepOrderLastValue : ULINT;
            END_VAR
            Assert.Equal(ULINT#0, _orderCounter);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            //First sequence run, no step is executed
            _context.Open();
            THIS.MAIN_123();
            _context.Close();
            Assert.Equal(ULINT#0, _orderCounter);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            StepOrderLastValue := _orderCounter;
            //Second sequence run, steps are going already to be executed.
            //Steps are called in the order: step_1, step_2.
            //Step body should be executed for step_1 and step_2.
            _context.Open();
            THIS.MAIN_12x();
            _context.Close();
            Assert.Equal(ULINT#3, _orderCounter - StepOrderLastValue);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Running , _sequencer.GetCoordinatorState()));
            StepOrderLastValue := _orderCounter;
            // Assert.Equal(TRUE,_sequencer.IsInOrderOfExecution(_step_3));
            Assert.Equal(_sequencer.CurrentOrder,_step_3.Order);
            //Steps are called in the order: step_1,step_2, step_3.
            //Step_1 and step_2 has been already executed. 
            //Step_3 is in the order of the execution, but it is not going to be executed, as it was not called in the previous PLC cycle.
            _context.Open();
            THIS.MAIN_123();
            _context.Close();
            Assert.Equal(ULINT#0, _orderCounter - StepOrderLastValue);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
        END_METHOD    
        
        {Test}        
        METHOD PUBLIC CompleteSequence_should_set_currently_executed_step_to_Done
            THIS.ExecuteSequence(TRUE,FALSE);
            Assert.Equal(FALSE, _step_3.IsDone());
            _sequencer.CompleteSequence();
            Assert.Equal(TRUE, _step_3.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC CompleteSequence_should_reset_the_Busy_state_of_the_currently_executed_step
            THIS.ExecuteSequence(TRUE,FALSE);
            Assert.Equal(TRUE, _step_3.IsBusy());
            _sequencer.CompleteSequence();
            Assert.Equal(FALSE, _step_3.IsBusy());
        END_METHOD

        {Test}        
        METHOD PUBLIC CompleteSequence_should_set_the_Current_Order_to_1
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.CompleteSequence();
            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC CompleteSequence_should_set_the_coordinator_state_to_Idle
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.CompleteSequence();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}        
        METHOD PUBLIC CompleteSequence_should_set_the_first_step_in_the_sequence_as_active_after_two_PLC_cycle
            THIS.ExecuteSequence(TRUE,FALSE);
            Assert.Equal(TRUE, _step_3.IsBusy());
            _sequencer.CompleteSequence();
            _context.Close();

            _context.Open();
            _sequencer.Open();
            // Steps are configuring again
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
            Assert.Equal(FALSE, _step_1.IsActive);              
            _context.Close();

            _context.Open();
            _sequencer.Open();
            // Steps are configuredand executed again
            Assert.Equal(TRUE , _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
            Assert.Equal(TRUE , _step_1.IsActive);              
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC currently_executed_step_should_indicate_its_state_as_busy
            THIS.PrepareSequence();
            
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring, _sequencer.GetCoordinatorState()));
            Assert.Equal(TRUE, THIS.Equal(eIxTaskState#Disabled, _step_1.GetState()));

            _context.Open();
            _sequencer.Open();
            Assert.Equal(TRUE ,  _step_1.Execute(_sequencer));
            Assert.Equal(TRUE , THIS.Equal(eIxTaskState#Busy, _step_1.GetState()));
            Assert.Equal(TRUE , _step_1.IsBusy());
            Assert.Equal(FALSE, _step_1.IsDone());
            Assert.Equal(FALSE, _step_1.HasError());
        END_METHOD

        {Test}        
        METHOD PUBLIC when_sequence_is_configuring_all_steps_should_be_disabled
            THIS.InvokeSequence();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            _sequencer.Open();
            // Configuring steps no step should execute
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));           
            Assert.Equal(FALSE, _step_1.IsBusy());
            Assert.Equal(FALSE, _step_1.IsDone());
            Assert.Equal(FALSE, _step_2.IsBusy());
            Assert.Equal(FALSE, _step_2.IsDone());
            Assert.Equal(FALSE, _step_3.IsBusy());
            Assert.Equal(FALSE, _step_3.IsDone());
            Assert.Equal(TRUE , _step_1.GetState() = eIxTaskState#Disabled);
            Assert.Equal(TRUE , _step_2.GetState() = eIxTaskState#Disabled);
            Assert.Equal(TRUE , _step_3.GetState() = eIxTaskState#Disabled);
            _context.Close();
            Assert.Equal(TRUE , THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}        
        METHOD PUBLIC step_exited_with_move_next_method_should_indicate_its_state_as_done
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            Assert.Equal(TRUE ,  _step_1.Execute(_sequencer));
            _sequencer.MoveNext();
            Assert.Equal(TRUE , THIS.Equal(eIxTaskState#Done, _step_1.GetState()));
            Assert.Equal(FALSE, _step_1.IsBusy());
            Assert.Equal(TRUE , _step_1.IsDone());
            Assert.Equal(FALSE, _step_1.HasError());
        END_METHOD

        {Test}        
        METHOD PUBLIC step_exited_with_move_next_method_should_indicate_its_state_as_done_even_in_another_PLC_cycle
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            // Steps are configured first step should execute
            Assert.Equal(TRUE, _step_1.Execute(_sequencer));
            Assert.Equal(TRUE, _step_1.IsBusy());
            _sequencer.MoveNext();
            Assert.Equal(TRUE, _step_1.IsDone());
            Assert.Equal(TRUE, _step_2.Execute(_sequencer));
            Assert.Equal(TRUE, _step_2.IsBusy());
            Assert.Equal(FALSE, _step_2.IsDone());
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
            Assert.Equal(FALSE, _step_3.IsBusy());
            Assert.Equal(FALSE, _step_3.IsDone());
            _context.Close();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Running , _sequencer.GetCoordinatorState()));

            _context.Open();
            _sequencer.Open();
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_1.IsBusy());
            Assert.Equal(TRUE , _step_1.IsDone());
            Assert.Equal(TRUE , _step_2.Execute(_sequencer));
            Assert.Equal(TRUE , _step_2.IsBusy());
            Assert.Equal(FALSE, _step_2.IsDone());
            _sequencer.MoveNext();
            Assert.Equal(FALSE, _step_2.IsBusy());
            Assert.Equal(TRUE , _step_2.IsDone());
            Assert.Equal(TRUE , _step_3.Execute(_sequencer));  
            Assert.Equal(TRUE , _step_3.IsBusy());
            Assert.Equal(FALSE, _step_3.IsDone());
            _context.Close();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Running , _sequencer.GetCoordinatorState()));

            _context.Open();
            _sequencer.Open();
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(TRUE , _step_3.Execute(_sequencer)); 
            Assert.Equal(FALSE, _step_1.IsBusy());
            Assert.Equal(TRUE , _step_1.IsDone());
            Assert.Equal(FALSE, _step_2.IsBusy());
            Assert.Equal(TRUE , _step_2.IsDone());
            Assert.Equal(TRUE , _step_3.IsBusy());
            Assert.Equal(FALSE, _step_3.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC sequence_should_be_in_configuring_state_after_complete_sequence_and_all_steps_should_be_restored
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.CompleteSequence();
            _context.Close();

            _context.Open();
            _sequencer.Open();

            // Configuring steps no step should execute
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));           
            Assert.Equal(FALSE, _step_1.IsBusy());
            Assert.Equal(FALSE, _step_1.IsDone());
            Assert.Equal(FALSE, _step_2.IsBusy());
            Assert.Equal(FALSE, _step_2.IsDone());
            Assert.Equal(FALSE, _step_3.IsBusy());
            Assert.Equal(FALSE, _step_3.IsDone());
            Assert.Equal(TRUE , _step_1.GetState() = eIxTaskState#Disabled);
            Assert.Equal(TRUE , _step_2.GetState() = eIxTaskState#Disabled);
            Assert.Equal(TRUE , _step_3.GetState() = eIxTaskState#Disabled);
            _context.Close();
            Assert.Equal(TRUE , THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}
        METHOD PUBLIC multiple_calls_of_the_method_IsCalledJustOnceInThisPlcCycle_should_return_same_value
            THIS.PrepareSequence();

            _context.Open();
            _sequencer.Open();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);
            _step_3.Execute(_sequencer);

            Assert.Equal(TRUE ,_step_1.IsCalledJustOnceInThisPlcCycle());
            Assert.Equal(TRUE ,_step_1.IsCalledJustOnceInThisPlcCycle());
            Assert.Equal(FALSE,_step_3.IsCalledJustOnceInThisPlcCycle());
            Assert.Equal(FALSE,_step_3.IsCalledJustOnceInThisPlcCycle());
        END_METHOD

        {Test}
        METHOD PUBLIC OpenCycleCount_should_be_one_greather_than_ClosedCycleCount_before_calling_context_Close
            _context.Open();
            Assert.Equal(_context.OpenCycleCount() ,_context.ClosedCycleCount() + ULINT#1);
            _context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC OpenCycleCount_should_the_same_as_ClosedCycleCount_after_calling_context_Close
            _context.Open();
            _context.Close();
            Assert.Equal(_context.OpenCycleCount() ,_context.ClosedCycleCount());
        END_METHOD

        {Test}
        METHOD PUBLIC should_return_the_continous_stepping_mode
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#Continous));
        END_METHOD
        
        {Test}
        METHOD PUBLIC should_return_the_step_by_step_stepping_mode
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#StepByStep));
        END_METHOD
        
        {Test}
        METHOD PUBLIC should_return_the_cyclic_mode
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SequenceMode, eIxSequenceMode#Cyclic));
        END_METHOD
        
        {Test}
        METHOD PUBLIC should_return_the_runonce_mode
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SequenceMode, eIxSequenceMode#RunOnce));
        END_METHOD
        
        {Test}        
        METHOD PUBLIC RunOnce_mode_CompleteSequence_should_set_currently_executed_step_to_Done
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            Assert.Equal(FALSE, _step_3.IsDone());
            _sequencer.CompleteSequence();
            Assert.Equal(TRUE, _step_3.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC RunOnce_mode_CompleteSequence_should_reset_the_Busy_state_of_the_currently_executed_step
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            Assert.Equal(TRUE, _step_3.IsBusy());
            _sequencer.CompleteSequence();
            Assert.Equal(FALSE, _step_3.IsBusy());
        END_METHOD

        {Test}        
        METHOD PUBLIC RunOnce_mode_CompleteSequence_should_set_the_Current_Order_to_1
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.CompleteSequence();
            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC RunOnce_mode_CompleteSequence_should_set_the_coordinator_state_to_Idle
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.CompleteSequence();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
        END_METHOD

        {Test}        
        METHOD PUBLIC RunOnce_mode_CompleteSequence_should_set_the_CurrentOrder_to_1
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.CompleteSequence();
            _context.Close();

            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC RunOnce_mode_CompleteSequence_should_stops_the_execution_of_the_active_step_in_the_next_PLC_cycles
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.CompleteSequence();
            _context.Close();

            _context.Open();
            _sequencer.Open();
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
            _context.Close();

            _context.Open();
            _sequencer.Open();
            Assert.Equal(FALSE, _step_1.Execute(_sequencer));
            Assert.Equal(FALSE, _step_2.Execute(_sequencer));
            Assert.Equal(FALSE, _step_3.Execute(_sequencer));  
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC RunOnce_mode_CompleteSequence_coordinator_state_should_stay_in_Idle_in_the_next_PLC_cycles
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.CompleteSequence();
            _context.Close();

            _context.Open();
            _sequencer.Open();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);  
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            _context.Close();

            _context.Open();
            _sequencer.Open();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);  
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Idle , _sequencer.GetCoordinatorState()));
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC should_return_number_of_steps_in_our_case_three
            THIS.ExecuteSequence(TRUE,FALSE);
            Assert.Equal(ULINT#3, _sequencer.GetNumberOfConfiguredSteps());
        END_METHOD
        
        {Test}        
        METHOD PUBLIC all_stepping_commands_should_be_disabled_when_StepByStep_mode_is_not_running
            THIS.ExecuteSequence(TRUE,FALSE);
            Assert.Equal(TRUE,_sequencer.StepForwardCommand.IsDisabled);
            Assert.Equal(TRUE,_sequencer.StepIn.IsDisabled);
            Assert.Equal(TRUE,_sequencer.StepBackwardCommand.IsDisabled);
        END_METHOD
        
        {Test}        
        METHOD PUBLIC all_stepping_commands_should_be_disabled_when_Sequencer_is_not_running_mode
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#StepByStep));
            THIS.PrepareSequence();
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Configuring , _sequencer.GetCoordinatorState()));
            Assert.Equal(TRUE,_sequencer.StepForwardCommand.IsDisabled);
            Assert.Equal(TRUE,_sequencer.StepIn.IsDisabled);
            Assert.Equal(TRUE,_sequencer.StepBackwardCommand.IsDisabled);
        END_METHOD

        {Test}        
        METHOD PUBLIC StepForward_and_StepIn_commands_should_not_be_disabled_when_Sequencer_is_running_mode
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#StepByStep));
            THIS.ExecuteSequence(TRUE,TRUE);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Running , _sequencer.GetCoordinatorState()));
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsDisabled);
            Assert.Equal(FALSE,_sequencer.StepIn.IsDisabled);
        END_METHOD

        {Test}        
        METHOD PUBLIC StepBackward_command_should_not_be_disabled_when_Sequencer_is_running_mode_and_CurrentOrder_is_greather_then_one
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#StepByStep));
            THIS.ExecuteSequence(TRUE,TRUE);
            _sequencer.RequestStep(_step_2);
            THIS.ExecuteSequence(TRUE,TRUE);
            Assert.Equal(TRUE, THIS.Equal(CoordinatorStates#Running , _sequencer.GetCoordinatorState()));
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsDisabled);
        END_METHOD

        {Test}        
        METHOD PUBLIC StepInCommand_should_invoke_the_current_step
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#StepByStep));
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
            Assert.Equal(TRUE,_step_1.IsActive);
            Assert.Equal(TRUE,_step_1.IsReady());
            Assert.Equal(FALSE,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.IsDone());
            Assert.Equal(FALSE,_sequencer.StepIn.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepIn.IsDone());

            // Act
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            // Assert
            Assert.Equal(TRUE ,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(TRUE ,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.IsDone());
            Assert.Equal(TRUE ,_sequencer.StepIn.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepIn.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepInCommand_should_invoke_the_current_step_if_Current_step_is_Done_StepIn_should_be_also_Done
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#StepByStep));
            THIS.ExecuteSequence(TRUE,FALSE);
            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
            Assert.Equal(TRUE,_step_1.IsActive);
            Assert.Equal(TRUE,_step_1.IsReady());
            Assert.Equal(FALSE,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.IsDone());
            Assert.Equal(FALSE,_sequencer.StepIn.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepIn.IsDone());

            // Act
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(TRUE,FALSE);

            // Assert
            Assert.Equal(FALSE,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(FALSE,_step_1.IsBusy());
            Assert.Equal(TRUE ,_step_1.IsDone());
            Assert.Equal(FALSE,_sequencer.StepIn.IsBusy());
            Assert.Equal(TRUE ,_sequencer.StepIn.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC when_step_by_step_mode_is_switched_on_during_any_step_execution_this_step_should_continue_its_execution
            // Arrange
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
            Assert.Equal(TRUE ,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(TRUE ,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.IsDone());

            Assert.Equal(FALSE,_step_2.IsActive);
            Assert.Equal(FALSE,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());

            // Act
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#StepByStep));
            THIS.ExecuteSequence(TRUE,FALSE);

            // Assert
            Assert.Equal(FALSE,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(FALSE,_step_1.IsBusy());
            Assert.Equal(TRUE ,_step_1.IsDone());

            Assert.Equal(TRUE ,_step_2.IsActive);
            Assert.Equal(TRUE ,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepForward
            VAR
                _previousOrder : ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(TRUE ,_sequencer.StepForwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsDone());
            
            Assert.Equal(FALSE,_sequencer.StepIn.IsReady());
            Assert.Equal(TRUE ,_sequencer.StepIn.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepIn.IsDone());

            Assert.Equal(TRUE ,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(TRUE ,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.IsDone());

            Assert.Equal(FALSE,_step_2.IsActive);
            Assert.Equal(FALSE,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());

            _previousOrder := _sequencer.CurrentOrder;
            
            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepForwardCommand.Invoke();
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsDone());
            _step_1.Execute(_sequencer);
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsBusy());
            Assert.Equal(TRUE ,_sequencer.StepForwardCommand.IsDone());
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);

            // Assert
            Assert.Equal(FALSE,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(FALSE,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.IsDone());

            Assert.Equal(TRUE ,_step_2.IsActive);
            Assert.Equal(TRUE ,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());

            Assert.Equal(_previousOrder + ULINT#1  ,_sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC StepForward_should_restore_the_currently_executing_step
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(TRUE ,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(TRUE ,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.IsDone());

            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepForwardCommand.Invoke();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);
            _context.Close();

            // Assert
            Assert.Equal(FALSE,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(FALSE,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepForward_should_prepare_following_step_to_be_ready_to_execute
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(FALSE,_step_2.IsActive);
            Assert.Equal(FALSE,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());

            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepForwardCommand.Invoke();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);

            // Assert
            Assert.Equal(TRUE ,_step_2.IsActive);
            Assert.Equal(TRUE ,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepForward_command_should_be_in_done_state_after_succesfull_execution
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(TRUE ,_sequencer.StepForwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsDone());
            
            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepForwardCommand.Invoke();

            //Assert
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsDone());
            _step_1.Execute(_sequencer);
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsBusy());
            Assert.Equal(TRUE ,_sequencer.StepForwardCommand.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepForward_command_should_increment_Current_order_if_its_value_is_lower_then_number_of_steps
            VAR
                _previousOrder : ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);
            _previousOrder := _sequencer.CurrentOrder;

            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepForwardCommand.Invoke();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);
            _context.Close();
            
            //Assert
            Assert.Equal(_previousOrder + ULINT#1,_sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC StepForward_command_should_not_increment_Current_order_if_its_value_is_equal_to_number_of_steps
            VAR
                _previousOrder : ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.RequestStep(_step_3);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);
            _previousOrder := _sequencer.CurrentOrder;

            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepForwardCommand.Invoke();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);
            _context.Close();
            
            //Assert
            Assert.Equal(_previousOrder,_sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC StepForward_command_should_be_disabled_when_CurrentOrder_is_equal_to_last_step_order
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.RequestStep(_step_3);
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(ULINT#3,_sequencer.CurrentOrder);
            Assert.Equal(TRUE ,_sequencer.StepForwardCommand.IsDisabled);
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepForwardCommand.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepBackward
            VAR
                _previousOrder : ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.RequestStep(_step_3);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(TRUE ,_sequencer.StepBackwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsDone());
            
            Assert.Equal(FALSE,_sequencer.StepIn.IsReady());
            Assert.Equal(TRUE ,_sequencer.StepIn.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepIn.IsDone());

            Assert.Equal(TRUE ,_step_3.IsActive);
            Assert.Equal(FALSE,_step_3.IsReady());
            Assert.Equal(TRUE ,_step_3.IsBusy());
            Assert.Equal(FALSE,_step_3.IsDone());

            Assert.Equal(FALSE,_step_2.IsActive);
            Assert.Equal(FALSE,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());

            _previousOrder := _sequencer.CurrentOrder;
            
            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepBackwardCommand.Invoke();
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsDone());
            _step_1.Execute(_sequencer);
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsBusy());
            Assert.Equal(TRUE ,_sequencer.StepBackwardCommand.IsDone());
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);

            // Assert
            Assert.Equal(FALSE,_step_3.IsActive);
            Assert.Equal(FALSE,_step_3.IsReady());
            Assert.Equal(FALSE,_step_3.IsBusy());
            Assert.Equal(FALSE,_step_3.IsDone());

            Assert.Equal(TRUE ,_step_2.IsActive);
            Assert.Equal(TRUE ,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());

            Assert.Equal(_previousOrder - ULINT#1  ,_sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC StepBackward_should_restore_the_currently_executing_step
            VAR
                _previousOrder : ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.RequestStep(_step_3);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(TRUE ,_step_3.IsActive);
            Assert.Equal(FALSE,_step_3.IsReady());
            Assert.Equal(TRUE ,_step_3.IsBusy());
            Assert.Equal(FALSE,_step_3.IsDone());

            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepBackwardCommand.Invoke();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);

            // Assert
            Assert.Equal(FALSE,_step_3.IsActive);
            Assert.Equal(FALSE,_step_3.IsReady());
            Assert.Equal(FALSE,_step_3.IsBusy());
            Assert.Equal(FALSE,_step_3.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepBackward_should_prepare_previous_step_to_be_ready_to_execute
            VAR
                _previousOrder : ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.RequestStep(_step_3);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(FALSE,_step_2.IsActive);
            Assert.Equal(FALSE,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());
            
            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepBackwardCommand.Invoke();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);

            // Assert
            Assert.Equal(TRUE ,_step_2.IsActive);
            Assert.Equal(TRUE ,_step_2.IsReady());
            Assert.Equal(FALSE,_step_2.IsBusy());
            Assert.Equal(FALSE,_step_2.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepBackward_command_should_be_in_done_state_after_succesfull_execution
            VAR
                _previousOrder : ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.RequestStep(_step_3);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(TRUE ,_sequencer.StepBackwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsDone());

            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepBackwardCommand.Invoke();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);

            // Assert
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsBusy());
            Assert.Equal(TRUE ,_sequencer.StepBackwardCommand.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepBackward_command_should_decrement_Current_order_if_its_value_is_higher_then_one
            VAR
                _previousOrder : ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.RequestStep(_step_3);
            _sequencer.StepIn.Invoke();
            THIS.ExecuteSequence(FALSE,FALSE);

            _previousOrder := _sequencer.CurrentOrder;
            
            // Act
            _context.Open();
            _sequencer.Open();
            _sequencer.StepBackwardCommand.Invoke();
            _step_1.Execute(_sequencer);
            _step_2.Execute(_sequencer);
            _step_3.Execute(_sequencer);

            // Assert
            Assert.Equal(_previousOrder - ULINT#1  ,_sequencer.CurrentOrder);
        END_METHOD

        {Test}        
        METHOD PUBLIC StepBackward_command_should_be_disabled_when_CurrentOrder_is_equal_to_last_step_order
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);

            Assert.Equal(ULINT#1,_sequencer.CurrentOrder);
            Assert.Equal(TRUE ,_sequencer.StepBackwardCommand.IsDisabled);
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsReady());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsBusy());
            Assert.Equal(FALSE,_sequencer.StepBackwardCommand.IsDone());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnBeforeSequenceStart_should_be_triggered_when_sequence_starts
            THIS._counter :=  _sequencer.GetOnBeforeSequenceStartCounter();
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(THIS._counter + ULINT#1,_sequencer.GetOnBeforeSequenceStartCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnBeforeSequenceStart_should_not_be_triggered_when_sequence_has_been_already_started
            THIS.ExecuteSequence(FALSE,FALSE);
            THIS._counter :=  _sequencer.GetOnBeforeSequenceStartCounter();
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(THIS._counter,_sequencer.GetOnBeforeSequenceStartCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnBeforeSequenceStart_should_be_triggered_when_sequence_starts_even_in_step_by_step_mode
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS._counter :=  _sequencer.GetOnBeforeSequenceStartCounter();
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(THIS._counter + ULINT#1,_sequencer.GetOnBeforeSequenceStartCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnBeforeSequenceStart_should_not_be_triggered_when_sequence_has_been_already_started_even_in_step_by_step_mode
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            THIS._counter :=  _sequencer.GetOnBeforeSequenceStartCounter();
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(THIS._counter,_sequencer.GetOnBeforeSequenceStartCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnBeforeSequenceStart_should_be_triggered_when_sequence_starts_even_in_run_once_mode
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            THIS._counter :=  _sequencer.GetOnBeforeSequenceStartCounter();
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(THIS._counter + ULINT#1,_sequencer.GetOnBeforeSequenceStartCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnBeforeSequenceStart_should_not_be_triggered_when_sequence_has_been_already_started_even_in_run_once_mode
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            THIS.ExecuteSequence(FALSE,FALSE);
            THIS._counter :=  _sequencer.GetOnBeforeSequenceStartCounter();
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(THIS._counter,_sequencer.GetOnBeforeSequenceStartCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnBeforeSequenceStart_should_be_triggered_when_sequence_starts_even_in_run_once_mode_and_step_by_step_mode
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS._counter :=  _sequencer.GetOnBeforeSequenceStartCounter();
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(THIS._counter + ULINT#1,_sequencer.GetOnBeforeSequenceStartCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnBeforeSequenceStart_should_not_be_triggered_when_sequence_has_been_already_started_even_in_run_once_mode_and_step_by_step_mode
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS.ExecuteSequence(FALSE,FALSE);
            THIS._counter :=  _sequencer.GetOnBeforeSequenceStartCounter();
            THIS.ExecuteSequence(FALSE,FALSE);
            Assert.Equal(THIS._counter,_sequencer.GetOnBeforeSequenceStartCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnCompleteSequence_should_be_triggered_when_CompleteSequence_is_called
            THIS.ExecuteSequence(TRUE,FALSE);
            THIS._counter :=  _sequencer.GetOnCompleteSequenceCounter();
            _sequencer.CompleteSequence();
            Assert.Equal(THIS._counter + ULINT#1,_sequencer.GetOnCompleteSequenceCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnCompleteSequence_should_not_be_triggered_when_CompleteSequence_was_already_called
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.CompleteSequence();
            THIS._counter :=  _sequencer.GetOnCompleteSequenceCounter();
            _sequencer.CompleteSequence();
            Assert.Equal(THIS._counter,_sequencer.GetOnCompleteSequenceCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnCompleteSequence_should_be_triggered_when_CompleteSequence_is_called_even_in_step_by_step_mode
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS._counter :=  _sequencer.GetOnCompleteSequenceCounter();
            _sequencer.CompleteSequence();
            Assert.Equal(THIS._counter + ULINT#1,_sequencer.GetOnCompleteSequenceCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnCompleteSequence_should_not_be_triggered_when_CompleteSequence_was_already_called_even_in_step_by_step_mode
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            _sequencer.CompleteSequence();
            THIS._counter :=  _sequencer.GetOnCompleteSequenceCounter();
            _sequencer.CompleteSequence();
            Assert.Equal(THIS._counter,_sequencer.GetOnCompleteSequenceCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnCompleteSequence_should_be_triggered_when_CompleteSequence_is_called_even_in_run_once_mode
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            THIS._counter :=  _sequencer.GetOnCompleteSequenceCounter();
            _sequencer.CompleteSequence();
            Assert.Equal(THIS._counter + ULINT#1,_sequencer.GetOnCompleteSequenceCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnCompleteSequence_should_not_be_triggered_when_CompleteSequence_was_already_called_even_in_run_once_mode
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.CompleteSequence();
            THIS._counter :=  _sequencer.GetOnCompleteSequenceCounter();
            _sequencer.CompleteSequence();
            Assert.Equal(THIS._counter,_sequencer.GetOnCompleteSequenceCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnCompleteSequence_should_be_triggered_when_CompleteSequence_is_called_even_in_run_once_mode_and_step_by_step_mode
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            THIS._counter :=  _sequencer.GetOnCompleteSequenceCounter();
            _sequencer.CompleteSequence();
            Assert.Equal(THIS._counter + ULINT#1,_sequencer.GetOnCompleteSequenceCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC OnCompleteSequence_should_not_be_triggered_when_CompleteSequence_was_already_called_even_in_run_once_mode_and_step_by_step_mode
            THIS.ExecuteSequence(TRUE,FALSE);
            _sequencer.SequenceMode := eIxSequenceMode#RunOnce;
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            _sequencer.CompleteSequence();
            THIS._counter :=  _sequencer.GetOnCompleteSequenceCounter();
            _sequencer.CompleteSequence();
            Assert.Equal(THIS._counter,_sequencer.GetOnCompleteSequenceCounter());
        END_METHOD

        {Test}        
        METHOD PUBLIC StepInCommand_should_restore_and_invoke_the_current_step_when_it_was_in_error_state
            VAR 
                count :ULINT;
            END_VAR
            // Arrange
            _sequencer.SteppingMode := eIxSteppingMode#StepByStep;
            Assert.Equal(TRUE ,THIS.Equal(_sequencer.SteppingMode, eIxSteppingMode#StepByStep));

            THIS.ExecuteSequence(FALSE,FALSE);
            _sequencer.StepIn.Invoke();

            THIS.PrepareSequence();
            _context.Open();
            _sequencer.Open();

            IF _step_1.Execute(_sequencer) THEN
                count := count + ULINT#1;
                _step_1.ThrowWhen(TRUE);
            END_IF;
            _step_2.Execute(_sequencer); 
            _step_3.Execute(_sequencer); 
            _context.Close();

            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
            Assert.Equal(TRUE,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(FALSE,_step_1.IsBusy());
            Assert.Equal(TRUE,_step_1.HasError());
            Assert.Equal(ULINT#1, count);

            // Act
            _sequencer.StepIn.Invoke();

            THIS.PrepareSequence();
            _context.Open();
            _sequencer.Open();

            IF _step_1.Execute(_sequencer) THEN
                count := count + ULINT#1;
            END_IF;
            _step_2.Execute(_sequencer); 
            _step_3.Execute(_sequencer); 
            _context.Close();

            // Assert
            Assert.Equal(ULINT#1, _sequencer.CurrentOrder);
            Assert.Equal(TRUE,_step_1.IsActive);
            Assert.Equal(FALSE,_step_1.IsReady());
            Assert.Equal(TRUE,_step_1.IsBusy());
            Assert.Equal(FALSE,_step_1.HasError());
            Assert.Equal(ULINT#2, count);
        END_METHOD
    END_CLASS  
END_NAMESPACE


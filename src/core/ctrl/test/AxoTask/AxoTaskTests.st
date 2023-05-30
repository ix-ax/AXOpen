USING AxUnit;
USING AXOpen.Core;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core.AxoTask_Tests
     CLASS TestContext IMPLEMENTS IAxoContext         
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
        
        METHOD PUBLIC GetRtc : IAxoRtc ; END_METHOD

        METHOD PUBLIC InjectRtc VAR_INPUT Rtc : IAxoRtc; END_VAR ; END_METHOD
        VAR PRIVATE
           NULL_LOGGER : _NULL_LOGGER;
        END_VAR    
        METHOD PUBLIC GetLogger : AXOpen.Messaging.IAxoLogger GetLogger := NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : AXOpen.Messaging.IAxoLogger; END_VAR ; END_METHOD         
    END_CLASS      

    CLASS MyTask Extends AxoTask
        VAR
            OnAbortCounter : ULINT;
            OnResumeCounter : ULINT;
            OnDoneCounter : ULINT;
            OnErrorCounter : ULINT;
            OnRestoreCounter : ULINT;
            OnStartCounter : ULINT;
            WhileErrorCounter : ULINT;
        END_VAR
        METHOD PROTECTED OVERRIDE OnAbort 
            OnAbortCounter := OnAbortCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnResume 
            OnResumeCounter := OnResumeCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnDone 
            OnDoneCounter := OnDoneCounter + ULINT#1;
        END_METHOD
    
        METHOD PROTECTED OVERRIDE OnError 
            OnErrorCounter := OnErrorCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnRestore 
            OnRestoreCounter := OnRestoreCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnStart 
            OnStartCounter := OnStartCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE WhileError 
            WhileErrorCounter := WhileErrorCounter + ULINT#1;
        END_METHOD    
 
        METHOD PUBLIC GetOnAbortCounter : ULINT
            GetOnAbortCounter := OnAbortCounter;
        END_METHOD

        METHOD PUBLIC GetOnResumeCounter : ULINT
            GetOnResumeCounter := OnResumeCounter;
        END_METHOD

        METHOD PUBLIC GetOnDoneCounter : ULINT
            GetOnDoneCounter := OnDoneCounter;
        END_METHOD
    
        METHOD PUBLIC GetOnErrorCounter : ULINT
            GetOnErrorCounter := OnErrorCounter;
        END_METHOD

        METHOD PUBLIC GetOnRestoreCounter : ULINT
            GetOnRestoreCounter := OnRestoreCounter;
        END_METHOD

        METHOD PUBLIC GetOnStartCounter : ULINT
            GetOnStartCounter := OnStartCounter;
        END_METHOD

        METHOD PUBLIC GetWhileErrorCounter : ULINT
            GetWhileErrorCounter := WhileErrorCounter;
        END_METHOD    
    END_CLASS

    {TestFixture}
    CLASS AxoTaskUnitTests 
        VAR PROTECTED
           _context : TestContext;
           myTask : MyTask;
           expState:  eAxoTaskState;
           actState:  eAxoTaskState;
           initValue : ULINT;
        END_VAR    

        METHOD PRIVATE Initialize
            myTask.Initialize(_context);
        END_METHOD

        METHOD PRIVATE InitializeInvokeExecute
            myTask.Initialize(_context);
            _context.Open();
            myTask.Invoke();
            myTask.Execute();
            _context.Close();            
        END_METHOD

        METHOD PRIVATE InitializeInvokeExecuteAbort
            myTask.Initialize(_context);
            _context.Open();
            myTask.Invoke();
            myTask.Execute();
            myTask.Abort();
            _context.Close();            
        END_METHOD

        METHOD PRIVATE InitializeInvokeExecuteThrowWhen
            myTask.Initialize(_context);
            _context.Open();
            myTask.Invoke();
            myTask.Execute();
            myTask.ThrowWhen(TRUE);
            _context.Close();            
        END_METHOD
        
        METHOD PRIVATE InitializeInvokeExecuteDoneWhen
            myTask.Initialize(_context);
            _context.Open();
            myTask.Invoke();
            myTask.Execute();
            myTask.DoneWhen(TRUE);
            _context.Close();            
        END_METHOD

        METHOD Equal : BOOL
            VAR_INPUT
                 expected:  eAxoTaskState;
                 actual:  eAxoTaskState;
            END_VAR
            Equal := expected = actual;
        END_METHOD 

        {Test}
        METHOD PUBLIC should_initial_state_be_ready
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Ready;
            // Act/Assert           
            Assert.Equal(TRUE, THIS.Equal(expState, myTask.GetState()));
        END_METHOD

        {Test}
        METHOD PUBLIC should_state_after_initialization_be_ready
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Ready;
            // Act/Assert   
            THIS.Initialize();        
            Assert.Equal(TRUE, THIS.Equal(expState, myTask.GetState()));
        END_METHOD

        {Test}
        METHOD PUBLIC should_invoke_change_to_kicking_task_state
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Kicking;
            // Act/Assert           
            myTask.Invoke();
            Assert.Equal(TRUE, THIS.Equal(expState, myTask.GetState()));
        END_METHOD

        {Test}
        METHOD PUBLIC should_execute_return_false_if_not_invoked
            // Arrange
            THIS.Initialize();
            _context.Open();
            // Act/Assert           
            Assert.Equal(FALSE, myTask.Execute());
        END_METHOD

        {Test}
        METHOD PUBLIC should_execute_return_true_if_invoked
            // Arrange
            THIS.Initialize();
            _context.Open();
            // Act/Assert 
            myTask.Invoke();          
            Assert.Equal(TRUE, myTask.Execute());
        END_METHOD

        {Test}
        METHOD PUBLIC should_have_busy_state_after_invoke_and_first_execute_call
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Busy;
            // Act/Assert 
            myTask.Invoke();          
            myTask.Execute();
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD

        {Test}
        METHOD PUBLIC should_have_done_state_when_busy_and_done_when_is_called_with_true
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Done;
            // Act/Assert 
            myTask.Invoke();          
            myTask.Execute();
            myTask.DoneWhen(TRUE);
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_change_state_when_busy_and_done_when_is_called_with_false
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Busy;
            // Act/Assert 
            myTask.Invoke();          
            myTask.Execute();
            myTask.DoneWhen(FALSE);
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_change_state_when_busy_and_throw_when_is_called_with_false
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Busy;
            // Act/Assert 
            myTask.Invoke();          
            IF myTask.Execute() THEN
                myTask.ThrowWhen(FALSE);
            END_IF;
            actState := myTask.GetState();
            Assert.Equal(TRUE,THIS.Equal(expState, actState));           
        END_METHOD

        {Test}
        METHOD PUBLIC ThrowWhen_should_add_error_details
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Error;
            // Act/Assert 
            myTask.Invoke();          
            IF myTask.Execute() THEN
                myTask.ThrowWhen(TRUE, 'this is the reson of failure...');
            END_IF;
            actState := myTask.GetState();
            Assert.Equal(TRUE,THIS.Equal(expState, actState));     
            Assert.Equal('this is the reson of failure...', myTask.ErrorDetails);         
            Assert.Equal('this is the reson of failure...', myTask.GetErrorDetails());    
            myTask.Restore();
            Assert.Equal('', myTask.ErrorDetails);         
            Assert.Equal('', myTask.GetErrorDetails());    
        END_METHOD


        {Test}
        METHOD PUBLIC should_have_error_state_when_busy_and_thrown_when_is_called_with_true
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Error;
            // Act/Assert 
            myTask.Invoke();          
            IF myTask.Execute() THEN
                myTask.ThrowWhen(TRUE);
            END_IF;    
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD
  
        {Test}
        METHOD PUBLIC should_have_is_busy_true_when_executing
            // Arrange
            THIS.Initialize();
            _context.Open();
           // Act/Assert 
           myTask.Invoke();          
           myTask.Execute();                          
           Assert.Equal(TRUE, myTask.IsBusy());   
        END_METHOD
  
        {Test}
        METHOD PUBLIC should_have_is_done_true_when_execution_done
             // Arrange
             THIS.Initialize();
             _context.Open();
           // Act/Assert 
           myTask.Invoke();          
           IF(myTask.Execute()) THEN
                myTask.DoneWhen(TRUE);
           END_IF;
           Assert.Equal(TRUE, myTask.IsDone());   
        END_METHOD
 
        {Test}
        METHOD PUBLIC should_have_has_error_true_when_execution_done
            // Arrange
            THIS.Initialize();
            _context.Open();
           // Act/Assert 
           myTask.Invoke();          
           IF(myTask.Execute()) THEN
                myTask.ThrowWhen(TRUE);
           END_IF; 
           Assert.Equal(TRUE, myTask.HasError());   
        END_METHOD

        {Test}
        METHOD PUBLIC should_execute_on_external_request
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.RemoteInvoke := TRUE;
           // Act/Assert            
           Assert.Equal(TRUE, myTask.Execute());  
           Assert.Equal(FALSE, myTask.RemoteInvoke); 
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_invoke_disabled_task
            // Arrange
            THIS.Initialize();
            _context.Open();
           myTask.IsDisabled := TRUE;
           myTask.Invoke();
           // Act/Assert 
           Assert.Equal(FALSE, myTask.Execute());             
        END_METHOD

        {Test}
        METHOD PUBLIC should_stop_executing_disabled_task
            // Arrange
            THIS.Initialize();
            _context.Open();
           myTask.Invoke();
           // Act/Assert 
           Assert.Equal(TRUE, myTask.Execute());             
           myTask.IsDisabled := TRUE;
           Assert.Equal(FALSE, myTask.Execute());             
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_change_the_error_state_when_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Error;
            // Act/Assert 
            myTask.Invoke();          
            IF myTask.Execute() THEN
                myTask.ThrowWhen(TRUE);
            END_IF;    
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            myTask.IsDisabled := TRUE;
            myTask.Invoke();   
            myTask.Execute();
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD
  
        {Test}
        METHOD PUBLIC restore_method_call_should_be_the_only_way_to_get_from_the_error_state
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Error;
            // Act/Assert 
            myTask.Invoke();          
            IF myTask.Execute() THEN
                myTask.ThrowWhen(TRUE);
            END_IF;    
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            myTask.RemoteInvoke := TRUE;
            myTask.Invoke();   
            myTask.Execute();
            myTask.ThrowWhen(FALSE);
            myTask.DoneWhen(TRUE);
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            expState := eAxoTaskState#Ready;
            myTask.Restore();
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD
  
        {Test}
        METHOD PUBLIC restore_method_call_should_be_the_only_way_to_get_from_the_error_state_so_as_if_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eAxoTaskState#Error;
            // Act/Assert 
            myTask.Invoke();          
            IF myTask.Execute() THEN
                myTask.ThrowWhen(TRUE);
            END_IF;    
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            myTask.RemoteInvoke := TRUE;
            myTask.IsDisabled := TRUE;
            myTask.Invoke();   
            myTask.Execute();
            myTask.ThrowWhen(FALSE);
            myTask.DoneWhen(TRUE);
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            expState := eAxoTaskState#Disabled;
            myTask.Restore();
            actState := myTask.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
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
        METHOD PUBLIC execution_of_the_invoked_task_should_not_start_after_any_empty_cycles
            THIS.Initialize();
            myTask.Invoke();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Kicking,myTask.GetState()));

            _context.Open();
            _context.Close();


            _context.Open();
            Assert.Equal(FALSE ,myTask.Execute());
            Assert.Equal(FALSE,THIS.Equal(eAxoTaskState#Busy,myTask.GetState()));
            _context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC execution_of_the_invoked_task_should_start_when_execute_is_called_after_invoke_in_the_same_PLC_cycle
            THIS.Initialize();
            myTask.Invoke();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Kicking,myTask.GetState()));
            Assert.Equal(TRUE ,myTask.Execute());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Busy,myTask.GetState()));
        END_METHOD        

        {Test}
        METHOD PUBLIC execution_of_the_invoked_task_should_start_when_execute_is_called_after_invoke_in_the_next_PLC_cycle
            THIS.Initialize();
            _context.Open();
            myTask.Invoke();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Kicking,myTask.GetState()));
            _context.Close();

            _context.Open();
            Assert.Equal(TRUE ,myTask.Execute());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Busy,myTask.GetState()));
            _context.Close();
        END_METHOD  
        
        {Test}
        METHOD PUBLIC onstart_should_be_triggered_by_invoke_followed_by_execute
            initValue := myTask.GetOnStartCounter();
            THIS.Initialize();
            _context.Open();
            myTask.Invoke();
            myTask.Execute();
            Assert.Equal(initValue + ULINT#1,myTask.GetOnStartCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onstart_should_not_be_called_when_task_task_is_already_executing
            THIS.InitializeInvokeExecute();
            initValue := myTask.GetOnStartCounter();

            _context.Open();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnStartCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC ondone_should_be_triggered_when_task_task_enters_the_done_state
            THIS.InitializeInvokeExecute();
            initValue := myTask.GetOnDoneCounter();

            _context.Open();
            myTask.DoneWhen(TRUE);
            Assert.Equal(initValue + ULINT#1,myTask.GetOnDoneCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC ondone_should_not_be_called_when_task_task_is_already_in_the_done_state
            THIS.InitializeInvokeExecute();
            _context.Open();
            myTask.DoneWhen(TRUE);
            _context.Close();
            initValue := myTask.GetOnDoneCounter();

            _context.Open();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnDoneCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onerror_should_be_triggered_when_task_task_enters_the_error_state
            THIS.InitializeInvokeExecute();
            initValue := myTask.GetOnErrorCounter();

            _context.Open();
            myTask.ThrowWhen(TRUE);
            Assert.Equal(initValue + ULINT#1,myTask.GetOnErrorCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onerror_should_not_be_called_when_task_task_is_already_in_the_error_state
            THIS.InitializeInvokeExecute();
            _context.Open();
            myTask.ThrowWhen(TRUE);
            _context.Close();
            initValue := myTask.GetOnErrorCounter();

            _context.Open();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnErrorCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC while_error_should_be_triggered_when_task_task_enters_the_error_state
            THIS.InitializeInvokeExecute();
            initValue := myTask.GetWhileErrorCounter();

            _context.Open();
            myTask.ThrowWhen(TRUE);
            Assert.Equal(initValue + ULINT#1,myTask.GetWhileErrorCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC while_error_should_be_called_also_when_task_task_is_already_in_the_error_state
            THIS.InitializeInvokeExecute();
            _context.Open();
            myTask.ThrowWhen(TRUE);
            _context.Close();
            initValue := myTask.GetWhileErrorCounter();

            _context.Open();
            myTask.Execute();
            Assert.Equal(initValue + ULINT#1,myTask.GetWhileErrorCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_method_call_should_trigger_the_onabort_method_when_task_task_is_in_the_busy_state
            THIS.InitializeInvokeExecute();
            initValue := myTask.GetOnAbortCounter();

            _context.Open();
            myTask.Abort();
            Assert.Equal(initValue + ULINT#1,myTask.GetOnAbortCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_method_call_should_not_trigger_the_restore_method_when_task_task_is_in_the_busy_state
            THIS.InitializeInvokeExecute();
            initValue := myTask.GetOnRestoreCounter();

            _context.Open();
            myTask.Abort();
            Assert.Equal(initValue ,myTask.GetOnRestoreCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onabort_should_not_be_called_when_task_task_was_already_aborted
            THIS.InitializeInvokeExecute();
            _context.Open();
            myTask.Abort();
            _context.Close();
            initValue := myTask.GetOnAbortCounter();

            _context.Open();
            myTask.Abort();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnAbortCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_should_not_affect_the_task_task_in_ready_state_nor_onabort_should_be_triggered
            THIS.Initialize();
            _context.Open();
            myTask.Restore();
            _context.Close();
            initValue := myTask.GetOnAbortCounter();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));

            _context.Open();
            myTask.Abort();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnAbortCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_should_not_affect_the_task_task_in_error_state_nor_onabort_should_be_triggered
            THIS.InitializeInvokeExecuteThrowWhen();
            initValue := myTask.GetOnAbortCounter();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Error,myTask.GetState()));

            _context.Open();
            myTask.Abort();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnAbortCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Error,myTask.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_should_not_affect_the_task_task_in_done_state_nor_onabort_should_be_triggered
            THIS.InitializeInvokeExecuteDoneWhen();
            initValue := myTask.GetOnAbortCounter();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Done,myTask.GetState()));

            _context.Open();
            myTask.Abort();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnAbortCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Done,myTask.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC restore_method_call_should_trigger_the_onrestore_method_when_task_task_is_in_the_busy_state
            THIS.InitializeInvokeExecute();
            initValue := myTask.GetOnRestoreCounter();

            _context.Open();
            myTask.Restore();
            Assert.Equal(initValue + ULINT#1,myTask.GetOnRestoreCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC restore_method_call_should_trigger_the_onrestore_method_when_task_task_is_in_the_error_state
            THIS.InitializeInvokeExecuteThrowWhen();
            initValue := myTask.GetOnRestoreCounter();

            _context.Open();
            myTask.Restore();
            Assert.Equal(initValue + ULINT#1,myTask.GetOnRestoreCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC restore_method_call_should_trigger_the_onrestore_method_when_task_task_is_in_the_done_state
            THIS.InitializeInvokeExecuteDoneWhen();
            initValue := myTask.GetOnRestoreCounter();

            _context.Open();
            myTask.Restore();
            Assert.Equal(initValue + ULINT#1,myTask.GetOnRestoreCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC restore_method_call_should_trigger_the_onrestore_method_when_task_task_is_in_the_ready_state
            THIS.Initialize();
            _context.Open();
            myTask.Restore();
            _context.Close();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));
            initValue := myTask.GetOnRestoreCounter();

            _context.Open();
            myTask.Restore();
            Assert.Equal(initValue + ULINT#1,myTask.GetOnRestoreCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));
            _context.Close();
        END_METHOD   
//******************
        {Test}
        METHOD PUBLIC resume_method_call_should_trigger_the_onresume_method_when_task_task_is_in_the_aborted_state
            THIS.InitializeInvokeExecuteAbort();
            initValue := myTask.GetOnResumeCounter();

            _context.Open();
            myTask.Resume();
            Assert.Equal(initValue + ULINT#1,myTask.GetOnResumeCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC resume_method_call_should_trigger_the_onresume_method_when_task_task_is_in_the_busy_state
            THIS.InitializeInvokeExecute();
            initValue := myTask.GetOnResumeCounter();

            _context.Open();
            myTask.Resume();
            Assert.Equal(initValue,myTask.GetOnResumeCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onresume_should_not_be_called_when_task_task_was_already_resumed
            THIS.InitializeInvokeExecuteAbort();
            _context.Open();
            myTask.Resume();
            _context.Close();
            initValue := myTask.GetOnResumeCounter();

            _context.Open();
            myTask.Resume();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnResumeCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC resume_should_not_affect_the_task_task_in_ready_state_nor_onresume_should_be_triggered
            THIS.Initialize();
            _context.Open();
            myTask.Restore();
            _context.Close();
            initValue := myTask.GetOnResumeCounter();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));

            _context.Open();
            myTask.Resume();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnResumeCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Ready,myTask.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC resume_should_not_affect_the_task_task_in_error_state_nor_onresume_should_be_triggered
            THIS.InitializeInvokeExecuteThrowWhen();
            initValue := myTask.GetOnResumeCounter();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Error,myTask.GetState()));

            _context.Open();
            myTask.Resume();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnResumeCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Error,myTask.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC resume_should_not_affect_the_task_task_in_done_state_nor_onresume_should_be_triggered
            THIS.InitializeInvokeExecuteDoneWhen();
            initValue := myTask.GetOnResumeCounter();
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Done,myTask.GetState()));

            _context.Open();
            myTask.Resume();
            myTask.Execute();
            Assert.Equal(initValue,myTask.GetOnResumeCounter());
            Assert.Equal(TRUE,THIS.Equal(eAxoTaskState#Done,myTask.GetState()));
            _context.Close();
        END_METHOD   


    END_CLASS
END_NAMESPACE

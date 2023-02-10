USING AxUnit;
USING AxUnit;
USING ix.core;
USING AxUnit;
USING ix.framework.core;

NAMESPACE ix.core.commands_tests
     CLASS TestContext IMPLEMENTS ix.framework.core.IContext         
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
    END_CLASS      

    CLASS MyCommandTask Extends CommandTask
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
    CLASS CommandTaskUnitTests 
        VAR PROTECTED
           _context : TestContext;
           command : MyCommandTask;
           expState:  eCommandTaskState;
           actState:  eCommandTaskState;
           initValue : ULINT;
        END_VAR    

        METHOD PRIVATE Initialize
            command.Initialize(_context);
        END_METHOD

        METHOD PRIVATE InitializeInvokeExecute
            command.Initialize(_context);
            _context.Open();
            command.Invoke();
            command.Execute();
            _context.Close();            
        END_METHOD

        METHOD PRIVATE InitializeInvokeExecuteAbort
            command.Initialize(_context);
            _context.Open();
            command.Invoke();
            command.Execute();
            command.Abort();
            _context.Close();            
        END_METHOD

        METHOD PRIVATE InitializeInvokeExecuteThrowWhen
            command.Initialize(_context);
            _context.Open();
            command.Invoke();
            command.Execute();
            command.ThrowWhen(TRUE);
            _context.Close();            
        END_METHOD

        METHOD PRIVATE InitializeInvokeExecuteDoneWhen
            command.Initialize(_context);
            _context.Open();
            command.Invoke();
            command.Execute();
            command.DoneWhen(TRUE);
            _context.Close();            
        END_METHOD

        METHOD Equal : BOOL
            VAR_INPUT
                 expected:  eCommandTaskState;
                 actual:  eCommandTaskState;
            END_VAR
            Equal := expected = actual;
        END_METHOD 

        {Test}
        METHOD PUBLIC should_initial_state_be_ready
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Ready;
            // Act/Assert           
            Assert.Equal(TRUE, THIS.Equal(expState, command.GetState()));
        END_METHOD

        {Test}
        METHOD PUBLIC should_state_after_initialization_be_ready
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Ready;
            // Act/Assert   
            THIS.Initialize();        
            Assert.Equal(TRUE, this.Equal(expState, command.GetState()));
        END_METHOD

        {Test}
        METHOD PUBLIC should_invoke_change_to_kicking_command_state
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Kicking;
            // Act/Assert           
            command.Invoke();
            Assert.Equal(TRUE, this.Equal(expState, command.GetState()));
        END_METHOD

        {Test}
        METHOD PUBLIC should_execute_return_false_if_not_invoked
            // Arrange
            THIS.Initialize();
            _context.Open();
            // Act/Assert           
            Assert.Equal(FALSE, command.Execute());
        END_METHOD

        {Test}
        METHOD PUBLIC should_execute_return_true_if_invoked
            // Arrange
            THIS.Initialize();
            _context.Open();
            // Act/Assert 
            command.Invoke();          
            Assert.Equal(TRUE, command.Execute());
        END_METHOD

        {Test}
        METHOD PUBLIC should_have_busy_state_after_invoke_and_first_execute_call
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Busy;
            // Act/Assert 
            command.Invoke();          
            command.Execute();
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD

        {Test}
        METHOD PUBLIC should_have_done_state_when_busy_and_done_when_is_called_with_true
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Done;
            // Act/Assert 
            command.Invoke();          
            command.Execute();
            command.DoneWhen(TRUE);
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_change_state_when_busy_and_done_when_is_called_with_false
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Busy;
            // Act/Assert 
            command.Invoke();          
            command.Execute();
            command.DoneWhen(FALSE);
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_change_state_when_busy_and_throw_when_is_called_with_false
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Busy;
            // Act/Assert 
            command.Invoke();          
            IF command.Execute() THEN
                command.ThrowWhen(FALSE);
            END_IF;
            actState := command.GetState();
            Assert.Equal(TRUE,THIS.Equal(expState, actState));           
        END_METHOD

        {Test}
        METHOD PUBLIC should_have_error_state_when_busy_and_thrown_when_is_called_with_true
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Error;
            // Act/Assert 
            command.Invoke();          
            IF command.Execute() THEN
                command.ThrowWhen(TRUE);
            END_IF;    
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD
  
        {Test}
        METHOD PUBLIC should_have_is_busy_true_when_executing
            // Arrange
            THIS.Initialize();
            _context.Open();
           // Act/Assert 
           command.Invoke();          
           command.Execute();                          
           Assert.Equal(TRUE, command.IsBusy());   
        END_METHOD
  
        {Test}
        METHOD PUBLIC should_have_is_done_true_when_execution_done
             // Arrange
             THIS.Initialize();
             _context.Open();
           // Act/Assert 
           command.Invoke();          
           IF(command.Execute()) THEN
                command.DoneWhen(TRUE);
           END_IF;
           Assert.Equal(TRUE, command.IsDone());   
        END_METHOD
 
        {Test}
        METHOD PUBLIC should_have_has_error_true_when_execution_done
            // Arrange
            THIS.Initialize();
            _context.Open();
           // Act/Assert 
           command.Invoke();          
           IF(command.Execute()) THEN
                command.ThrowWhen(TRUE);
           END_IF; 
           Assert.Equal(TRUE, command.HasError());   
        END_METHOD

        {Test}
        METHOD PUBLIC should_execute_on_external_request
            // Arrange
            THIS.Initialize();
            _context.Open();
            command.RemoteInvoke := TRUE;
           // Act/Assert            
           Assert.Equal(TRUE, command.Execute());  
           Assert.Equal(FALSE, command.RemoteInvoke); 
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_invoke_disabled_command
            // Arrange
            THIS.Initialize();
            _context.Open();
           command.IsDisabled := TRUE;
           command.Invoke();
           // Act/Assert 
           Assert.Equal(FALSE, command.Execute());             
        END_METHOD

        {Test}
        METHOD PUBLIC should_stop_executing_disabled_command
            // Arrange
            THIS.Initialize();
            _context.Open();
           command.Invoke();
           // Act/Assert 
           Assert.Equal(TRUE, command.Execute());             
           command.IsDisabled := TRUE;
           Assert.Equal(FALSE, command.Execute());             
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_change_the_error_state_when_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Error;
            // Act/Assert 
            command.Invoke();          
            IF command.Execute() THEN
                command.ThrowWhen(TRUE);
            END_IF;    
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            command.IsDisabled := TRUE;
            command.Invoke();   
            command.Execute();
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD
  
        {Test}
        METHOD PUBLIC restore_method_call_should_be_the_only_way_to_get_from_the_error_state
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Error;
            // Act/Assert 
            command.Invoke();          
            IF command.Execute() THEN
                command.ThrowWhen(TRUE);
            END_IF;    
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            command.RemoteInvoke := TRUE;
            command.Invoke();   
            command.Execute();
            command.ThrowWhen(FALSE);
            command.DoneWhen(TRUE);
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            expState := eCommandTaskState#Ready;
            command.Restore();
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
        END_METHOD
  
        {Test}
        METHOD PUBLIC restore_method_call_should_be_the_only_way_to_get_from_the_error_state_so_as_if_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            expState := eCommandTaskState#Error;
            // Act/Assert 
            command.Invoke();          
            IF command.Execute() THEN
                command.ThrowWhen(TRUE);
            END_IF;    
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            command.RemoteInvoke := TRUE;
            command.IsDisabled := TRUE;
            command.Invoke();   
            command.Execute();
            command.ThrowWhen(FALSE);
            command.DoneWhen(TRUE);
            actState := command.GetState();
            Assert.Equal(TRUE, THIS.Equal(expState, actState));           
            expState := eCommandTaskState#Disabled;
            command.Restore();
            actState := command.GetState();
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
        METHOD PUBLIC execution_of_the_invoked_command_should_not_start_after_any_empty_cycles
            THIS.Initialize();
            command.Invoke();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Kicking,command.GetState()));

            _context.Open();
            _context.Close();


            _context.Open();
            Assert.Equal(FALSE ,command.Execute());
            Assert.Equal(FALSE,THIS.Equal(eCommandTaskState#Busy,command.GetState()));
            _context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC execution_of_the_invoked_command_should_start_when_execute_is_called_after_invoke_in_the_same_PLC_cycle
            THIS.Initialize();
            command.Invoke();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Kicking,command.GetState()));
            Assert.Equal(TRUE ,command.Execute());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Busy,command.GetState()));
        END_METHOD        

        {Test}
        METHOD PUBLIC execution_of_the_invoked_command_should_start_when_execute_is_called_after_invoke_in_the_next_PLC_cycle
            THIS.Initialize();
            _context.Open();
            command.Invoke();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Kicking,command.GetState()));
            _context.Close();

            _context.Open();
            Assert.Equal(TRUE ,command.Execute());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Busy,command.GetState()));
            _context.Close();
        END_METHOD  
        
        {Test}
        METHOD PUBLIC onstart_should_be_triggered_by_invoke_followed_by_execute
            initValue := command.GetOnStartCounter();
            THIS.Initialize();
            _context.Open();
            command.Invoke();
            command.Execute();
            Assert.Equal(initValue + ULINT#1,command.GetOnStartCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onstart_should_not_be_called_when_command_task_is_already_executing
            THIS.InitializeInvokeExecute();
            initValue := command.GetOnStartCounter();

            _context.Open();
            command.Execute();
            Assert.Equal(initValue,command.GetOnStartCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC ondone_should_be_triggered_when_command_task_enters_the_done_state
            THIS.InitializeInvokeExecute();
            initValue := command.GetOnDoneCounter();

            _context.Open();
            command.DoneWhen(TRUE);
            Assert.Equal(initValue + ULINT#1,command.GetOnDoneCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC ondone_should_not_be_called_when_command_task_is_already_in_the_done_state
            THIS.InitializeInvokeExecute();
            _context.Open();
            command.DoneWhen(TRUE);
            _context.Close();
            initValue := command.GetOnDoneCounter();

            _context.Open();
            command.Execute();
            Assert.Equal(initValue,command.GetOnDoneCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onerror_should_be_triggered_when_command_task_enters_the_error_state
            THIS.InitializeInvokeExecute();
            initValue := command.GetOnErrorCounter();

            _context.Open();
            command.ThrowWhen(TRUE);
            Assert.Equal(initValue + ULINT#1,command.GetOnErrorCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onerror_should_not_be_called_when_command_task_is_already_in_the_error_state
            THIS.InitializeInvokeExecute();
            _context.Open();
            command.ThrowWhen(TRUE);
            _context.Close();
            initValue := command.GetOnErrorCounter();

            _context.Open();
            command.Execute();
            Assert.Equal(initValue,command.GetOnErrorCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC while_error_should_be_triggered_when_command_task_enters_the_error_state
            THIS.InitializeInvokeExecute();
            initValue := command.GetWhileErrorCounter();

            _context.Open();
            command.ThrowWhen(TRUE);
            Assert.Equal(initValue + ULINT#1,command.GetWhileErrorCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC while_error_should_be_called_also_when_command_task_is_already_in_the_error_state
            THIS.InitializeInvokeExecute();
            _context.Open();
            command.ThrowWhen(TRUE);
            _context.Close();
            initValue := command.GetWhileErrorCounter();

            _context.Open();
            command.Execute();
            Assert.Equal(initValue + ULINT#1,command.GetWhileErrorCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_method_call_should_trigger_the_onabort_method_when_command_task_is_in_the_busy_state
            THIS.InitializeInvokeExecute();
            initValue := command.GetOnAbortCounter();

            _context.Open();
            command.Abort();
            Assert.Equal(initValue + ULINT#1,command.GetOnAbortCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_method_call_should_not_trigger_the_restore_method_when_command_task_is_in_the_busy_state
            THIS.InitializeInvokeExecute();
            initValue := command.GetOnRestoreCounter();

            _context.Open();
            command.Abort();
            Assert.Equal(initValue ,command.GetOnRestoreCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onabort_should_not_be_called_when_command_task_was_already_aborted
            THIS.InitializeInvokeExecute();
            _context.Open();
            command.Abort();
            _context.Close();
            initValue := command.GetOnAbortCounter();

            _context.Open();
            command.Abort();
            command.Execute();
            Assert.Equal(initValue,command.GetOnAbortCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_should_not_affect_the_command_task_in_ready_state_nor_onabort_should_be_triggered
            THIS.Initialize();
            _context.Open();
            command.Restore();
            _context.Close();
            initValue := command.GetOnAbortCounter();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));

            _context.Open();
            command.Abort();
            command.Execute();
            Assert.Equal(initValue,command.GetOnAbortCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_should_not_affect_the_command_task_in_error_state_nor_onabort_should_be_triggered
            THIS.InitializeInvokeExecuteThrowWhen();
            initValue := command.GetOnAbortCounter();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Error,command.GetState()));

            _context.Open();
            command.Abort();
            command.Execute();
            Assert.Equal(initValue,command.GetOnAbortCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Error,command.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC abort_should_not_affect_the_command_task_in_done_state_nor_onabort_should_be_triggered
            THIS.InitializeInvokeExecuteDoneWhen();
            initValue := command.GetOnAbortCounter();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Done,command.GetState()));

            _context.Open();
            command.Abort();
            command.Execute();
            Assert.Equal(initValue,command.GetOnAbortCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Done,command.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC restore_method_call_should_trigger_the_onrestore_method_when_command_task_is_in_the_busy_state
            THIS.InitializeInvokeExecute();
            initValue := command.GetOnRestoreCounter();

            _context.Open();
            command.Restore();
            Assert.Equal(initValue + ULINT#1,command.GetOnRestoreCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC restore_method_call_should_trigger_the_onrestore_method_when_command_task_is_in_the_error_state
            THIS.InitializeInvokeExecuteThrowWhen();
            initValue := command.GetOnRestoreCounter();

            _context.Open();
            command.Restore();
            Assert.Equal(initValue + ULINT#1,command.GetOnRestoreCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC restore_method_call_should_trigger_the_onrestore_method_when_command_task_is_in_the_done_state
            THIS.InitializeInvokeExecuteDoneWhen();
            initValue := command.GetOnRestoreCounter();

            _context.Open();
            command.Restore();
            Assert.Equal(initValue + ULINT#1,command.GetOnRestoreCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC restore_method_call_should_trigger_the_onrestore_method_when_command_task_is_in_the_ready_state
            THIS.Initialize();
            _context.Open();
            command.Restore();
            _context.Close();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));
            initValue := command.GetOnRestoreCounter();

            _context.Open();
            command.Restore();
            Assert.Equal(initValue + ULINT#1,command.GetOnRestoreCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));
            _context.Close();
        END_METHOD   
//******************
        {Test}
        METHOD PUBLIC resume_method_call_should_trigger_the_onresume_method_when_command_task_is_in_the_aborted_state
            THIS.InitializeInvokeExecuteAbort();
            initValue := command.GetOnResumeCounter();

            _context.Open();
            command.Resume();
            Assert.Equal(initValue + ULINT#1,command.GetOnResumeCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC resume_method_call_should_trigger_the_onresume_method_when_command_task_is_in_the_busy_state
            THIS.InitializeInvokeExecute();
            initValue := command.GetOnResumeCounter();

            _context.Open();
            command.Resume();
            Assert.Equal(initValue,command.GetOnResumeCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC onresume_should_not_be_called_when_command_task_was_already_resumed
            THIS.InitializeInvokeExecuteAbort();
            _context.Open();
            command.Resume();
            _context.Close();
            initValue := command.GetOnResumeCounter();

            _context.Open();
            command.Resume();
            command.Execute();
            Assert.Equal(initValue,command.GetOnResumeCounter());
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC resume_should_not_affect_the_command_task_in_ready_state_nor_onresume_should_be_triggered
            THIS.Initialize();
            _context.Open();
            command.Restore();
            _context.Close();
            initValue := command.GetOnResumeCounter();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));

            _context.Open();
            command.Resume();
            command.Execute();
            Assert.Equal(initValue,command.GetOnResumeCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Ready,command.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC resume_should_not_affect_the_command_task_in_error_state_nor_onresume_should_be_triggered
            THIS.InitializeInvokeExecuteThrowWhen();
            initValue := command.GetOnResumeCounter();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Error,command.GetState()));

            _context.Open();
            command.Resume();
            command.Execute();
            Assert.Equal(initValue,command.GetOnResumeCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Error,command.GetState()));
            _context.Close();
        END_METHOD   

        {Test}
        METHOD PUBLIC resume_should_not_affect_the_command_task_in_done_state_nor_onresume_should_be_triggered
            THIS.InitializeInvokeExecuteDoneWhen();
            initValue := command.GetOnResumeCounter();
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Done,command.GetState()));

            _context.Open();
            command.Resume();
            command.Execute();
            Assert.Equal(initValue,command.GetOnResumeCounter());
            Assert.Equal(TRUE,THIS.Equal(eCommandTaskState#Done,command.GetState()));
            _context.Close();
        END_METHOD   


    END_CLASS
END_NAMESPACE

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

    {TestFixture}
    CLASS CommandTaskUnitTests 
        VAR PROTECTED
           _context : TestContext;
           command : CommandTask;
           expState:  eCommandTaskState;
           actState:  eCommandTaskState;
        END_VAR    
        METHOD PRIVATE Initialize
            command.Initialize(_context);
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

    END_CLASS
END_NAMESPACE

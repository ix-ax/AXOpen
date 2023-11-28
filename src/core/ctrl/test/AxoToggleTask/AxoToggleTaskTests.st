USING AxUnit;
USING AxUnit;
USING AXOpen.Core;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core.AxoToggleTask_Tests
     {S7.extern=ReadWrite}
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
        
        VAR PRIVATE
            NULL_RTC : _NULL_RTC;
        END_VAR    
        METHOD PUBLIC GetRtc : IAxoRtc GetRtc := NULL_RTC; END_METHOD

        METHOD PUBLIC InjectRtc VAR_INPUT Rtc : IAxoRtc; END_VAR ; END_METHOD
             
        VAR PRIVATE
            NULL_LOGGER : _NULL_LOGGER;
        END_VAR    
        METHOD PUBLIC GetLogger : AXOpen.Logging.IAxoLogger GetLogger := NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : AXOpen.Logging.IAxoLogger; END_VAR ; END_METHOD

    END_CLASS      

    {S7.extern=ReadWrite}
    CLASS MyTask Extends AxoToggleTask
        VAR
            OnSwitchedOnCounter : ULINT;
            OnSwitchedOffCounter : ULINT;
            OnStateChangedCounter : ULINT;
            SwitchOnExecutionCounter : ULINT;
            SwitchOffExecutionCounter : ULINT;
        END_VAR

        METHOD PROTECTED OVERRIDE OnSwitchedOn 
            OnSwitchedOnCounter := OnSwitchedOnCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnSwitchedOff 
            OnSwitchedOffCounter := OnSwitchedOffCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnStateChanged 
            OnStateChangedCounter := OnStateChangedCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE SwitchedOn 
            SwitchOnExecutionCounter := SwitchOnExecutionCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE SwitchedOff 
            SwitchOffExecutionCounter := SwitchOffExecutionCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC GetOnSwitchedOnCounter : ULINT
            GetOnSwitchedOnCounter := OnSwitchedOnCounter;
        END_METHOD

        METHOD PUBLIC GetOnSwitchedOffCounter : ULINT
            GetOnSwitchedOffCounter := OnSwitchedOffCounter;
        END_METHOD

        METHOD PUBLIC GetOnStateChangedCounter : ULINT
            GetOnStateChangedCounter := OnStateChangedCounter;
        END_METHOD

        METHOD PUBLIC GetSwitchOnExecutionCounter : ULINT
            GetSwitchOnExecutionCounter := SwitchOnExecutionCounter;
        END_METHOD

        METHOD PUBLIC GetSwitchOffExecutionCounter : ULINT
            GetSwitchOffExecutionCounter := SwitchOffExecutionCounter;
        END_METHOD
    END_CLASS

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoToggleTaskUnitTests 
        VAR PROTECTED
           _context : TestContext;
           myTask : MyTask;
            initValue : ULINT;
        END_VAR    

        METHOD PRIVATE Initialize
            myTask.Initialize(_context);
        END_METHOD

        METHOD PRIVATE SwitchOn
            _context.Open();
            myTask.SwitchOn();
            myTask.Run();
            _context.Close();            
        END_METHOD

        METHOD PRIVATE SwitchOff
            _context.Open();
            myTask.SwitchOff();
            myTask.Run();
            _context.Close();            
        END_METHOD

        {Test}
        METHOD PUBLIC initial_state_should_be_switched_off
            // Arrange
            THIS.Initialize();
            _context.Open();
             // Act/Assert           
            myTask.Run();
            Assert.Equal(TRUE, myTask.IsSwitchedOff());
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_be_disabled_by_default
            // Arrange
            THIS.Initialize();
            _context.Open();
            // Act/Assert           
            myTask.Run();
            Assert.Equal(FALSE, myTask.GetIsDisabled());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_should_return_FALSE_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            _context.Open();
            _context.Close();
            _context.Open();
            // Act/Assert           
            Assert.Equal(FALSE, myTask.Toggle());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_not_change_the_state_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            _context.Open();
            _context.Close();
            _context.Open();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_not_trigger_the_OnStateChanged_method_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            _context.Open();
            _context.Close();
            _context.Open();
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(initValue, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_should_return_FALSE_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            // Act/Assert           
            Assert.Equal(FALSE, myTask.Toggle());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_not_change_the_state_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_not_trigger_the_OnStateChanged_method_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(initValue, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_should_return_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            // Act/Assert     
            Assert.Equal(TRUE, myTask.Toggle());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_change_the_state_of_the_task
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(TRUE, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_trigger_the_OnStateChanged_method
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(initValue + ULINT#1, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_trigger_the_OnSwitchedOn_method_when_changing_from_FALSE_to_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnSwitchedOnCounter();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(initValue + ULINT#1, myTask.GetOnSwitchedOnCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_not_trigger_the_OnSwitchedOff_method_when_changing_from_FALSE_to_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnSwitchedOffCounter();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(initValue, myTask.GetOnSwitchedOffCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_not_trigger_the_OnSwitchedOff_method_when_changing_from_TRUE_to_FALSE
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnSwitchedOnCounter();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(initValue, myTask.GetOnSwitchedOnCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC Toggle_method_call_should_trigger_the_OnSwitchedOff_method_when_changing_from_TRUE_to_FALSE
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnSwitchedOffCounter();
            // Act/Assert     
            myTask.Toggle();      
            Assert.Equal(initValue + ULINT#1, myTask.GetOnSwitchedOffCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchedOn_method_must_be_called_when_the_state_of_the_task_is_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            initValue := myTask.GetSwitchOnExecutionCounter();
            // Act/Assert     
            myTask.Toggle();      
            myTask.Run();
            Assert.Equal(TRUE,myTask.IsSwitchedOn());
            Assert.Equal(initValue + ULINT#1, myTask.GetSwitchOnExecutionCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchedOn_method_must_be_called_when_the_state_of_the_task_is_TRUE_regardless_the_Toggle_Run_methods_order
            // Arrange
            THIS.Initialize();
            _context.Open();
            initValue := myTask.GetSwitchOnExecutionCounter();
            // Act/Assert     
            myTask.Run();
            myTask.Toggle();      
            Assert.Equal(TRUE,myTask.IsSwitchedOn());
            Assert.Equal(initValue + ULINT#1, myTask.GetSwitchOnExecutionCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchedOff_method_should_not_be_called_when_the_state_of_the_task_is_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            initValue := myTask.GetSwitchOffExecutionCounter();
            // Act/Assert     
            myTask.Toggle();      
            myTask.Run();
            Assert.Equal(TRUE,myTask.IsSwitchedOn());
            Assert.Equal(initValue, myTask.GetSwitchOffExecutionCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchedOff_method_should_not_be_called_when_the_state_of_the_task_is_TRUE_regardless_the_Toggle_Run_methods_order
            // Arrange
            THIS.Initialize();
            _context.Open();
            // Act/Assert     
            myTask.Run();
            initValue := myTask.GetSwitchOffExecutionCounter();
            myTask.Toggle();      
            Assert.Equal(TRUE,myTask.IsSwitchedOn());
            Assert.Equal(initValue, myTask.GetSwitchOffExecutionCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchedOn_method_should_not_be_called_when_the_state_of_the_task_is_FALSE
            // Arrange
            THIS.Initialize();
            _context.Open();
            initValue := myTask.GetSwitchOnExecutionCounter();
            // Act/Assert     
            myTask.Run();
            Assert.Equal(initValue, myTask.GetSwitchOnExecutionCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchedOff_method_must_be_called_when_the_state_of_the_task_is_FALSE
            // Arrange
            THIS.Initialize();
            _context.Open();
            initValue := myTask.GetSwitchOffExecutionCounter();
            // Act/Assert     
            myTask.Run();
            Assert.Equal(initValue + ULINT#1, myTask.GetSwitchOffExecutionCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_should_return_FALSE_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            _context.Open();
            _context.Close();
            _context.Open();
            // Act/Assert           
            Assert.Equal(FALSE, myTask.SwitchOn());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_call_should_not_change_the_state_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            _context.Open();
            _context.Close();
            _context.Open();
            // Act/Assert     
            myTask.SwitchOn();      
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_call_should_not_trigger_the_OnStateChanged_method_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            _context.Open();
            _context.Close();
            _context.Open();
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.SwitchOn();      
            Assert.Equal(initValue, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_should_return_FALSE_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            // Act/Assert           
            Assert.Equal(FALSE, myTask.SwitchOn());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_call_should_not_change_the_state_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            // Act/Assert     
            myTask.SwitchOn();      
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_call_should_not_trigger_the_OnStateChanged_method_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.SwitchOn();      
            Assert.Equal(initValue, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_should_return_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            // Act/Assert     
            Assert.Equal(TRUE, myTask.SwitchOn());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_call_should_change_the_state_of_the_task
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            // Act/Assert     
            myTask.SwitchOn();      
            Assert.Equal(TRUE, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_call_should_trigger_the_OnStateChanged_method
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.SwitchOn();      
            Assert.Equal(initValue + ULINT#1, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_call_should_trigger_the_OnSwitchedOn_method_when_changing_from_FALSE_to_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnSwitchedOnCounter();
            // Act/Assert     
            myTask.SwitchOn();      
            Assert.Equal(initValue + ULINT#1, myTask.GetOnSwitchedOnCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOn_method_call_should_not_trigger_the_OnSwitchedOff_method_when_changing_from_FALSE_to_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnSwitchedOffCounter();
            // Act/Assert     
            THIS.SwitchOn();      
            Assert.Equal(initValue, myTask.GetOnSwitchedOffCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_should_return_FALSE_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            _context.Close();
            _context.Open();
            // Act/Assert           
            Assert.Equal(FALSE, myTask.SwitchOff());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_call_should_not_change_the_state_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            _context.Close();
            _context.Open();
            // Act/Assert     
            myTask.SwitchOff();      
            Assert.Equal(FALSE, myTask.IsSwitchedOff());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_call_should_not_trigger_the_OnStateChanged_method_if_Run_method_is_not_called
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            _context.Close();
            _context.Open();
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.SwitchOff();      
            Assert.Equal(initValue, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_should_return_FALSE_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            // Act/Assert           
            Assert.Equal(FALSE, myTask.SwitchOff());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_call_should_not_change_the_state_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            // Act/Assert     
            myTask.SwitchOff();      
            Assert.Equal(FALSE, myTask.IsSwitchedOff());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_call_should_not_trigger_the_OnStateChanged_method_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            myTask.SetIsDisabled(TRUE);
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.SwitchOff();      
            Assert.Equal(initValue, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_should_return_TRUE
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            // Act/Assert     
            Assert.Equal(TRUE, myTask.SwitchOff());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_call_should_change_the_state_of_the_task
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            // Act/Assert     
            myTask.SwitchOff();      
            Assert.Equal(TRUE, myTask.IsSwitchedOff());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_call_should_trigger_the_OnStateChanged_method
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnStateChangedCounter();
            // Act/Assert     
            myTask.SwitchOff();      
            Assert.Equal(initValue + ULINT#1, myTask.GetOnStateChangedCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_call_should_trigger_the_OnSwitchedOff_method_when_changing_from_TRUE_to_FALSE
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnSwitchedOffCounter();
            // Act/Assert     
            myTask.SwitchOff();      
            Assert.Equal(initValue + ULINT#1, myTask.GetOnSwitchedOffCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchOff_method_call_should_not_trigger_the_OnSwitchedOn_method_when_changing_from_TRUE_to_FALSE
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            myTask.Run();
            initValue := myTask.GetOnSwitchedOnCounter();
            // Act/Assert     
            myTask.SwitchOff();      
            Assert.Equal(initValue, myTask.GetOnSwitchedOnCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC RemoteToggle_signal_should_change_the_state_if_task_is_not_disabled
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            Assert.Equal(true, myTask.IsSwitchedOn());
           // Act/Assert     
            myTask.RemoteToggle := true;
            myTask.Run();
            Assert.Equal(false, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC RemoteToggle_signal_should_not_change_the_state_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            Assert.Equal(true, myTask.IsSwitchedOn());
           // Act/Assert   
            myTask.SetIsDisabled(true);  
            myTask.RemoteToggle := true;
            myTask.Run();
            Assert.Equal(true, myTask.IsSwitchedOn());
        END_METHOD

        {Test}
        METHOD PUBLIC RemoteToggle_signal_should_be_FALSE_after_Run_method_is_called_if_task_is_not_disabled
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            Assert.Equal(true, myTask.IsSwitchedOn());
           // Act/Assert     
            myTask.RemoteToggle := true;
            myTask.Run();
            Assert.Equal(false, myTask.RemoteToggle);
        END_METHOD

        {Test}
        METHOD PUBLIC RemoteToggle_signal_should_be_FALSE_after_Run_method_is_called_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            THIS.SwitchOn();
            _context.Open();
            Assert.Equal(true, myTask.IsSwitchedOn());
           // Act/Assert     
           myTask.SetIsDisabled(true);  
           myTask.RemoteToggle := true;
            myTask.Run();
            Assert.Equal(false, myTask.RemoteToggle);
        END_METHOD

    END_CLASS
END_NAMESPACE

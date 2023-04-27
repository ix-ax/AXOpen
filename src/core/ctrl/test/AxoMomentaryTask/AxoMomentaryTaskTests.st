USING AxUnit;
USING AxUnit;
USING AXOpen.Core;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core.AxoMomentaryTask_Tests
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
 
        
        METHOD PUBLIC Environment : IAxoContextEnvironment
            ;
        END_METHOD
    END_CLASS      

    CLASS MyTask Extends AxoMomentaryTask
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
    CLASS AxoMomentaryTaskUnitTests 
        VAR PROTECTED
           _context : TestContext;
           myTask : MyTask;
            initValue : ULINT;
        END_VAR    

        METHOD PRIVATE Initialize
            myTask.Initialize(_context);
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
        METHOD PUBLIC SwitchedOn_method_must_be_called_when_the_state_of_the_task_is_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            initValue := myTask.GetSwitchOnExecutionCounter();
            // Act/Assert     
            myTask.RemoteSwitchOn := TRUE;      
            myTask.Run();
            Assert.Equal(initValue + ULINT#1, myTask.GetSwitchOnExecutionCounter());
        END_METHOD

        {Test}
        METHOD PUBLIC SwitchedOff_method_should_not_be_called_when_the_state_of_the_task_is_TRUE
            // Arrange
            THIS.Initialize();
            _context.Open();
            initValue := myTask.GetSwitchOffExecutionCounter();
            // Act/Assert     
            myTask.RemoteSwitchOn := TRUE;      
            myTask.Run();
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
        METHOD PUBLIC RemoteSwitchOn_signal_rising_edge_should_create_the_rising_edge_of_the_state_if_task_is_not_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
            // Act/Assert     
            myTask.RemoteSwitchOn := TRUE;
            myTask.Run();
            Assert.Equal(TRUE, myTask.IsSwitchedOn());
            Assert.Equal(FALSE, myTask.IsSwitchedOff());
        END_METHOD

        {Test}
        METHOD PUBLIC RemoteSwitchOn_signal_falling_edge_should_create_the_falling_edge_of_the_state_if_task_is_not_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.RemoteSwitchOn := TRUE;
            myTask.Run();
            Assert.Equal(TRUE, myTask.IsSwitchedOn());
            Assert.Equal(FALSE, myTask.IsSwitchedOff());
            // Act/Assert     
            myTask.RemoteSwitchOn := FALSE;
            myTask.Run();
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
            Assert.Equal(TRUE, myTask.IsSwitchedOff());
        END_METHOD

        {Test}
        METHOD PUBLIC RemoteSwitchOn_signal_rising_edge_should_not_create_the_rising_edge_of_the_state_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
            Assert.Equal(TRUE, myTask.IsSwitchedOff());
            // Act/Assert     
            myTask.SetIsDisabled(TRUE);
            myTask.RemoteSwitchOn := TRUE;
            myTask.Run();
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
            Assert.Equal(TRUE, myTask.IsSwitchedOff());
        END_METHOD

        {Test}
        METHOD PUBLIC RemoteSwitchOn_signal_should_be_FALSE_after_Run_method_is_called_if_task_is_disabled
            // Arrange
            THIS.Initialize();
            _context.Open();
            // Act/Assert     
            myTask.SetIsDisabled(TRUE);  
            myTask.RemoteSwitchOn := TRUE;
            myTask.Run();
            Assert.Equal(FALSE, myTask.RemoteSwitchOn);
        END_METHOD

        {Test}
        METHOD PUBLIC if_task_state_is_TRUE_and_task_become_disabled_it_should_change_its_state_to_FALSE
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.RemoteSwitchOn := TRUE;
            myTask.Run();
            Assert.Equal(TRUE, myTask.IsSwitchedOn());
            // Act/Assert   
            myTask.SetIsDisabled(TRUE);  
            myTask.Run();
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
            Assert.Equal(TRUE, myTask.IsSwitchedOff());
        END_METHOD

        {Test}
        METHOD PUBLIC if_task_state_is_TRUE_and_task_become_disabled_it_should_change_its_state_to_FALSE_even_without_Run_method_called
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.RemoteSwitchOn := TRUE;
            myTask.Run();
            Assert.Equal(TRUE, myTask.IsSwitchedOn());
           // Act/Assert   
            myTask.SetIsDisabled(TRUE);  
            Assert.Equal(FALSE, myTask.IsSwitchedOn());
            Assert.Equal(TRUE, myTask.IsSwitchedOff());
        END_METHOD


    END_CLASS
END_NAMESPACE

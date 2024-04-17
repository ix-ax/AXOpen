{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl  : BOOL;
        _testRobot1      : AXOpen.Components.Abb.Robotics.AxoIrc5_v_1_x_x; 
        _testRobot2      : AXOpen.Components.Abb.Robotics.AxoOmnicore_v_1_x_x; 
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        _testRobot1.Run(parent      := THIS,
                        hwID            := HwIdentifiers#RobotBasicIO,
                        hwIdDI_64_bytes := HwIdentifiers#RobotBasicIO_DI_64_bytes_1,      
                        hwIdDO_64_bytes := HwIdentifiers#RobotBasicIO_DO_64_bytes_1);        


        _testRobot2.Run( parent      := THIS,
                         hwID        := HwIdentifiers#OmniCore,
                         hwIdDI_64_bytes := HwIdentifiers#OmniCore_DI_64_bytes_1,      
                         hwIdDO_64_bytes := HwIdentifiers#OmniCore_DO_64_bytes_1);        

        IF(_manualControl) THEN
            _testRobot1.ActivateManualControl();
            _testRobot2.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS
  
{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl  : BOOL;
        _testRobot1      : AXOpen.Components.Abb.Robotics.AxoIrc5_v_1_x_x; 
        _testRobot2      : AXOpen.Components.Abb.Robotics.AxoIrc5_v_1_x_x; 
        PlcInputs       : REF_TO PlcInputs;
        PlcOutputs      : REF_TO PlcOutputs;       
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        _testRobot1.Run( parent      := THIS,
                         hwID        := TO_UINT(HwIdentifiers#RobotBasicIO),
                         refInputs   := REF(PlcInputs^.RobotBasicIO_DI_64_bytes_1),     
                         refOutputs  := REF(PlcOutputs^.RobotBasicIO_DO_64_bytes_1)); 


        _testRobot2.Run( parent      := THIS,
                         hwID        := TO_UINT(HwIdentifiers#OmniCore),
                         refInputs   := REF(PlcInputs^.OmniCore_DI_64_bytes_1),      
                         refOutputs  := REF(PlcOutputs^.OmniCore_DO_64_bytes_1));        

        IF(_manualControl) THEN
            _testRobot1.ActivateManualControl();
            _testRobot2.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS
  
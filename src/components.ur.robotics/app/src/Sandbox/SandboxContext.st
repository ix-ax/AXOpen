{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        PowerOnImpulse : BOOL;         
        movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;

        _testRobot     :  AXOpen.Components.Ur.Robotics.AxoUrCb3_v_3_x_x;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        _testRobot.Run( parent                                                  := THIS,
                        hwID                                                    := HwIdentifiers#URIODev1,
                        hwIdAxoUrRobotics_T2O_State                             := HwIdentifiers#URIODev1_1_T2O_State_1,
                        hwIdAxoUrRobotics_T2O_IO                                := HwIdentifiers#URIODev1_2_T2O_IO_1,
                        hwIdAxoUrRobotics_T2O_Joints                            := HwIdentifiers#URIODev1_3_T2O_Joints_1,
                        hwIdAxoUrRobotics_T2O_TCP                               := HwIdentifiers#URIODev1_4_T2O_TCP_1,
                        hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers     := HwIdentifiers#URIODev1_5_T2O_General_Purpose_Bit_Registers_1,
                        hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers     := HwIdentifiers#URIODev1_6_T2O_General_Purpose_Int_Registers_1,
                        hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers   := HwIdentifiers#URIODev1_7_T2O_General_Purpose_Float_Registers_1,
                        hwIdAxoUrRobotics_O2T_Robot_IO                          := HwIdentifiers#URIODev1_8_O2T_Robot_IO_1,
                        hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1       := HwIdentifiers#URIODev1_9_O2T_General_Purpose_Registers_1_1,
                        hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2       := HwIdentifiers#URIODev1_10_O2T_General_Purpose_Registers_2_1,
                        refPowerOnPulse                                         := REF (PowerOnImpulse));

        IF(_manualControl) THEN
            _testRobot.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS


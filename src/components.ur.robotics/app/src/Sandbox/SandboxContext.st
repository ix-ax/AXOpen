{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        PowerOnImpulse : BOOL;         
        movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;

        _testRobot     :  AXOpen.Components.Ur.Robotics.AxoUrCb3_v_3_x_x;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        RETURN;
        _testRobot.Run(     parent                                                  := THIS,
                            hwID                                                    := HwIdentifiers#ureol2l_HwID,
                            hwIdAxoUrRobotics_T2O_State                             := HwIdentifiers#ureol2l_1_T2O_State_1_T2O_State_HwID,
                            hwIdAxoUrRobotics_T2O_IO                                := HwIdentifiers#ureol2l_2_T2O_IO_2_T2O_IO_HwID,
                            hwIdAxoUrRobotics_T2O_Joints                            := HwIdentifiers#ureol2l_3_T2O_Joints_3_T2O_Joints_HwID,
                            hwIdAxoUrRobotics_T2O_TCP                               := HwIdentifiers#ureol2l_4_T2O_TCP_4_T2O_TCP_HwID,
                            hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers     := HwIdentifiers#ureol2l_5_T2O_General_Purpose_Bit_Registers_5_T2O_General_Purpose_Bit_Registers_HwID,
                            hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers     := HwIdentifiers#ureol2l_6_T2O_General_Purpose_Int_Registers_6_T2O_General_Purpose_Int_Registers_HwID,
                            hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers   := HwIdentifiers#ureol2l_7_T2O_General_Purpose_Float_Registers_7_T2O_General_Purpose_Float_Registers_HwID,
                            hwIdAxoUrRobotics_O2T_Robot_IO                          := HwIdentifiers#ureol2l_8_O2T_Robot_IO_8_O2T_Robot_IO_HwID,
                            hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1       := HwIdentifiers#ureol2l_9_O2T_General_Purpose_Registers_1_9_O2T_General_Purpose_Registers_1_HwID,
                            hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2       := HwIdentifiers#ureol2l_10_O2T_General_Purpose_Registers_2_10_O2T_General_Purpose_Registers_2_HwID,
                            refPowerOnPulse                                         := REF (PowerOnImpulse));

        IF(_manualControl) THEN
            _testRobot.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS


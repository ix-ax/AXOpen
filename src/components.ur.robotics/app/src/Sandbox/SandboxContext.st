{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        PowerOnImpulse : BOOL;         
        movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;

        _testRobot     :  AXOpen.Components.Ur.Robotics.AxoUrCb3_v_3_x_x;
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;       
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        _testRobot.Run(   parent                                                    := THIS,
                            hwID                                                    := HwIdentifiers#URIODev1,
                            refAxoUrRobotics_T2O_State                              := REF(PlcInputs^.URIODev1_1_T2O_State_1),
                            refAxoUrRobotics_T2O_IO                                 := REF(PlcInputs^.URIODev1_2_T2O_IO_1),
                            refAxoUrRobotics_T2O_Joints                             := REF(PlcInputs^.URIODev1_3_T2O_Joints_1),
                            refAxoUrRobotics_T2O_TCP                                := REF(PlcInputs^.URIODev1_4_T2O_TCP_1),
                            refAxoUrRobotics_T2O_General_Purpose_Bit_Registers      := REF(PlcInputs^.URIODev1_5_T2O_General_Purpose_Bit_Registers_1),
                            refAxoUrRobotics_T2O_General_Purpose_Int_Registers      := REF(PlcInputs^.URIODev1_6_T2O_General_Purpose_Int_Registers_1),
                            refAxoUrRobotics_T2O_General_Purpose_Float_Registers    := REF(PlcInputs^.URIODev1_7_T2O_General_Purpose_Float_Registers_1),
                            refAxoUrRobotics_O2T_Robot_IO                           := REF(PlcOutputs^.URIODev1_8_O2T_Robot_IO_1),
                            refAxoUrRobotics_O2T_General_Purpose_Registers_1        := REF(PlcOutputs^.URIODev1_9_O2T_General_Purpose_Registers_1_1),
                            refAxoUrRobotics_O2T_General_Purpose_Registers_2        := REF(PlcOutputs^.URIODev1_10_O2T_General_Purpose_Registers_2_1),
                            refPowerOnPulse                                         := REF (PowerOnImpulse));

        IF(_manualControl) THEN
            _testRobot.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;   
        {#ix-attr:[Container(Layout.Stack)]}
        _testRobot : AXOpen.Components.Mitsubishi.Robotics.AxoCr800_v_1_x_x;
    END_VAR



    METHOD PROTECTED OVERRIDE Main
        RETURN;

        IF(_manualControl) THEN            
            _testRobot.ActivateManualControl();
        END_IF;   

        // _testRobot.Run(   parent             :=  THIS,
        //                         refStatus               := REF(PlcInputs^.wp462_t1_rh_deso_Input_1_byte_1),
        //                         refActScrewingProgram   := REF(PlcInputs^.wp462_t1_rh_deso_Input_1_byte_2),
        //                         refTorque               := REF(PlcInputs^.wp462_t1_rh_deso_Input_2_word_1),
        //                         refTorqueTrend          := REF(PlcInputs^.wp462_t1_rh_deso_Input_1_word_1),
        //                         refAngle                := REF(PlcInputs^.wp462_t1_rh_deso_Input_2_word_2),
        //                         refAngleTrend           := REF(PlcInputs^.wp462_t1_rh_deso_Input_1_word_2),
        //                         refControl              := REF(PlcOutputs^.wp462_t1_rh_deso_Output_1_byte_1),
        //                         refReqScrewingProgram   := REF(PlcOutputs^.wp462_t1_rh_deso_Output_1_byte_2));      
    END_METHOD
END_CLASS
{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        {#ix-attr:[Container(Layout.Stack)]}
        _testRobot : AXOpen.Components.Mitsubishi.Robotics.AxoCr800_v_1_x_x;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        RETURN;

        IF(_manualControl) THEN            
            _testRobot.ActivateManualControl();
        END_IF;   

        _testRobot.Run( parent              := THIS,
                        hwID                := HwIdentifiers#TZ535_PN,
                        hwIdInOut_64_byte   := HwIdentifiers#TZ535_PN_In_Out_64_byte_1);     
    END_METHOD
END_CLASS

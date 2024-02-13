{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        ActivateManualControl : BOOL;         
        ExampleRobot : AXOpen.Components.Kuka.Robotics.AxoKrc4_v_5_x_x;          
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        ExampleRobot.Run(THIS,
                            HwIdentifiers#KRC4,
                            HwIdentifiers#KRC4_512_digital_in_and_outputs_1);

        IF ActivateManualControl THEN
            ExampleRobot.ActivateManualControl();
        END_IF;                    
    END_METHOD
END_CLASS

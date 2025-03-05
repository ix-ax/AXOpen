NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            ActivateManualControl : BOOL;         
            _rootObject :   AxoObject;
            ExampleRobot : AXOpen.Components.Kuka.Robotics.AxoKrc4_v_5_x_x;          
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            ExampleRobot.Run(_rootObject,
                                HwIdentifiers#KRC4_HwID,
                                HwIdentifiers#KRC4_DIO512_512_digital_in__and_outputs_HwID);

            IF ActivateManualControl THEN
                ExampleRobot.ActivateManualControl();
            END_IF;                    
        END_METHOD
    END_CLASS
END_NAMESPACE
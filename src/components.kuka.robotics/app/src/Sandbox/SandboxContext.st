NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            ActivateManualControl : BOOL;         
            _rootObject :   AxoObject;
            ExampleRobot : AXOpen.Components.Kuka.Robotics.v_5_x_x.AxoKrc4;          
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            RETURN;
            ExampleRobot.Run(_rootObject,HwIdentifiers#kuka_rb1_HwID);

            IF ActivateManualControl THEN
                ExampleRobot.ActivateManualControl();
            END_IF;                    
        END_METHOD
    END_CLASS
END_NAMESPACE
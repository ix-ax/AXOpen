NAMESPACE AXOpen.Components.Mitsubishi.Robotics

    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl : BOOL;
            {#ix-attr:[Container(Layout.Stack)]}
            _testRobot : AXOpen.Components.Mitsubishi.Robotics.v_1_x_x.AxoCr800;
            _rootObject :   AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            RETURN;
            THIS.InitializeRootObject(_rootObject);

            IF(_manualControl) THEN            
                _testRobot.ActivateManualControl();
            END_IF;   

            _testRobot.Run(parent := _rootObject, hwID := HwIdentifiers#TZ535_PN_HwID);

        END_METHOD
    END_CLASS
END_NAMESPACE
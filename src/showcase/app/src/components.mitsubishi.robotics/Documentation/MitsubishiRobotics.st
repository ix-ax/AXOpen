NAMESPACE AXOpen.Components.Mitsubishi.Robotics
    {S7.extern=ReadWrite}
    CLASS MitsubishiRobotics EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject :   AxoObject;
            axoCr800_v_1_x_x : AxoCr800_v_1_x_x_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoCr800_v_1_x_x.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
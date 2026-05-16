USING AXOpen.Core;
NAMESPACE AXOpen.Components.Abb.Robotics
    {S7.extern=ReadWrite}
    CLASS AbbRobotics EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject  : AxoObject;
            axoIrc5_v_1_x_x : AxoIrc5_v_1_x_x_Showcase;
            axoOmnicore_v_1_x_x : AxoOmnicore_v_1_x_x_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoIrc5_v_1_x_x.Run(_rootObject);
            axoOmnicore_v_1_x_x.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
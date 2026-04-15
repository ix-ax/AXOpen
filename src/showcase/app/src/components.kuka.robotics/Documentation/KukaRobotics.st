NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    CLASS KukaRobotics EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            axoKrc4_v_5_x_x : AxoKrc4_v_5_x_x_Showcase;
            axoKrc4_v_5_x_x_2 : AxoKrc4_v_5_x_x_Showcase2;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoKrc4_v_5_x_x.Run(_rootObject);
            axoKrc4_v_5_x_x_2.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
USING AXOpen.Components.Kuka.Robotics.v_5_x_x;

NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    CLASS KukaRobotics EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject                     : AxoObject;
            axoKrc4_v_5_x_x                 : AxoKrc4_v_5_x_x_Showcase;
            axoKrc5_v_5_x_x                 : AxoKrc5_v_5_x_x_Showcase;
            axoKrc4_v_5_x_x_manualControl   : AxoKrc4_v_5_x_x_ManualControl;
            axoKrc5_v_5_x_x_manualControl   : AxoKrc5_v_5_x_x_ManualControl;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoKrc4_v_5_x_x.Run(_rootObject);
            axoKrc5_v_5_x_x.Run(_rootObject);
            axoKrc4_v_5_x_x_manualControl.Run(_rootObject);
            axoKrc5_v_5_x_x_manualControl.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE

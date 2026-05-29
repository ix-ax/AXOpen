USING AXOpen.Components.Ur.Robotics.v_3_x_x;

NAMESPACE AXOpen.Components.Ur.Robotics

    {S7.extern=ReadWrite}
    CLASS UrRobotics EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            axoUrCb3_v_3_x_x : AxoUrCb3_v_3_x_x_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoUrCb3_v_3_x_x.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
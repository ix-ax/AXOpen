USING AXOpen.Core;
USING AXOpen.Components.Abstractions.Drives;
NAMESPACE AXOpen.Components.Abb.Robotics
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl          : BOOL;
            _rootObject             : AxoObject;
            _AxoIrc5_v_1_x_x        : AXOpen.Components.Abb.Robotics.AxoIrc5_v_1_x_x; 
            _AxoOmnicore_v_1_x_x    : AXOpen.Components.Abb.Robotics.AxoOmnicore_v_1_x_x; 
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);

            _AxoIrc5_v_1_x_x.Run(       inParent  :=  _rootObject,
                                        hwID    :=  HwIdentifiers#abb_irc5_robot_HwID);        


            _AxoOmnicore_v_1_x_x.Run(   inParent  :=  _rootObject,
                                        hwID    :=  HwIdentifiers#abb_omnicore_robot_HwID);        

            IF(_manualControl) THEN
                _AxoIrc5_v_1_x_x.ActivateManualControl();
                _AxoOmnicore_v_1_x_x.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE

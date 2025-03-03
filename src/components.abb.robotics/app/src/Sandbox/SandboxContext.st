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
            _rootObject.InitializeWithContext(THIS);
            _AxoIrc5_v_1_x_x.Run(parent      := _rootObject,
                            hwID            := HwIdentifiers#RobotBasicIO_HwID,
                            hwIdDI_64_bytes := HwIdentifiers#RobotBasicIO_DI_64_bytes_DI_64_bytes_HwID,      
                            hwIdDO_64_bytes := HwIdentifiers#RobotBasicIO_DO_64_bytes_DO_64_bytes_HwID);        


            _AxoOmnicore_v_1_x_x.Run( parent      := _rootObject,
                            hwID        := HwIdentifiers#OmniCore_HwID,
                            hwIdDI_64_bytes := HwIdentifiers#OmniCore_DI_64_bytes_DI_64_bytes_HwID,      
                            hwIdDO_64_bytes := HwIdentifiers#OmniCore_DO_64_bytes_DO_64_bytes_HwID);        

            IF(_manualControl) THEN
                _AxoIrc5_v_1_x_x.ActivateManualControl();
                _AxoOmnicore_v_1_x_x.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE

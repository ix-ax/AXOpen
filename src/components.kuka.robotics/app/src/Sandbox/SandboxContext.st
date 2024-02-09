{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        _testCyclinder : AXOpen.Components.Kuka.Robotics.Example.ExampleCylinder;
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;       
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        _testCyclinder.Run(THIS,                             
                            REF(PlcInputs^._homeSensor_1), 
                            REF(PlcInputs^._workSensor_1), 
                            REF(PlcOutputs^._moveHomeSignal_1), 
                            REF(PlcOutputs^._moveWorkSignal_1));

        IF(_manualControl) THEN
            _testCyclinder.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS

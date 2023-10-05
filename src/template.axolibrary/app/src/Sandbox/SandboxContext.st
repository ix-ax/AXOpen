CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        _testCyclinder : AXOpen.Components.Example.ExampleCylinder;
    END_VAR

    VAR PRIVATE
        _homeSensor : BOOL;
        _workSensor : BOOL;
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
    END_VAR    

    METHOD PROTECTED OVERRIDE Main
        _testCyclinder.Run(THIS, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);
        IF(_manualControl) THEN
            _testCyclinder.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS
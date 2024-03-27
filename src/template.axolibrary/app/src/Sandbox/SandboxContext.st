USING Template.Axolibrary;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        _testCyclinder : Template.Axolibrary.TemplateComponent;
        _homeSensor : BOOL;
        _workSensor : BOOL;    
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        _testCyclinder.Run(THIS,  
                            WORD#64,                           
                            REF(_homeSensor), 
                            REF(_workSensor), 
                            REF(_moveHomeSignal), 
                            REF(_moveWorkSignal));

        IF(_manualControl) THEN
            _testCyclinder.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS

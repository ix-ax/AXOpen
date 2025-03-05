{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        _hwID   : WORD;
        _testComponent : AXOpen.Io.AxoIoComponent;
        _rootObject :   AxoObject;
    END_VAR    

    METHOD PROTECTED OVERRIDE Main
        THIS.InitializeRootObject(_rootObject);
        _testComponent.Run(_rootObject,_hwID);

        IF(_manualControl) THEN
            _testComponent.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS

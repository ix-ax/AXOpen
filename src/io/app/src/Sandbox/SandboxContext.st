{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        _hwID   : WORD;
        _testComponent : AXOpen.Io.AxoIoComponent;
    END_VAR    

    METHOD PROTECTED OVERRIDE Main
        _testComponent.Run(THIS,_hwID);

        IF(_manualControl) THEN
            _testComponent.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS

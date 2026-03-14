USING AXOpen.Core;
NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl : BOOL;
            _testComponent : AXOpen.Components.Rexroth.Tightening.Axo_CS351_compact;
            _rootObject : AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            _testComponent.Run(inParent  :=   _rootObject,hwID    :=   HwIdentifiers#rexroth_cs351_HwID);
            

            IF(_manualControl) THEN
                _testComponent.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE
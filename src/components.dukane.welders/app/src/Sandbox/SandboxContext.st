USING AXOpen.Core;
NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl : BOOL;
            _testComponent : AXOpen.Components.Dukane.Welders.Axo_IQ_SeriesWelder;
            _rootObject : AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            _testComponent.Run(parent  :=   _rootObject,hwID    :=   UINT#60);

            IF(_manualControl) THEN
                _testComponent.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE
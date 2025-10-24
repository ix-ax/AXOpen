USING AXOpen.Core;
NAMESPACE AXOpen.Components.Desoutter.Tightening
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl      :   BOOL;
             _rootObject        :   AxoObject;
             {#ix-attr:[Container(Layout.Stack)]}
             _testScrewdriver   :   AXOpen.Components.Desoutter.Tightening.AxoCVIC_II;
        END_VAR


        METHOD PROTECTED OVERRIDE Main  
            RETURN;
            THIS.InitializeRootObject(_rootObject);
            IF(_manualControl) THEN            
                _testScrewdriver.ActivateManualControl();
            END_IF;   

            _testScrewdriver.Run(   parent  :=  _rootObject,
                                    hwID    := HwIdentifiers#desoutter_cvic_ii_HwID);       

            
        END_METHOD
    END_CLASS
END_NAMESPACE        
USING AXOpen.Core;
NAMESPACE Template.Axolibrary
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl : BOOL;
            _testComponent : Template.Axolibrary.TemplateComponent;
            _rootObject : AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            _testComponent.Run(
                                parent  :=   _rootObject,
                                hwID    :=   WORD#60,
                                hwID_1  :=   WORD#61,
                                hwID_2  :=   WORD#62,
                                hwID_3  :=   WORD#63,
                                hwID_4  :=   WORD#64,
                                hwID_5  :=   WORD#65,
                                hwID_6  :=   WORD#66,
                                hwID_7  :=   WORD#67,
                                hwID_8  :=   WORD#68,
                                hwID_9  :=   WORD#69,
                                hwID_10 :=   WORD#70,
                                hwID_11 :=   WORD#71,
                                hwID_12 :=   WORD#72,
                                hwID_13 :=   WORD#73,
                                hwID_14 :=   WORD#74,
                                hwID_15 :=   WORD#75,
                                hwID_16 :=   WORD#76,
                                hwID_17 :=   WORD#77,
                                hwID_18 :=   WORD#78,
                                hwID_19 :=   WORD#79,
                                hwID_20 :=   WORD#80);

            IF(_manualControl) THEN
                _testComponent.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AXOpen.Components.Elements.Tests
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext       
        
        VAR PUBLIC
            SignalParent : AxoObject;
        END_VAR

        
        METHOD PUBLIC OVERRIDE Open : ULINT
            SUPER.Open();
            THIS.InitializeRootObject(SignalParent);
        END_METHOD

        METHOD PROTECTED OVERRIDE Main
               ;
        END_METHOD               
    END_CLASS   
END_NAMESPACE

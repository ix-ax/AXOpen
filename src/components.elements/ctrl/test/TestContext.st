USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoIO.Tests
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext       
        
        VAR PUBLIC
            SignalParent : AxoObject;
        END_VAR

        
            METHOD PUBLIC OVERRIDE Open : ULINT
                SUPER.Open();
                SignalParent.Initialize(THIS);
            END_METHOD

        METHOD PROTECTED OVERRIDE Main
               ;
        END_METHOD               
    END_CLASS   
END_NAMESPACE

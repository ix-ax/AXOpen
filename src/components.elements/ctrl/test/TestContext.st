USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoIO.Tests
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext       
        
        VAR PUBLIC
            SignalParent : AxoObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
               ;
        END_METHOD               
    END_CLASS   
END_NAMESPACE

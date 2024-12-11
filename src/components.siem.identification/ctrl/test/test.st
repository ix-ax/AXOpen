USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE Tests
    {S7.extern=ReadWrite}
   CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS MyTests 
        VAR 
            context : TestContext;

        END_VAR           
        {Test}
        METHOD PUBLIC MyTest
                AxUnit.Assert.Equal(TRUE,TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE

USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoCr800_Tests.Tests
    {S7.extern=ReadWrite}
   CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoCr800_Tests 
        VAR 
            context : TestContext;            
            
            
        END_VAR           
        {Test}
        METHOD PUBLIC MoveHome
            AxUnit.Assert.Equal(TRUE, TRUE);               
        END_METHOD
    END_CLASS    
END_NAMESPACE

USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AXOpen.Components.Kuka.Robotics.Tests
    {S7.extern=ReadWrite}
   CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS MyTestFixture 
        VAR 
            context : TestContext;
        END_VAR           
        {Test}
        METHOD PUBLIC Test1
            AxUnit.Assert.Equal(TRUE, TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE

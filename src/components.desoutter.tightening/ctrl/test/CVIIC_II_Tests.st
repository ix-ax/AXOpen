USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE Cylinder.Tests
    {S7.extern=ReadWrite}
   CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoCVIC_II_Tests 
        VAR 
            context : TestContext;
            screwdriver : AXOpen.Components.Desoutter.Tightening.AxoCVIC_II;
        END_VAR           
        {Test}
        METHOD PUBLIC Reset
            AxUnit.Assert.Equal(TRUE,TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE

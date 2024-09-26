USING AXOpen.Components.Robotics;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AXOpen.Components.Robotics.Tests
    {S7.extern=ReadWrite}
  CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS RoboticsTests 
        VAR 
            context : TestContext;
        END_VAR           
        {Test}
        METHOD PUBLIC Test1
            AxUnit.Assert.Equal(TRUE,TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE

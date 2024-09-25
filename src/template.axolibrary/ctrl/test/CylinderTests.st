USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE Template.Axolibrary.Tests
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS  
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS CylinderTests 
        VAR 
            context : TestContext;
            cylinder : TemplateComponent;
            _homeSensor : BOOL;
            _workSensor : BOOL;
            _moveHomeSignal : BOOL;
            _moveWorkSignal : BOOL;
            _done : BOOL;
        END_VAR           
        {Test}
        METHOD PUBLIC MoveHome
            WHILE _done DO
                context.Open();
                _done := Cylinder.MoveToHome().IsDone();
                cylinder.Run(context, WORD#64, REF(_homeSensor), REF(_workSensor), REF(_moveHomeSignal), REF(_moveWorkSignal));
                AxUnit.Assert.Equal(_moveHomeSignal, _moveHomeSignal);   
                context.Close();            
            END_WHILE;
        END_METHOD
    END_CLASS    
END_NAMESPACE

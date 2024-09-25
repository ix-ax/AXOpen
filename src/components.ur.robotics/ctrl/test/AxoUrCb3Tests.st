USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoUrCb3.Tests
    {S7.extern=ReadWrite}
   CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoUrCb3Tests 
        VAR 
            context : TestContext;          
            _homeSensor : BOOL;
            _workSensor : BOOL;
            _moveHomeSignal : BOOL;
            _moveWorkSignal : BOOL;
            _done : BOOL;
        END_VAR           
        {Test}
        METHOD PUBLIC MoveHome
            AxUnit.Assert.Equal(_moveHomeSignal, _moveHomeSignal);             
        END_METHOD
    END_CLASS    
END_NAMESPACE

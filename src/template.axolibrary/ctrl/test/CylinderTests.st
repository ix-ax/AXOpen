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
        VAR PROTECTED
            _context         :   TestContext;
            _rootObject      :   MockAxoObject;
            _cylinder : TemplateComponent;
            _homeSensor : BOOL;
            _workSensor : BOOL;
            _moveHomeSignal : BOOL;
            _moveWorkSignal : BOOL;
            _done : BOOL;
        END_VAR        
                
        VAR PRIVATE
            _contextClean    :   TestContext;
            _rtc             :   AXOpen.Core.Dummies.MockAxoRtc;
            _rtm             :   AXOpen.Core.Dummies.MockAxoRtm;
        END_VAR    

        {TestSetup}
        METHOD PUBLIC TestSetup
            _context    :=  _contextClean;  
            _rootObject.InitializeWithContext(_context);
            _rtm.SetElapsed(LTIME#2s);
            _context.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            _context.InjectRtc(_rtc);
            _rootObject.InitializeWithContext(_context);
        END_METHOD
    
        {Test}
        METHOD PUBLIC MoveHome
            WHILE _done DO
                _context.Open();
                _done := _cylinder.MoveToHome().IsDone();
                _cylinder.Run(_rootObject, WORD#64, REF(_homeSensor), REF(_workSensor), REF(_moveHomeSignal), REF(_moveWorkSignal));
                AxUnit.Assert.Equal(_moveHomeSignal, _moveHomeSignal);   
                _context.Close();            
            END_WHILE;
        END_METHOD
    END_CLASS    
END_NAMESPACE

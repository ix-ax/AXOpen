USING AXUnit;
USING AXOpen.Core;
USING AXOpen.Core.Dummies;
USING AXOpen.Rtc;
USING AXOpen.Rtm;
USING AXOpen.Logging;
USING AXOpen.Components.Keyence.Vision;

NAMESPACE AXOpen.Components.Keyence.Vision.Tests
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD               
    END_CLASS  
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS Axo_SR_750Tests 
        VAR PROTECTED
            _context            :   TestContext;
            _rootObject         :   MockAxoObject;
            _component          :   AXOpen.Components.Keyence.Vision.Axo_SR_750;
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
            _context.InitializeRootObject(_rootObject);
            _rtm.SetElapsed(LTIME#2s);
            _context.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            _context.InjectRtc(_rtc);
        END_METHOD
    
        {Test}
        METHOD PUBLIC Test1
            AxUnit.Assert.Equal(TRUE, TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE

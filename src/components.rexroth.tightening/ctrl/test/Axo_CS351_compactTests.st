USING AXUnit;
USING AXOpen.Core;
USING AXOpen.Core.Dummies;
USING AXOpen.Rtc;
USING AXOpen.Rtm;
USING AXOpen.Logging;
USING AXOpen.Components.Rexroth.Tightening;

NAMESPACE AXOpen.Components.Rexroth.Tightening.Tests
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
            _context        :   TestContext;
            _rootObject     :   MockAxoObject;
            _component      :   AXOpen.Components.Rexroth.Tightening.Axo_CS351_compact;
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
        METHOD PUBLIC MoveHome
            _context.Open();
            THIS._component.Run(
                                parent  :=   _rootObject,
                                hwID    :=   WORD#60,
                                hwID_1  :=   WORD#61,
                                hwID_2  :=   WORD#62,
                                hwID_3  :=   WORD#63,
                                hwID_4  :=   WORD#64,
                                hwID_5  :=   WORD#65,
                                hwID_6  :=   WORD#66,
                                hwID_7  :=   WORD#67,
                                hwID_8  :=   WORD#68,
                                hwID_9  :=   WORD#69,
                                hwID_10 :=   WORD#70,
                                hwID_11 :=   WORD#71,
                                hwID_12 :=   WORD#72,
                                hwID_13 :=   WORD#73,
                                hwID_14 :=   WORD#74,
                                hwID_15 :=   WORD#75,
                                hwID_16 :=   WORD#76,
                                hwID_17 :=   WORD#77,
                                hwID_18 :=   WORD#78,
                                hwID_19 :=   WORD#79,
                                hwID_20 :=   WORD#80,
                                hwID_21 :=   WORD#81,
                                hwID_22 :=   WORD#82,
                                hwID_23 :=   WORD#83,
                                hwID_24 :=   WORD#84,
                                hwID_25 :=   WORD#85,
                                hwID_26 :=   WORD#86);
            AxUnit.Assert.Equal(TRUE, TRUE);   
            _context.Close();            
    END_METHOD
    END_CLASS    
END_NAMESPACE

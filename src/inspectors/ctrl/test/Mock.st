USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Core;
NAMESPACE AXOpen.Inspectors.AxoInspector_Tests  

    {S7.extern=ReadWrite}
    CLASS AxoRtcMock IMPLEMENTS IAxoRtc
        VAR PRIVATE 
            _NowUTC : LDATE_AND_TIME;
        END_VAR

        METHOD INTERNAL SetNowUTC : LDATE_AND_TIME
            VAR_INPUT
                Set :  LDATE_AND_TIME;
            END_VAR;
            _NowUTC := Set;
        END_METHOD

        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            NowUTC := _NowUTC;
        END_METHOD        
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS INTERNAL AxoRtmMock IMPLEMENTS AXOpen.Rtm.IAxoRtm
        VAR PRIVATE 
            _elapsed : LTIME;
        END_VAR

        METHOD INTERNAL SetElapsed : LDATE_AND_TIME
            VAR_INPUT
                Set :  LTIME;
            END_VAR;
            _elapsed := Set;
        END_METHOD

        METHOD PUBLIC Elapsed : LTIME
            Elapsed := _elapsed;
        END_METHOD        
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext
                      
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
    END_CLASS      
END_NAMESPACE

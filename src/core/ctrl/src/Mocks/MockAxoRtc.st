
USING AXOpen.Messaging;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtm;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core.Dummies
    {S7.extern=ReadWrite}
    CLASS PUBLIC MockAxoRtc IMPLEMENTS IAxoRtc        
        VAR PRIVATE
            _nowUTC : LDATE_AND_TIME;
        END_VAR

        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            NowUTC := _nowUTC;
        END_METHOD

        METHOD PUBLIC SetNowUTC 
            VAR_INPUT
                Set : LDATE_AND_TIME;
            END_VAR
            _nowUTC := Set;
        END_METHOD
    END_CLASS          
END_NAMESPACE

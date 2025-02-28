
USING AXOpen.Messaging;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtm;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core.Dummies
    {S7.extern=ReadWrite}
    CLASS PUBLIC MockAxoRtm IMPLEMENTS IAxoRtm
        VAR PRIVATE
            _elapsed : LTIME;
        END_VAR

        METHOD PUBLIC Elapsed : LTIME
            Elapsed := _elapsed;
        END_METHOD

        METHOD PUBLIC SetElapsed
            VAR_INPUT
                Set : LTIME;
            END_VAR
            _elapsed := Set;
        END_METHOD
    END_CLASS          
END_NAMESPACE

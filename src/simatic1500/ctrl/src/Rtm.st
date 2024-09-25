USING Siemens.Simatic.S71500.Clocks;
NAMESPACE AXOpen.S71500
    {S7.extern=ReadWrite}
    CLASS Rtm IMPLEMENTS AXOpen.Rtm.IAxoRtm
        VAR
            _rtm : RuntimeMeasurement;
        END_VAR                    
        METHOD PUBLIC Elapsed : LTIME
            IF(NOT _rtm.GetIsRunning()) THEN
                _rtm.Start();
            END_IF;    
            Elapsed := _rtm.GetElapsed();
        END_METHOD
    END_CLASS
END_NAMESPACE

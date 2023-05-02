USING Siemens.Simatic.S71500.Clocks;
NAMESPACE AXOpen.S71500
    CLASS Rtc IMPLEMENTS AXOpen.Rtc.IAxoRtc        
        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            VAR_TEMP
                tmp_dt : LDATE_AND_TIME;
            END_VAR    
            GetSystemDateTime(value => NowUTC);             
        END_METHOD
    END_CLASS
END_NAMESPACE
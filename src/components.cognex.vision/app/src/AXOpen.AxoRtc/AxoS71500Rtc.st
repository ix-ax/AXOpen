NAMESPACE AxoRtc
    {S7.extern=ReadWrite}
    CLASS AxoS71500Rtc IMPLEMENTS AXOpen.Rtc.IAxoRtc
        VAR
            _rtc : AXOpen.S71500.Rtc;
        END_VAR    
        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            NowUTC := _rtc.NowUTC();            
        END_METHOD
    END_CLASS    
END_NAMESPACE

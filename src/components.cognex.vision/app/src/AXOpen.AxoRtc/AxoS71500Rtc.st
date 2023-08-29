NAMESPACE AxoRtc
    CLASS AxoS71500Rtc IMPLEMENTS AXOpen.Rtc.IAxoRtc
        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            Siemens.Simatic.S71500.Clocks.GetSystemDateTime(value => NowUTC);
        END_METHOD
    END_CLASS    
END_NAMESPACE

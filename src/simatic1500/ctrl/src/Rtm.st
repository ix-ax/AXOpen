USING Siemens.Simatic.Clocks;
USING System.Timer;
NAMESPACE AXOpen.S71500
    {S7.extern=ReadWrite}
    CLASS Rtm IMPLEMENTS AXOpen.Rtm.IAxoRtm
        VAR            
            _timer : OnDelay;
        END_VAR                    
        METHOD PUBLIC Elapsed : LTIME          
            _timer(signal := TRUE, duration := LTIME#100000d2h4m8s16ms32ns);
            Elapsed := _timer.elapsedTime;
        END_METHOD
    END_CLASS
END_NAMESPACE

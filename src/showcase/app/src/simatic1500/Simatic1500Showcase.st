USING AXOpen.Core;

// Showcase reference for AXOpen.S71500 — demonstrates the platform-specific
// real-time clock (Rtc) and runtime measurement (Rtm) implementations
// for the SIMATIC S7-1500 PLC family.
NAMESPACE AXOpen.Showcase.Simatic1500

    {S7.extern=ReadWrite}
    CLASS Simatic1500Showcase EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            _rtcDoc : RtcRtmDoc;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            _rtcDoc.Run(_rootObject);
        END_METHOD
    END_CLASS

    // Demonstrates Rtc (real-time clock) and Rtm (runtime measurement) usage.
    {S7.extern=ReadWrite}
    CLASS PUBLIC RtcRtmDoc EXTENDS AXOpen.Core.AxoObject
        //<Simatic1500Declarations>
        VAR PUBLIC
            _rtc : AXOpen.S71500.Rtc;
            _rtm : AXOpen.S71500.Rtm;
            _currentUtc : LDATE_AND_TIME;
            _elapsed : LTIME;
        END_VAR
        //</Simatic1500Declarations>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            //<RtcUsage>
            // Read the current UTC date and time from the PLC system clock.
            // Rtc implements IAxoRtc and is injected into AxoContext via InjectRtc().
            _currentUtc := _rtc.NowUTC();
            //</RtcUsage>

            //<RtmUsage>
            // Measure elapsed runtime since the PLC started.
            // Rtm implements IAxoRtm and is injected into AxoContext via InjectRtm().
            _elapsed := _rtm.Elapsed();
            //</RtmUsage>
        END_METHOD
    END_CLASS

END_NAMESPACE

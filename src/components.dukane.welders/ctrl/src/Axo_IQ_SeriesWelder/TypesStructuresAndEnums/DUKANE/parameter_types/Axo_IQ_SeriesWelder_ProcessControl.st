NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_ProcessControl
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#RegulationAmplitude#>"}
            RegulationAmplitude : DINT;                                                 // Amplitude SetpoINT, units of whole percentages, rang 20-100%
            {#ix-set:AttributeName = "<#RampUpTime#>"}
            RampUpTime : DINT;                                                          // Units of mS, range 20-32767mS. Values over 1000mS are extreme.
            {#ix-set:AttributeName = "<#RampDownTime#>"}
            RampDownTime : DINT;                                                        // Units of mS, range 20-32767mS.
            {#ix-set:AttributeName = "<#OBSOLETE_ProcessControlEnable#>"}
            OBSOLETE_ProcessControlEnable  : Axo_IQ_SeriesWelder_ProcessControlEnable;  // OBSOLETE: Replaced by "Axo_IQ_SeriesWelder_PressWeld.Weld X Source" USED_TO_BE: Unsigned 32bit INTeger bitmask allowing the control of 'IQ Controlled' or 'Auto
            {#ix-set:AttributeName = "<#WeldTime#>"}
            WeldTime : DINT;                                                            // Units of mS indicating the duration of the 'iQ Controlled' weld.
            {#ix-set:AttributeName = "<#WeldPower#>"}
            WeldPower : DINT;                                                           // Units of whole Watts indicating the maximum Power of the 'iQ Controlled' weld.
            {#ix-set:AttributeName = "<#WeldEnergy#>"}
            WeldEnergy : DINT;                                                          // Units of whole Joules indicating the total accumulation of Energy during the 'i
            {#ix-set:AttributeName = "<#HoldTime#>"}
            HoldTime : DINT;                                                            // Units of mS indicating the duration of the "HOLD"
            {#ix-set:AttributeName = "<#AfterBurstDelay#>"}
            AfterBurstDelay : DINT;                                                     // Units of mS indicating the duration of the "AfterBurst Delay".
            {#ix-set:AttributeName = "<#AfterBurstDuration#>"}
            AfterBurstDuration : DINT;                                                  // Units of mS indicating the duration of the "AfterBurst Duration".
        END_VAR 
    END_CLASS    
END_NAMESPACE

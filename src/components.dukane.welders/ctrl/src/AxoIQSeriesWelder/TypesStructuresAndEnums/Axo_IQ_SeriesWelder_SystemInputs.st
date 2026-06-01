NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_SystemInputs
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#SystemErrorStatus#>"}
            SystemErrorStatus : Axo_IQ_SeriesWelder_ErrorStatusBitDefinition;
            {#ix-set:AttributeName = "<#SystemInitiateError#>"}
            SystemInitiateError : DInt;
            {#ix-set:AttributeName = "<#SystemProcessError#>"}
            SystemProcessError : Axo_IQ_SeriesWelder_ProcessErrorStatus;
            {#ix-set:AttributeName = "<#GeneratorState#>"}
            GeneratorState : DInt;
            {#ix-set:AttributeName = "<#RealTimeAmplitude#>"}
            RealTimeAmplitude : DInt;   // The current amplitude of the stack in units percent amplitude.
            {#ix-set:AttributeName = "<#RealTimeFrequency#>"}
            RealTimeFrequency : DInt;   // The current frequency of the stack in units of Hz.
            {#ix-set:AttributeName = "<#RealTimePower#>"}
            RealTimePower : DInt;   // The current driven power of the stack in units of Watts
            {#ix-set:AttributeName = "<#SystemStatus#>"}
            SystemStatus : Axo_IQ_SeriesWelder_SystemStatusBitDefinition;
            {#ix-set:AttributeName = "<#Temperature#>"}
            Temperature : DInt;   // The current internal temperature of the iQ in units of Degrees Celcius
            {#ix-set:AttributeName = "<#CycleCount#>"}
            CycleCount : DInt;   // Count of total number of cycles since power up (not influenced by a test cycle)
            {#ix-set:AttributeName = "<#GoodPartCount#>"}
            GoodPartCount : DInt;   // Count of total number of "good parts" as determined by the Process Limits.
            {#ix-set:AttributeName = "<#BadPartCount#>"}
            BadPartCount : DInt;   // Count of total number of "bad parts" as determined by the Process Limits.
            {#ix-set:AttributeName = "<#SuspectPartCount#>"}
            SuspectPartCount : DInt;   // Count of total number of "suspect parts" as determined by the Process Limits.
            {#ix-set:AttributeName = "<#AbortedPartCount#>"}
            AbortedPartCount : DInt;   // Count of total number of weld cycles that failed to trigger since power up (not
            {#ix-set:AttributeName = "<#CyclePartStatus#>"}
            CyclePartStatus : Axo_IQ_SeriesWelder_CyclePartStatusBitDefinition;
            {#ix-set:AttributeName = "<#CycleWeldTime#>"}
            CycleWeldTime : DInt;   // Total Weld Time of the last cycle, units of mS .
            {#ix-set:AttributeName = "<#CycleWeldPeakPower#>"}
            CycleWeldPeakPower : DInt;   // Peak Weld Power of last cycle, units of Watts .
            {#ix-set:AttributeName = "<#CycleWeldEnergy#>"}
            CycleWeldEnergy : DInt;   // Total Weld Energy of last cycle, units of Joules .
            {#ix-set:AttributeName = "<#ActiveSetup#>"}
            ActiveSetup : DInt;   // Weld process control "setup" that the PLC access,values range from 1 to 16.
            {#ix-set:AttributeName = "<#RunningSetup#>"}
            RunningSetup : DInt;   // Commands the weld process control setup that the iQ will use on the next cycle,
            {#ix-set:AttributeName = "<#RunningMPCProbe#>"}
            RunningMPCProbe : DInt;   // Commands the MPC probe selection that the iQ will use on the next cycle, values
            {#ix-set:AttributeName = "<#SelectedInputVoltage#>"}
            SelectedInputVoltage : DInt;
            {#ix-set:AttributeName = "<#RealTimePosition#>"}
            RealTimePosition : DInt;
            {#ix-set:AttributeName = "<#RealTimeVelocity#>"}
            RealTimeVelocity : DInt;
            {#ix-set:AttributeName = "<#PressPartStatus_Bad_lo#>"}
            PressPartStatus_Bad_lo : Axo_IQ_SeriesWelder_PressPartStatusBitDefinition;
            {#ix-set:AttributeName = "<#PressPartStatus_Sus_lo#>"}
            PressPartStatus_Sus_lo : Axo_IQ_SeriesWelder_PressPartStatusBitDefinition;
            {#ix-set:AttributeName = "<#PressPartStatus_Sus_hi#>"}
            PressPartStatus_Sus_hi : Axo_IQ_SeriesWelder_PressPartStatusBitDefinition;
            {#ix-set:AttributeName = "<#PressPartStatus_Bad_hi#>"}
            PressPartStatus_Bad_hi : Axo_IQ_SeriesWelder_PressPartStatusBitDefinition;
            {#ix-set:AttributeName = "<#CycleTriggerTime#>"}
            CycleTriggerTime : DInt;
            {#ix-set:AttributeName = "<#CycleTriggerPosition#>"}
            CycleTriggerPosition : DInt;
            {#ix-set:AttributeName = "<#CycleTriggerDelayTime#>"}
            CycleTriggerDelayTime : DInt;
            {#ix-set:AttributeName = "<#CycleTriggerDelayDistance#>"}
            CycleTriggerDelayDistance : DInt;
            {#ix-set:AttributeName = "<#CycleWeld1Distance#>"}
            CycleWeld1Distance : DInt;
            {#ix-set:AttributeName = "<#CycleWeld1Position#>"}
            CycleWeld1Position : DInt;
            {#ix-set:AttributeName = "<#CycleTotalTime#>"}
            CycleTotalTime : DInt;
        END_VAR 
    END_CLASS
END_NAMESPACE

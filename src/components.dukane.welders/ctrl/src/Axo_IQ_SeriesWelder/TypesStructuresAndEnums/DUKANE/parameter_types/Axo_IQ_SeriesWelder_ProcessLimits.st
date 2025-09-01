NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_ProcessLimits
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#LowerBadEnergyLimit#>"}
            Enable                  : Axo_IQ_SeriesWelder_ProcessLimitEnable_legacy;    // Enable Limits:   1 = Bad, 2 = Suspect
            {#ix-set:AttributeName = "<#WeldTimeLowerBad#>"}
            WeldTimeLowerBad        : DINT;                                             // 0-65535 mS
            {#ix-set:AttributeName = "<#WeldTimeLowerSuspect#>"}
            WeldTimeLowerSuspect    : DINT;                                             // 0-65535 mS
            {#ix-set:AttributeName = "<#WeldTimeUpperSuspect#>"}
            WeldTimeUpperSuspect    : DINT;                                             // 0-65535 mS
            {#ix-set:AttributeName = "<#WeldTimeUpperBad#>"}
            WeldTimeUpperBad        : DINT;                                             // 0-65535 mS
            {#ix-set:AttributeName = "<#WeldPowerLowerBad#>"}
            WeldPowerLowerBad       : DINT;                                             // 0-65535 Watts
            {#ix-set:AttributeName = "<#WeldPwrLowerSuspect#>"}
            WeldPwrLowerSuspect     : DINT;                                             // 0-65535 Watts
            {#ix-set:AttributeName = "<#WeldPwrUpperSuspect#>"}
            WeldPwrUpperSuspect     : DINT;                                             // 0-65535 Watts
            {#ix-set:AttributeName = "<#WeldPowerUpperBad#>"}
            WeldPowerUpperBad       : DINT;                                             // 0-65535 Watts
            {#ix-set:AttributeName = "<#WeldEnergyLowerBad#>"}
            WeldEnergyLowerBad      : DINT;                                             // 0-65535 Joules
            {#ix-set:AttributeName = "<#WeldEnergyLowerSuspect#>"}
            WeldEnergyLowerSuspect  : DINT;                                             // 0-65535 Joules
            {#ix-set:AttributeName = "<#WeldEnergyUpperSuspect#>"}
            WeldEnergyUpperSuspect  : DINT;                                             // 0-65535 Joules
            {#ix-set:AttributeName = "<#WeldEnergyUpperBad#>"}
            WeldEnergyUpperBad      : DINT;                                             // 0-65535 Joules            
        END_VAR 
    END_CLASS    
END_NAMESPACE
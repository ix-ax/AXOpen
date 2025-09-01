NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_SystemInputs
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#N0#>"}
            N0  : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N01#>"}
            N01 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N02#>"}
            N02 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N03#>"}
            N03 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N04#>"}
            N04 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N05#>"}
            N05 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N06#>"}
            N06 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#ClearSetup#>"}
            ClearSetup : BOOL;              // Not Used
            {#ix-set:AttributeName = "<#N2#>"}
            N2 : BOOL;                      // Not Used
            {#ix-set:AttributeName = "<#N3#>"}
            N3 : BOOL;                      // Not Used
            {#ix-set:AttributeName = "<#N4#>"}
            N4 : BOOL;                      // Not Used
            {#ix-set:AttributeName = "<#N5#>"}
            N5 : BOOL;                      // Not Used
            {#ix-set:AttributeName = "<#N6#>"}
            N6 : BOOL;                      // Not Used
            {#ix-set:AttributeName = "<#N7#>"}
            N7 : BOOL;                      // Not Used
            {#ix-set:AttributeName = "<#N8#>"}
            N8 : BOOL;                      // Not Used
            {#ix-set:AttributeName = "<#N9#>"}
            N9 : BOOL;                      // Not Used
            {#ix-set:AttributeName = "<#RunScan#>"}
            RunScan : BOOL;                 // A rising edge will run a "Test Scan" cycle.
            {#ix-set:AttributeName = "<#N11#>"}
            N11 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N12#>"}
            N12 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N13#>"}
            N13 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N14#>"}
            N14 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N15#>"}
            N15 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N16#>"}
            N16 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#N17#>"}
            N17 : BOOL;                     // Not Used
            {#ix-set:AttributeName = "<#RunContinuously#>"}
            RunContinuously : BOOL;         // A rising edge will start an "iQ Controlled" weld cycle, sonics will run.
            {#ix-set:AttributeName = "<#RunWeld#>"}
            RunWeld : BOOL;                 // A high level will run an "Automation Controlled" weld cycle.
            {#ix-set:AttributeName = "<#RunTest#>"}
            RunTest : BOOL;                 // A high level will run an test cycle.
            {#ix-set:AttributeName = "<#ClearError#>"}
            ClearError : BOOL;              // This will reset any clearable errors in the iQ.
            {#ix-set:AttributeName = "<#OTF_AmplitudeEnable#>"}
            OTF_AmplitudeEnable : BOOL;     // Enable the On-The-Fly Amplitude adjustment feature.
            {#ix-set:AttributeName = "<#CycleStop#>"}
            CycleStop : BOOL;               // A rising edge will stop sonics. A new cycle will cannot be started when this is
            {#ix-set:AttributeName = "<#FrontPanelLockout_0#>"}
            FrontPanelLockout_0 : BOOL;     // Not Applicable for iQ Auto Plus
            {#ix-set:AttributeName = "<#FrontPanelLockout_1#>"}
            FrontPanelLockout_1 : BOOL;     // Not Applicable for iQ Auto Plus
            {#ix-set:AttributeName = "<#OTF_Amp_Setpoint#>"}
            OTF_Amp_Setpoint : DINT := DINT#20;   // On-The-Fly Amplitude SetPoint.
            {#ix-set:AttributeName = "<#ActiveSetupSelection#>"}
            ActiveSetupSelection : DINT := DINT#1;
            {#ix-set:AttributeName = "<#RunningSetupSelection#>"}
            RunningSetupSelection : DINT := DINT#1;   // This Setup# field is what tells the iQ which locally stored setup to use on the
            {#ix-set:AttributeName = "<#RunningMPCProbeSelection#>"}
            RunningMPCProbeSelection : DINT := DINT#1;   // Values of 1 to 16 are permitted, values outside of that range will be ignored.
        END_VAR 
    END_CLASS    
END_NAMESPACE
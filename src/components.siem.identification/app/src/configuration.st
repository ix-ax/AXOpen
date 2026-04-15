USING AXOpen.Components.Siem.Identification;

CONFIGURATION MyConfiguration
    TASK Main(Interval := T#1ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}                   
        Inputs AT %IB0 : AXOpen.Components.Siem.Identification.Inputs;
        {S7.extern=ReadWrite}  
        Outputs AT %QB0 : AXOpen.Components.Siem.Identification.Outputs;    
        {S7.extern=ReadWrite}
        sandbox : SandboxContext;
        {S7.extern=ReadWrite}
        documentation : DocumentationContext;
        {S7.extern=ReadWrite}
        _rtc : AXOpen.S71500.Rtc;
        {S7.extern=ReadWrite}
        _rtm : AXOpen.S71500.Rtm;
    END_VAR            

END_CONFIGURATION


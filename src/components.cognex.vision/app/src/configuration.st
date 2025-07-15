USING AXOpen.Components.Cognex.Vision;

CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        sandbox : SandboxContext;
        {S7.extern=ReadWrite}
        documentation : DocumentationContext;
        {S7.extern=ReadWrite}
        _rtc : AXOpen.S71500.Rtc;
        {S7.extern=ReadWrite}
        _rtm : AXOpen.S71500.Rtm;
        {S7.extern=ReadWrite}                   
        Inputs AT %IB0 : AXOpen.Components.Cognex.Vision.Inputs;
        {S7.extern=ReadWrite}  
        Outputs AT %QB0 : AXOpen.Components.Cognex.Vision.Outputs;            
    END_VAR            

END_CONFIGURATION




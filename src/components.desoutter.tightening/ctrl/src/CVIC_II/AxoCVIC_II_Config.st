NAMESPACE AXOpen.Components.Desoutter.Tightening
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoCVIC_II_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Screwing program min#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgramMin         :   BYTE := BYTE#0;
            {#ix-set:AttributeName = "<#Screwing program max#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgramMax         :   BYTE := BYTE#255;
            {#ix-set:AttributeName = "<#Program change timeout#>"}
            {#ix-attr:[ReadOnly()]}
            ProgramChangeTimeout         :   TIME := TIME#2S;
            {#ix-set:AttributeName = "<#Screwing cycle timeout#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingCycleTimeout         :   TIME := TIME#60S;
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
        END_VAR 
    END_CLASS    
END_NAMESPACE
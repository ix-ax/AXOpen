NAMESPACE AXOpen.Components.Festo.Drives
   
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_750_OUT
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#M_ADD1#>"}
            M_ADD1    :	INT;
            {#ix-set:AttributeName = "<#M_LIMIT_POS#>"}
            M_LIMIT_POS  :	INT;
            {#ix-set:AttributeName = "<#M_LIMIT_NEG#>"}
            M_LIMIT_NEG    :	INT;
            {#ix-set:AttributeName = "<#Reserved#>"}
            Reserved :	WORD;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_750_IN
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#M_Actual#>"}
            M_Actual    :	INT;
        END_VAR
    END_CLASS


    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_750
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#OUT#>"}
            OUT      :   PROFIdriveTelegram_750_OUT;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IN#>"}
            IN      :   PROFIdriveTelegram_750_IN;
        END_VAR
    END_CLASS
END_NAMESPACE
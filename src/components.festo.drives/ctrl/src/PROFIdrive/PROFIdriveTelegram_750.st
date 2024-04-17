NAMESPACE AXOpen.Components.Festo.Drives
   
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_750_OUT
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#M_ADD1#>"}
            {#ix-attr:[ReadOnly()]}
            M_ADD1    :	INT;
            {#ix-set:AttributeName = "<#M_LIMIT_POS#>"}
            {#ix-attr:[ReadOnly()]}
            M_LIMIT_POS  :	INT;
            {#ix-set:AttributeName = "<#M_LIMIT_NEG#>"}
            {#ix-attr:[ReadOnly()]}
            M_LIMIT_NEG    :	INT;
            {#ix-set:AttributeName = "<#Reserved#>"}
            {#ix-attr:[ReadOnly()]}
            Reserved :	WORD;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC PROFIdriveTelegram_750_IN
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#M_Actual#>"}
            {#ix-attr:[ReadOnly()]}
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
            {#ix-attr:[ReadOnly()]}
            OUT      :   PROFIdriveTelegram_750_OUT;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IN#>"}
            {#ix-attr:[ReadOnly()]}
            IN      :   PROFIdriveTelegram_750_IN;
        END_VAR
    END_CLASS
END_NAMESPACE
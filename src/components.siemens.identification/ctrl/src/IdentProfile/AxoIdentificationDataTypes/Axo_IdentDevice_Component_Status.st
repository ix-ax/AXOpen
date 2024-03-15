NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_IdentDevice_Component_Status  EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            {#ix-set:AttributeName = "IdentProfile_Status: |[[1]IdentProfileDescription]|"}
            {#ix-attr:[WarningLevel(500)]}
            {#ix-attr:[ErrorLevel(700)]}
            IdentProfile_Status    :   AXOpen.Core.AxoTextList;	
        END_VAR 
    END_CLASS    
END_NAMESPACE






NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_IdentDevice_Component_Status  EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC 
            UID             :   STRING;
            VersionHighByte :   BYTE;
            VersionLowByte  :   BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE






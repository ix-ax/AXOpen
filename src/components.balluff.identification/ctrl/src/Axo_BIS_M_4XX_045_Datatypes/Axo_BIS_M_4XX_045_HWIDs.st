NAMESPACE AXOpen.Components.Balluff.Identification
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC Axo_BIS_M_4XX_045_HWIDs
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Hardware ID of the device#>"}
            HW_Device              :  UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'BISM' submodule#>"}
            HwId_BISM       :   UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE


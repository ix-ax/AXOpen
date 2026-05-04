NAMESPACE AXOpen.Components.Kuka.Robotics.v_5_x_x 
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoKrc5_HWIDs  
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Hardware ID of the device#>"}
            HwID_Device            :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'None' submodule#>"}
            HwID_None                :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the '512_DI_DO' submodule#>"}
            HwID_512_DI_DO                                   :   UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE
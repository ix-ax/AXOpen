NAMESPACE AXOpen.Components.Desoutter.Tightening
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoCVIC_II_HWIDs
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Hardware ID of the device#>"}
            HwID_Device            :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'Input_1_byte_1' submodule#>"}
            HwId_Input_1_byte_1    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'Input_1_byte_2' submodule#>"}
            HwId_Input_1_byte_2    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'Input_2_word_1' submodule#>"}
            HwId_Input_2_word_1    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'Input_1_word_1' submodule#>"}
            HwId_Input_1_word_1    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'Input_2_word_2' submodule#>"}
            HwId_Input_2_word_2    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'Input_1_word_2' submodule#>"}
            HwId_Input_1_word_2    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'Output_1_byte_1' submodule#>"}
            HwId_Output_1_byte_1   :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'Output_1_byte_2' submodule#>"}
            HwId_Output_1_byte_2   :   UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE
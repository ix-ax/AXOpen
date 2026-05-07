NAMESPACE AXOpen.Components.Ur.Robotics.v_3_x_x
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRobotics_HWIDs
        VAR PUBLIC 
   
            {#ix-set:AttributeName = "<#Hardware ID of the Device#>"}
            HwId_Device                                              : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'T2O_State' submodule#>"}
            HwId_AxoUrRobotics_T2O_State                             : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'T2O_IO' submodule#>"}
            HwId_AxoUrRobotics_T2O_IO                                : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'T2O_Joints' submodule#>"}
            HwId_AxoUrRobotics_T2O_Joints                            : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'T2O_TCP' submodule#>"}
            HwId_AxoUrRobotics_T2O_TCP                               : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'T2O_General_Purpose_Bit_Registers' submodule#>"}
            HwId_AxoUrRobotics_T2O_General_Purpose_Bit_Registers     : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'T2O_General_Purpose_Int_Registers' submodule#>"}
            HwId_AxoUrRobotics_T2O_General_Purpose_Int_Registers     : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'T2O_General_Purpose_Float_Registers' submodule#>"}
            HwId_AxoUrRobotics_T2O_General_Purpose_Float_Registers   : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'O2T_Robot_IO' submodule#>"}
            HwId_AxoUrRobotics_O2T_Robot_IO                          : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'O2T_General_Purpose_Registers_1' submodule#>"}
            HwId_AxoUrRobotics_O2T_General_Purpose_Registers_1       : UINT;
            {#ix-set:AttributeName = "<#Hardware ID 'O2T_General_Purpose_Registers_2' submodule#>"}
            HwId_AxoUrRobotics_O2T_General_Purpose_Registers_2       : UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE

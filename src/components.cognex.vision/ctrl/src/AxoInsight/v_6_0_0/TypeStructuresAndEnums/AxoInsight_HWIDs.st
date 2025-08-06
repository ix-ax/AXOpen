NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoInsight_HWIDs
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Hardware ID of the device#>"}
            HW_Device               :  UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'AcquisitionControl' submodule#>"}
            HwIdAcquisitionControl  :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'AcquisitionStatus' submodule#>"}
            HwIdAcquisitionStatus   :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'InspectionControl' submodule#>"}
            HwIdInspectionControl      :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'InspectionStatus' submodule#>"}
            HwIdInspectionStatus       :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'CommandControl' submodule#>"}
            HwIdCommandControl    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'SoftEventControl' submodule#>"}
            HwIdSoftEventControl    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'UserData' submodule#>"}
            HwIdUserData            :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'ResultData' submodule#>"}
            HwIdResultData          :   UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE


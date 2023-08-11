NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Wrap)]}
        AxoInsight_Results : 
        STRUCT
            {#ix-set:AttributeName = "<#Inspection ID#>"}
            InspectionID : UINT;
            {#ix-set:AttributeName = "<#Result code#>"}
            ResultCode : UINT;
            {#ix-set:AttributeName = "<#Inspection results#>"}
            InspectionResults : AxoByteArray255;
            // InspectionResults :	ARRAY [0..249] OF BYTE;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
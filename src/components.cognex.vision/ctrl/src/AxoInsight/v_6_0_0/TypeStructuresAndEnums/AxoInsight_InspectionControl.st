NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Wrap)]}
        {S7.extern=ReadWrite}
        AxoInsight_InspectionControl : 
        STRUCT
            {#ix-set:AttributeName = "<#Enable results buffering#>"}
            EnableResultsBuffering          :   BOOL;
            {#ix-set:AttributeName = "<#Acknowledge inspection results#>"}
            AcknowledgeInspectionResults    :   BOOL;
            {#ix-set:AttributeName = "<#Extended user data set#>"}
            ExtendedUserDataSet             :   BOOL;
            {#ix-set:AttributeName = "<#Execute command#>"}
            ExecuteCommand                  :   BOOL;
            {#ix-set:AttributeName = "<#Clear error#>"}
            ClearError                      :   BOOL;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE

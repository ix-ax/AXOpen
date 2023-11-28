NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Wrap)]}
        {S7.extern=ReadWrite}
        AxoInsight_AcquisitionControl : 
        STRUCT
            {#ix-set:AttributeName = "<#Trigger enable#>"}
            TriggerEnable 			:	BOOL;
            {#ix-set:AttributeName = "<#Trigger#>"}
            Trigger					:	BOOL;
            {#ix-set:AttributeName = "<#Clear exposure complete#>"}
            ClearExposureComplete :  BOOL;
            {#ix-set:AttributeName = "<#Set offline#>"}
            SetOffline :  BOOL;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE

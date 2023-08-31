NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Wrap)]}
        AxoInsight_AcquisitionStatus : 
        STRUCT
            {#ix-set:AttributeName = "<#Trigger ready#>"}
            TriggerReady 		:	BOOL;
            {#ix-set:AttributeName = "<#Trigger acknowledge#>"}
            TriggerAcknowledge 	:	BOOL;
            {#ix-set:AttributeName = "<#Exposure complete#>"}
            ExposureComplete	:	BOOL;
            {#ix-set:AttributeName = "<#Missed acquisition#>"}
            MissedAcquisition 	:	BOOL;
            {#ix-set:AttributeName = "<#Offline reason 0#>"}
            OfflineReason0      :   BOOL;
            {#ix-set:AttributeName = "<#Offline reason 1#>"}
            OfflineReason1      :   BOOL;
            {#ix-set:AttributeName = "<#Offline reason 2#>"}
            OfflineReason2      :   BOOL;
            {#ix-set:AttributeName = "<#Online#>"}
            Online              :   BOOL;
            {#ix-set:AttributeName = "<#Acquisition ID#>"}
            AcquisitionID       :   UINT;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE



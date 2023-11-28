NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {S7.extern=ReadWrite}
        AxoDataman_AcquisitionStatus : 
        STRUCT
            {#ix-set:AttributeName = "<#Trigger ready#>"}
            TriggerReady 		:	BOOL;
            {#ix-set:AttributeName = "<#Trigger acknowledge#>"}
            TriggerAcknowledge 	:	BOOL;
            {#ix-set:AttributeName = "<#Acquiring#>"}
            Acquiring 			:	BOOL;
            {#ix-set:AttributeName = "<#Missed acquisition#>"}
            MissedAcquisition 	:	BOOL;
            {#ix-set:AttributeName = "<#Trigger ID#>"}
            TriggerID 			:	UINT;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        AxoDataman_AcquisitionStatus : 
        STRUCT
            TriggerReady 		:	BOOL;
            TriggerAcknowledge 	:	BOOL;
            Acquiring 			:	BOOL;
            MissedAcquisition 	:	BOOL;
            TriggerID 			:	UINT;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
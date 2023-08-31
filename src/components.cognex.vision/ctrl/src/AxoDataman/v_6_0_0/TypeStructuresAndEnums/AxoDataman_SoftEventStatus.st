NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        AxoDataman_SoftEventStatus : 
        STRUCT
            TrainCodeAcknowledge 			:   BOOL; 
            TrainMatchStringAcknowledge 	:   BOOL;
            TrainFocusAcknowledge 			:   BOOL; 		
            TrainBrightnessAcknowledge  	:   BOOL;
            UntrainAcknowledge  			:   BOOL; 	
            ExecuteDMCCAcknowledge 			:   BOOL; 	
            Reserved06 						:   BOOL; 	
            SetMatchStringAcknowledge  		:   BOOL; 
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
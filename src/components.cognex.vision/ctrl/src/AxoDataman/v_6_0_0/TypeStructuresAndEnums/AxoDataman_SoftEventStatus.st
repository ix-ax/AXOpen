NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {S7.extern=ReadWrite}
        AxoDataman_SoftEventStatus : 
        STRUCT
            {#ix-set:AttributeName = "<#Train code acknowledge#>"}
            TrainCodeAcknowledge 			:   BOOL; 
            {#ix-set:AttributeName = "<#Train match string acknowledge#>"}
            TrainMatchStringAcknowledge 	:   BOOL;
            {#ix-set:AttributeName = "<#Train focus acknowledge#>"}
            TrainFocusAcknowledge 			:   BOOL; 		
            {#ix-set:AttributeName = "<#Train brightness acknowledge#>"}
            TrainBrightnessAcknowledge  	:   BOOL;
            {#ix-set:AttributeName = "<#Untrain acknowledge#>"}
            UntrainAcknowledge  			:   BOOL; 	
            {#ix-set:AttributeName = "<#Execute DMCC acknowledge#>"}
            ExecuteDMCCAcknowledge 			:   BOOL; 	
            {#ix-attr:[CompilerOmits()]} 
            Reserved06 						:   BOOL; 	
            {#ix-set:AttributeName = "<#Set match string acknowledge#>"}
            SetMatchStringAcknowledge  		:   BOOL; 
        END_STRUCT;
    END_TYPE 
END_NAMESPACE

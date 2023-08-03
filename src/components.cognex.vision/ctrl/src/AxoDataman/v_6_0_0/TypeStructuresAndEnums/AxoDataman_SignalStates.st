NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-set:AttributeName = "<#Signal states#>"}
        {#ix-attr:[Container(Layout.Wrap)]}
        AxoDataman_SignalStates : 
        STRUCT
            {#ix-set:AttributeName = "<#Trigger enable#>"}
            TriggerEnable 			:	BOOL;
            {#ix-set:AttributeName = "<#Trigger#>"}
            Trigger					:	BOOL;
        
            {#ix-set:AttributeName = "<#Enable result buffering#>"}
            EnableResultBuffering	:	BOOL;
            {#ix-set:AttributeName = "<#Result acknowledge#>"}
            ResultsAcknowledge		:	BOOL;
        
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
        
            {#ix-set:AttributeName = "<#Decoding#>"}
            Decoding 				:	BOOL;
            {#ix-set:AttributeName = "<#Decode complete#>"}
            DecodeComplete 			:	BOOL;
            {#ix-set:AttributeName = "<#Result buffer overrun#>"}
            ResultsBufferOverrun 	:	BOOL;
            {#ix-set:AttributeName = "<#Results available#>"}
            ResultsAvailable 		:	BOOL;
            {#ix-set:AttributeName = "<#Error detected#>"}
            ErrorDetected 			:	BOOL;
        
            {#ix-set:AttributeName = "<#Result ID#>"}
            ResultID 				:	UINT;
            {#ix-set:AttributeName = "<#Result code#>"}
            ResultCode  			:	UINT;
            {#ix-set:AttributeName = "<#Result extended#>"}
            ResultExtended  		:	UINT;
            {#ix-set:AttributeName = "<#Result length#>"}
            ResultLength  			:	UINT;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
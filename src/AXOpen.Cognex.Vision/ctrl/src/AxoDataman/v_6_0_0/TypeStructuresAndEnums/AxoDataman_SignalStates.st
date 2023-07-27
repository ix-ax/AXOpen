NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        {attribute addProperty Name "<#Signal states#>"}
        {#ix-attr:[Container(Layout.Wrap)]}
        AxoDataman_SignalStates : 
        STRUCT
            {attribute addProperty Name "<#Trigger enable#>"}
            TriggerEnable 			:	BOOL;
            {attribute addProperty Name "<#Trigger#>"}
            Trigger					:	BOOL;
        
            {attribute addProperty Name "<#Enable result buffering#>"}
            EnableResultBuffering	:	BOOL;
            {attribute addProperty Name "<#Result acknowledge#>"}
            ResultsAcknowledge		:	BOOL;
        
            {attribute addProperty Name "<#Trigger ready#>"}
            TriggerReady 		:	BOOL;
            {attribute addProperty Name "<#Trigger acknowledge#>"}
            TriggerAcknowledge 	:	BOOL;
            {attribute addProperty Name "<#Acquiring#>"}
            Acquiring 			:	BOOL;
            {attribute addProperty Name "<#Missed acquisition#>"}
            MissedAcquisition 	:	BOOL;
            {attribute addProperty Name "<#Trigger ID#>"}
            TriggerID 			:	UINT;
        
            {attribute addProperty Name "<#Decoding#>"}
            Decoding 				:	BOOL;
            {attribute addProperty Name "<#Decode complete#>"}
            DecodeComplete 			:	BOOL;
            {attribute addProperty Name "<#Result buffer overrun#>"}
            ResultsBufferOverrun 	:	BOOL;
            {attribute addProperty Name "<#Results available#>"}
            ResultsAvailable 		:	BOOL;
            {attribute addProperty Name "<#Error detected#>"}
            ErrorDetected 			:	BOOL;
        
            {attribute addProperty Name "<#Result ID#>"}
            ResultID 				:	UINT;
            {attribute addProperty Name "<#Result code#>"}
            ResultCode  			:	UINT;
            {attribute addProperty Name "<#Result extended#>"}
            ResultExtended  		:	UINT;
            {attribute addProperty Name "<#Result length#>"}
            ResultLength  			:	UINT;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
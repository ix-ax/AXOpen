NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        AxoDataman_ResultsStatus : 
        STRUCT
            {#ix-set:AttributeName = "<#Decoding#>"}
            Decoding 			    :   BOOL;
            {#ix-set:AttributeName = "<#Decode complete#>"}
            DecodeComplete 		    :   BOOL;
            {#ix-set:AttributeName = "<#Results buffer overrun#>"}
            ResultsBufferOverrun    :   BOOL;
            {#ix-set:AttributeName = "<#Results available#>"}
            ResultsAvailable 	    :   BOOL;
            {#ix-set:AttributeName = "<#Error detected#>"}
            ErrorDetected 		    :   BOOL;     
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
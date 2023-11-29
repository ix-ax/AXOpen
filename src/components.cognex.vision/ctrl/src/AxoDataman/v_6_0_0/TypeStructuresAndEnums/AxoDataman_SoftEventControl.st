NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {S7.extern=ReadWrite}
        AxoDataman_SoftEventControl : 
        STRUCT
            {#ix-set:AttributeName = "<#Train code#>"}
            TrainCode 						:   BOOL; 			
            {#ix-set:AttributeName = "<#Train match string#>"}
            TrainMatchString 				:   BOOL;	
            {#ix-set:AttributeName = "<#Train focus#>"}
            TrainFocus 						:   BOOL;			
            {#ix-set:AttributeName = "<#Train brightness#>"}
            TrainBrightness 				:   BOOL;	
            {#ix-set:AttributeName = "<#Untrain#>"}
            Untrain 						:   BOOL;			
            {#ix-set:AttributeName = "<#Execute DMCC#>"}
            ExecuteDMCC 					:   BOOL;		
            {#ix-attr:[CompilerOmits()]} 
            Reserved06 						:   BOOL; 	
            {#ix-set:AttributeName = "<#Decoding#>"}
            SetMatchString 					:   BOOL;		
        END_STRUCT;
    END_TYPE 
END_NAMESPACE

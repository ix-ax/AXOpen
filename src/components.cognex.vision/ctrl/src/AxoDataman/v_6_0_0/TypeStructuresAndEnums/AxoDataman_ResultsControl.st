NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {S7.extern=ReadWrite}
        AxoDataman_ResultsControl : 
        STRUCT
            {#ix-set:AttributeName = "<#Enable results buffering#>"}
            EnableResultBuffering   :   BOOL;
            {#ix-set:AttributeName = "<#Results acknowledge#>"}
            ResultsAcknowledge      :   BOOL;        
        END_STRUCT;
    END_TYPE 
END_NAMESPACE

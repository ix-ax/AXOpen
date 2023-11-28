NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Wrap)]}
        {S7.extern=ReadWrite}
        AxoInsight_InspectionStatus : 
        STRUCT
            {#ix-set:AttributeName = "<#System busy#>"}
            SystemBusy                      :   BOOL;
            {#ix-set:AttributeName = "<#Inspection completed#>"}
            InspectionCompleted             :   BOOL;
            {#ix-set:AttributeName = "<#Results buffer overrun#>"}
            ResultsBufferOverrun            :   BOOL;
            {#ix-set:AttributeName = "<#Results valid#>"}
            ResultsValid                    :   BOOL;	
            {#ix-set:AttributeName = "<#Command executing#>"}
            CommandExecuting                :   BOOL;
            {#ix-set:AttributeName = "<#Command complete#>"}
            CommandComplete                 :   BOOL;
            {#ix-set:AttributeName = "<#Command failed#>"}
            CommandFailed                   :   BOOL;
            {#ix-set:AttributeName = "<#Extended user data set acknowledge#>"}
            ExtendedUserDataSetAcknowledge  :   BOOL;
            {#ix-set:AttributeName = "<#Overall job pass fail#>"}
            OverallJobPassFail              :   BOOL;
            {#ix-set:AttributeName = "<#Test run ready#>"}
            TestRunReady                    :   BOOL;
            {#ix-set:AttributeName = "<#Error#>"}
            Error                           :   BOOL;
            {#ix-set:AttributeName = "<#Error code#>"}
            ErrorCode                       :   UINT;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE

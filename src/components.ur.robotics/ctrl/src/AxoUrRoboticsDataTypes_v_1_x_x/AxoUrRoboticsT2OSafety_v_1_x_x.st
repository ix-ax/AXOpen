NAMESPACE AXOpen.Components.Ur.Robotics
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRoboticsT2OSafety_v_1_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Safety mode#>"}
            SafetyMode : USINT;
            {#ix-set:AttributeName = "<#NO: Is normal mode#>"}
            NO_IsNormalMode : BOOL;
            {#ix-set:AttributeName = "<#RD: Is reduced mode#>"}
            RD_IsReducedMode : BOOL;
            {#ix-set:AttributeName = "<#PS: Is protective stopped#>"}
            PS_IsProtectiveStopped : BOOL;
            {#ix-set:AttributeName = "<#RC: Is recovery mode#>"}
            RC_IsRecoveryMode : BOOL;
            {#ix-set:AttributeName = "<#SS: Is safeguard stopped#>"}
            SS_IsSafeguardStopped : BOOL;
            {#ix-set:AttributeName = "<#SES: Is system emergency stopped#>"}
            SES_IsSystemEmergencyStopped : BOOL;
            {#ix-set:AttributeName = "<#RES: Is robot emergency stopped#>"}
            RES_IsRobotEmergencyStopped : BOOL;
            {#ix-set:AttributeName = "<#ES: Is emergency stopped#>"}
            ES_IsEmergencyStopped : BOOL;
            {#ix-set:AttributeName = "<#VL: Is violation#>"}
            VL_IsViolation : BOOL;
            {#ix-set:AttributeName = "<#FT: Is fault#>"}
            FT_IsFault : BOOL;
            {#ix-set:AttributeName = "<#ST: Is stopped due TO safety#>"}
            ST_IsStoppedDueSafety : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE
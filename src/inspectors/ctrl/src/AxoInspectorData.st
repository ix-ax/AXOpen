NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// Data subjected to each inspector instance.
    ///</summary>
    CLASS AxoInspectorData 

        VAR PUBLIC

        //<CommonInspectorDataDeclaration>
        //timestamp of inspection
        {#ix-set:AttributeName = "<#TimeStamp#>"}
        Timestamp: LDATE_AND_TIME;

        //stabilization time, inspection must be success for this period of time
        {#ix-set:AttributeName = "<#Stab.Time#>"}
        PassTime : TIME;

        //timeout, after which inspection fails
        {#ix-set:AttributeName = "<#Timeout#>"}
        FailTime : TIME;

        //result of inspection
        {#ix-set:AttributeName = "<#Result#>"}
        Result : eInspectorResult;

        //inspection will be performed, however result will be omitted in overall result
        {#ix-set:AttributeName = "<#Excluded#>"}
        IsExcluded: BOOL;

        //inspection will be skipped
        {#ix-set:AttributeName = "<#Bypass#>"}
        IsByPassed : BOOL;

        //maximum number of retries of inspection
        {#ix-set:AttributeName = "<#Re-tries#>"}
        NumberOfAllowedRetries : UINT;

        //actual number of retries
        {#ix-set:AttributeName = "<#Attempts#>"}
        RetryAttemptsCount : UINT;
        //</CommonInspectorDataDeclaration>   
        END_VAR

    END_CLASS


END_NAMESPACE
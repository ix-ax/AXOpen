NAMESPACE AXOpen.Inspectors

    ///<summary>
    /// Data subjected to each inspector instance.
    ///</summary>
    CLASS AxoInspectorData 

        VAR PUBLIC

        
        {#ix-set:AttributeName = "<#TimeStamp#>"}
        Timestamp: LDATE_AND_TIME;

        {#ix-set:AttributeName = "<#Stab.Time#>"}
        PassTime : TIME;

        {#ix-set:AttributeName = "<#Timeout#>"}
        FailTime : TIME;

        {#ix-set:AttributeName = "<#Result#>"}
        Result : eInspectorResult;

        {#ix-set:AttributeName = "<#Excluded#>"}
        IsExcluded: BOOL;

        {#ix-set:AttributeName = "<#Bypass#>"}
        IsByPassed : BOOL;

        {#ix-set:AttributeName = "<#Failure description#>"}
        FailureDescription : STRING;

        {#ix-set:AttributeName = "<#Re-tries#>"}
        NumberOfAllowedRetries : UINT;

        {#ix-set:AttributeName = "<#Attempts#>"}
        RetryAttemptsCount : UINT;

        {#ix-set:AttributeName = "<#Code#>"}
        ErrorCode : STRING;

        END_VAR

    END_CLASS


END_NAMESPACE
NAMESPACE axosimple    
    TYPE
         {S7.extern=ReadWrite} 
        TechnologyUnitHeader :       
        STRUCT
            {#ix-set:AttributeName = "<#Cycle time#> - <#Nominal#>"}
            IdealCycleTime   : TIME;
            
            {#ix-set:AttributeName = "<#Cycle time#> - <#Warning#>"}
            WarningCycleTime : TIME;
            
            {#ix-set:AttributeName = "<#Cycle time#> - <#Error#>"}
            ErrorCycleTime   : TIME;
            
            {#ix-set:AttributeName = "<#Step time#> - <#Warning#>"}
            WarningStepAlarmTime : TIME;
            
            {#ix-set:AttributeName = "<#Step time#> - <#Error#>"}
            ErrorStepAlarmTime   : TIME;
            
            {#ix-set:AttributeName = "<#Energy saving mode - Inactivity time#> "}
            TimeToEntryEnergySavingMode : TIME;
            
            {#ix-set:AttributeName = "<#Consecutive Error count #> "}
            ConsecutiveErrorCount   : UINT;

    END_STRUCT;
END_TYPE
END_NAMESPACE

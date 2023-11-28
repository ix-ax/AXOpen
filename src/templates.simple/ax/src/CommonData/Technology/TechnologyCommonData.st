NAMESPACE axosimple

{S7.extern=ReadWrite}
CLASS TechnologyCommonData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC		
            {#ix-set:AttributeName = "<#Cycle time#> - <#Nominal#>"}
            IdealCycleTime   : TIME;
            
            {#ix-set:AttributeName = "<#Cycle time#> - <#Warning#>"}
            WarningCycleTime : TIME;
            
            {#ix-set:AttributeName = "<#Cycle time#> - <#Error#>"}
            ErrorCycleTime   : TIME;
                        
            {#ix-set:AttributeName = "<#Energy saving mode - Inactivity time#> "}
            TimeToEntryEnergySavingMode : TIME;
            
        END_VAR        
    END_CLASS
        
END_NAMESPACE

NAMESPACE axosimple

{S7.extern=ReadWrite}
CLASS EntityData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC		
            {#ix-set:AttributeName = "<#Last station#>"}
            LastStation : eStations;

            {#ix-set:AttributeName = "<#Next station#>"}
            NextStation : eStations;		

            {#ix-set:AttributeName = "<#Operations Opened#>"}
            OpenOn : eStations;	

            {#ix-set:AttributeName = "<#Results#>"}
            Results : AXOpen.Inspectors.AxoComprehensiveResult;
            
            {#ix-set:AttributeName = "<#Carrier#>"}
            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            Carrier : STRING;	
            
            {#ix-set:AttributeName = "<#Is empty#>"}
            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            IsEmpty : BOOL;
            
            {#ix-set:AttributeName = "<#Is Master#>"}
            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            IsMaster : BOOL;
            
            {#ix-set:AttributeName = "<#Reset or ground position performed#>"}
            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            WasReset : BOOL;

            // {#ix-set:AttributeName = "<#Reciepe#>"}
            // {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            // Reciepe : STRING;

            // {#ix-set:AttributeName = "<#Reciepe created#>"}
            // {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            // ReciepeCreated : DATE_AND_TIME;

            // {#ix-set:AttributeName = "<#Reciepe modified#>"}
            // {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            // ReciepeLastModified : DATE_AND_TIME;

            // {#ix-set:AttributeName = "<#Was Reworked#>"}
            // {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            // WasReworked : BOOL;	
            
            // {#ix-set:AttributeName = "<#Last Rework Name#>"}
            // {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            // {attribute 'qlik_load:LastReworkName'}
            // LastReworkName : STRING;
        
            // {#ix-set:AttributeName = "<#Rework Count#>"}
            // {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            // ReworkCount:SINT;
        END_VAR        
    END_CLASS
        
END_NAMESPACE

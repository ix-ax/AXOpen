NAMESPACE axosimple    
    TYPE PUBLIC 
        {S7.extern=ReadWrite}
        UnitHeader : STRUCT

            {#ix-set:AttributeName = "<#Next on Passed#>"}
            OnPassed : eStations;
            
            {#ix-set:AttributeName = "<#Next on Failed#>"}
            OnFailed : eStations;

            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            {#ix-set:AttributeName = "<#Cycle time#>"}
            CycleTime : TIME;

            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            {#ix-set:AttributeName = "<#Clean loop time#>"}
            CleanLoopTime : TIME;

            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            {#ix-set:AttributeName = "<#Operation started#>"}
            OperationsStarted : DATE_AND_TIME;
            
            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            {#ix-set:AttributeName = "<#Operation end#>"}
            OperationsEnded : DATE_AND_TIME;	
            
            {#ix-attr:[RenderIgnore("Control","ShadowControl")]}
            {#ix-set:AttributeName = "<#Operatod id#>"}
            Operator :STRING;
            
        END_STRUCT;
    END_TYPE
END_NAMESPACE

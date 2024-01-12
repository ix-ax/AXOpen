NAMESPACE AXOpen.Components.Abstractions.Robotics
    TYPE AxoRoboticsMovementsParams : STRUCT
            {#ix-set:AttributeName = "<#ActionNo#>"}
            ActionNo:BYTE;  
            {#ix-set:AttributeName = "<#GlobalSpeed#>"}
            GlobalSpeed:BYTE; 
            {#ix-set:AttributeName = "<#ToolNo#>"}
            ToolNo:BYTE;  
            {#ix-set:AttributeName = "<#WorkobjectNo#>"}
            WorkobjectNo:BYTE; 
            {#ix-set:AttributeName = "<#PointNo#>"}
            PointNo:BYTE;  
            {#ix-set:AttributeName = "<#UserSpecSpeed1#>"}
            UserSpecSpeed1:INT;  
            {#ix-set:AttributeName = "<#UserSpecSpeed2#>"}
            UserSpecSpeed2:INT;  
            {#ix-set:AttributeName = "<#Coordinates#>"}     
            Coordinates :AxoRoboticsCoordinates; 		
        END_STRUCT;
    END_TYPE
END_NAMESPACE

NAMESPACE AXOpen.Components.Rexroth.Press
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoSmartFunctionKitRequest_v_4_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Command#>"}
            Command : eAxoSmartFunctionKitCommand_v_4_x_x;
            {#ix-set:AttributeName = "<#Serial number#>"}
            SerialNumber:STRING[28];
            {#ix-set:AttributeName = "<#Program Id#>"}
            ProgramId:INT;
            {#ix-set:AttributeName = "<#Position distance tara#>"}
            PositionDistanceTara:REAL;
            {#ix-set:AttributeName = "<#Travel speed#>"}
            TravelSpeed:REAL;
            {#ix-set:AttributeName = "<#Acceleration#>"}
            Acceleration:REAL;
            {#ix-set:AttributeName = "<#Offset#>"}
            Offset:REAL;
        END_VAR 
    END_CLASS   
END_NAMESPACE
NAMESPACE AXOpen.Components.Rexroth.Press
    // {#ix-attr:[Container(Layout.Stack)]}
    // {S7.extern=ReadWrite}
    // CLASS PUBLIC AxoSmartFunctionKitRequest_v_4_x_x
    //     VAR PUBLIC 
    TYPE AxoSmartFunctionKitRequest_v_4_x_x :
        STRUCT
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
        END_STRUCT;
    END_TYPE

            // {#ix-set:AttributeName = "<#Value 1#>"}
            // Value1:DWORD;
            // {#ix-set:AttributeName = "<#Value 2#>"}
            // Value2:DWORD;
            // {#ix-set:AttributeName = "<#Value 3#>"}
            // Value3:DWORD;
            // {#ix-set:AttributeName = "<#Value 4#>"}
            // Value4:DWORD;
            // {#ix-set:AttributeName = "<#Value 5#>"}
            // Value5:DWORD;
            // {#ix-set:AttributeName = "<#Value 6#>"}
            // Value6:DWORD;
            // {#ix-set:AttributeName = "<#Value 7#>"}
            // Value7:DWORD;
    //     END_VAR 
    // END_CLASS    
END_NAMESPACE
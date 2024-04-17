NAMESPACE AXOpen.Components.Rexroth.Press
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoSmartFunctionKitResults_v_4_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Id#>"}
            id : STRING;
            {#ix-set:AttributeName = "<#Maximal force#>"}
            maxForce : REAL;
            {#ix-set:AttributeName = "<#Maximal position#>"}
            maxPosition : REAL;
            {#ix-set:AttributeName = "<#Valid#>"}
            valid : BOOL;
            {#ix-set:AttributeName = "<#Creation date#>"}
            createdDate : DATE_AND_TIME;
            {#ix-set:AttributeName = "<#Cycle time#>"}
            cycleTime : REAL;
            {#ix-set:AttributeName = "<#Validation time#>"}
            validationTime : INT;
            {#ix-set:AttributeName = "<#Status#>"}
            status : STRING;
            {#ix-set:AttributeName = "<#Custom Id#>"}
            customId : STRING;
            {#ix-set:AttributeName = "<#Data recording disabled#>"}
            dataRecordingDisabled : BOOL;
            {#ix-set:AttributeName = "<#Sampling interval#>"}
            samplingInterval : INT;
            {#ix-set:AttributeName = "<#_v#>"}
            _v : INT;
        END_VAR 
    END_CLASS    
END_NAMESPACE
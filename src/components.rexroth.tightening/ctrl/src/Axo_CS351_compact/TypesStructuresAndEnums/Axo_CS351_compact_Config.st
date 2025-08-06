NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_CS351_compact_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#60S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#60S;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : Axo_CS351_HWIDs;
            {#ix-set:AttributeName = "<#Torque scaling constant (depends on the type of spindle used)#>"}
            TorqueScalingConstant : REAL := REAL#100000.0;
            {#ix-set:AttributeName = "<#Angle scaling constant (depends on the type of spindle used)#>"}
            AngleScalingConstant : REAL := REAL#10000.0;
        END_VAR 
    END_CLASS    
END_NAMESPACE

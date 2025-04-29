NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_CS351_compact_Results
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Result#>"}
            Result : BYTE;
            {#ix-set:AttributeName = "<#ID code#>"}
            IDcode : ARRAY[0..63] OF BYTE;
            {#ix-set:AttributeName = "<#Cycle counter#>"}
            CnoSE : UDINT;			
            {#ix-set:AttributeName = "<#Program number#>"}
            ProgramNo : BYTE;
            {#ix-set:AttributeName = "<#Torque min#>"}
            TorqueMin : REAL;			
            {#ix-set:AttributeName = "<#Torque#>"}
            Torque : REAL;			
            {#ix-set:AttributeName = "<#Torque max#>"}
            TorqueMax : REAL;			
            {#ix-set:AttributeName = "<#Angle min#>"}
            AngleMin : REAL;			
            {#ix-set:AttributeName = "<#Angle#>"}
            Angle : REAL;			
            {#ix-set:AttributeName = "<#Angle max#>"}
            AngleMax : REAL;			                
            {#ix-set:AttributeName = "<#Error code#>"}
            ErrorCode : WORD;
            {#ix-set:AttributeName = "<#Error class#>"}
            ErrorClass : WORD;
        END_VAR 
    END_CLASS    
END_NAMESPACE
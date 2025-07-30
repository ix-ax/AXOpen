NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_CS351_compact_In
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Program number ack.#>"}
            ProgramNoAck : BYTE;
            {#ix-set:AttributeName = "<#Ready#>"}
            Ready : BOOL;
            {#ix-set:AttributeName = "<#No fault#>"}
            NoFault : BOOL;
            {#ix-set:AttributeName = "<#In Cycle#>"}
            InCycle : BOOL;
            {#ix-set:AttributeName = "<#In Cycle counter clockwise#>"}
            InCycleCcw : BOOL;
            {#ix-set:AttributeName = "<#Cycle complete#>"}
            CycleComplete : BOOL;
            {#ix-set:AttributeName = "<#OK#>"}
            OK : BOOL;
            {#ix-set:AttributeName = "<#NOK#>"}
            NOK : BOOL;
            {#ix-set:AttributeName = "<#Tool button#>"}
            ToolButton : BOOL;
            {#ix-set:AttributeName = "<#Counter clockwise select#>"}
            CcwSelect : BOOL;
            {#ix-set:AttributeName = "<#Start button ErgoSpin#>"}
            StartButton : BOOL;
            {#ix-set:AttributeName = "<#Triger Out#>"}
            TrigOut : BOOL;	
            {#ix-set:AttributeName = "<#Torque too high#>"}
            TorqueHigh : BOOL;
            {#ix-set:AttributeName = "<#Torque too low#>"}
            TorqueLow : BOOL;
            {#ix-set:AttributeName = "<#Angle too high#>"}
            AngleHigh : BOOL;
            {#ix-set:AttributeName = "<#Angle too low#>"}
            AngleLow : BOOL;
            {#ix-set:AttributeName = "<#Counter clockwise lock acknowledge#>"}
            CcwLockAck : BOOL;
            {#ix-set:AttributeName = "<#Enable acknowledge#>"}
            EnableAck : BOOL;
            {#ix-set:AttributeName = "<#Active enable acknowledge#>"}
            ActiveEnableAck : BOOL;
            {#ix-set:AttributeName = "<#Clockwise lock acknowledge#>"}
            CwLockAck : BOOL;
            {#ix-set:AttributeName = "<#Clockwise acknowledge#>"}
            CwAck : BOOL;
            {#ix-set:AttributeName = "<#Counter clockwise acknowledge#>"}
            CcwAck : BOOL;
            {#ix-set:AttributeName = "<#ErgoSpin LED Green acknowledge#>"}
            ES_LED_GreenAck : BOOL;
            {#ix-set:AttributeName = "<#ErgoSpin LED Yellow acknowledge#>"}
            ES_LED_YellowAck : BOOL;
            {#ix-set:AttributeName = "<#ErgoSpin LED Red acknowledge#>"}
            ES_LED_RedAck : BOOL;
            {#ix-set:AttributeName = "<#Result#>"}
            Result : BYTE;
            // {#ix-set:AttributeName = "<#ID code#>"}
            IDcode : ARRAY[0..15] OF BYTE;
            {#ix-set:AttributeName = "<#Date#>"}
            Date_ : UDINT;			
            {#ix-set:AttributeName = "<#Cycle counter#>"}
            CnoSE : UDINT;			
            {#ix-set:AttributeName = "<#Program number#>"}
            ProgramNo : BYTE;			
            {#ix-set:AttributeName = "<#Step#>"}
            Step : UINT;			
            {#ix-set:AttributeName = "<#Result_0#>"}
            Result_0 : BYTE;			
            {#ix-set:AttributeName = "<#QualityCode#>"}
            QualityCode : ARRAY [0..4] OF BYTE;			
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
            {#ix-set:AttributeName = "<#Total angle min#>"}
            TotalAngleMin : REAL;			
            {#ix-set:AttributeName = "<#Total angle#>"}
            TotalAngle : REAL;			
            {#ix-set:AttributeName = "<#Total angle max#>"}
            TotalAngleMax : REAL;			
            // {#ix-set:AttributeName = "<#Error code#>"}
            // ErrorCode : WORD;
            // {#ix-set:AttributeName = "<#Error class#>"}
            // ErrorClass : WORD;
        END_VAR 
    END_CLASS    
END_NAMESPACE
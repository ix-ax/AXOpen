NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsPtP_In
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#ModePos#>"}
            ModePos				:	INT		:=	INT#0;
            {#ix-set:AttributeName = "<#EnableAxis#>"}
            EnableAxis			:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#CancelTraversing#>"}
            CancelTraversing	:	BOOL	:=	TRUE;
            {#ix-set:AttributeName = "<#IntermediateStop#>"}
            IntermediateStop	:	BOOL	:=	TRUE;
            {#ix-set:AttributeName = "<#Positive#>"}
            Positive			:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#Negative#>"}
            Negative			:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#Jog1#>"}
            Jog1				:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#Jog2#>"}
            Jog2				:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#AckError#>"}
            AckError			:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#ExecuteMode#>"}
            ExecuteMode			:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#ReleaseBrake#>"}
            ReleaseBrake		:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#TravelToFixStop#>"}
            TravelToFixStop		:	BOOL	:=	FALSE;
            {#ix-set:AttributeName = "<#Position#>"}
            Position			:	DINT	:=	DINT#0;
            {#ix-set:AttributeName = "<#Velocity#>"}
            Velocity			:	DINT	:=	DINT#0;
            {#ix-set:AttributeName = "<#OverV#>"}
            OverV				:	INT		:=	INT#100;
            {#ix-set:AttributeName = "<#OverAcc#>"}
            OverAcc				:	INT		:=	INT#100;
            {#ix-set:AttributeName = "<#OverDec#>"}
            OverDec				:	INT		:=	INT#100;
            {#ix-set:AttributeName = "<#ConfigEPos#>"}
            ConfigEPos			:	DWORD	:=	DWORD#16#0000_000F;
            {#ix-set:AttributeName = "<#BaseSpeedValue#>"}
            BaseSpeedValue		:	REAL	:=	REAL#0.0;
            {#ix-set:AttributeName = "<#AdditionalTorque#>"}
            AdditionalTorque	:	REAL	:=	REAL#0.0;
            {#ix-set:AttributeName = "<#PositiveTorqueLimit#>"}
            PositiveTorqueLimit	:	REAL	:=	REAL#100.0;
            {#ix-set:AttributeName = "<#NegativeTorqueLimit#>"}
            NegativeTorqueLimit	:	REAL	:=	REAL#100.0;
        END_VAR    
    END_CLASS
END_NAMESPACE
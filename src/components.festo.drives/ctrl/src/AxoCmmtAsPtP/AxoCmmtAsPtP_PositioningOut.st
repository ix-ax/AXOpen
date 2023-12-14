NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsPtP_PositioningOut
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#AxisEnabled#>"}
            AxisEnabled         :	BOOL;
            {#ix-set:AttributeName = "<#AxisPosOk#>"}
            AxisPosOk           :	BOOL;
            {#ix-set:AttributeName = "<#AxisSpFixed#>"}
            AxisSpFixed         :	BOOL;
            {#ix-set:AttributeName = "<#AxisAckSetpoint#>"}
            AxisAckSetpoint     :	BOOL;
            {#ix-set:AttributeName = "<#ClampTorqueReached#>"}
            ClampTorqueReached  :	BOOL;
            {#ix-set:AttributeName = "<#AxisRef#>"}
            AxisRef             :	BOOL;
            {#ix-set:AttributeName = "<#AxisWarn#>"}
            AxisWarn            :	BOOL;
            {#ix-set:AttributeName = "<#AxisError#>"}
            AxisError           :	BOOL;
            {#ix-set:AttributeName = "<#Lockout#>"}
            Lockout             :	BOOL;
            {#ix-set:AttributeName = "<#ActVelocity#>"}
            ActVelocity         :	REAL;
            {#ix-set:AttributeName = "<#ActPosition#>"}
            ActPosition         :	DINT;
            {#ix-set:AttributeName = "<#ActTorque#>"}
            ActTorque           :	INT;
            {#ix-set:AttributeName = "<#ActMode#>"}
            ActMode             :	INT;
            {#ix-set:AttributeName = "<#EPosZSW1#>"}
            EPosZSW1            :	WORD;
            {#ix-set:AttributeName = "<#EPosZSW2#>"}
            EPosZSW2            :	WORD;
            {#ix-set:AttributeName = "<#ActWarn#>"}
            ActWarn             :	WORD;
            {#ix-set:AttributeName = "<#ActFault#>"}
            ActFault            :	WORD;
            {#ix-set:AttributeName = "<#Error#>"}
            Error               :	BOOL;
            {#ix-set:AttributeName = "<#Status#>"}
            Status              :	WORD;
            {#ix-set:AttributeName = "<#DiagID#>"}
            DiagID              :	WORD;
        END_VAR    
    END_CLASS
END_NAMESPACE
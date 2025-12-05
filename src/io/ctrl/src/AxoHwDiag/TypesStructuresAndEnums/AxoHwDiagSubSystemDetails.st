NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoHwDiagSubSystemDetails
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#HardwareID#>"}
            HardwareID          :	UINT;
            {#ix-set:AttributeName = "<#Subordinate state#>"}
            SubordinateState    :	AxoComponentState;
            {#ix-set:AttributeName = "<#GetDiagnosticsReturnCode#>"}
            GetDiagnosticsReturnCode : GetDiagnosticsReturnCode;
            {#ix-set:AttributeName = "<#Operating DiagnosticsEnabled#>"}
            DiagnosticsEnabled  :	BOOL;
            {#ix-set:AttributeName = "<#Subordinate IO state#>"}
            SubordinateIOState  :	AxoHwDiagIoState;	            
        END_VAR
    END_CLASS
END_NAMESPACE

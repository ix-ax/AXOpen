NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoHwDiagSystemDetails
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#HardwareID#>"}
            HardwareID          :	UINT;
            {#ix-set:AttributeName = "<#GetDiagnosticsReturnCode#>"}
            GetDiagnosticsReturnCode : GetDiagnosticsReturnCode;
            {#ix-attr:[Container(Layout.Wrap)]}
            ComponentStateDetail    :	AxoHwDiagComponentStateDetail;	
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Component state#>"}
            ComponentState          :	AxoHwDiagComponentState;	       
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Operating state#>"}
            OperatingState           :	AxoHwDiagOperatingState;	
        END_VAR
    END_CLASS
END_NAMESPACE

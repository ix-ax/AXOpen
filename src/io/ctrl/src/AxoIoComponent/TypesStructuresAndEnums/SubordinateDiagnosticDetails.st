NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS SubordinateDiagnosticDetails
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Subordinate state#>"}
            SubordinateState          :	ComponentState;
            {#ix-set:AttributeName = "<#Subordinate IO state#>"}
            SubordinateIOState                 :	IOState;	            
            {#ix-set:AttributeName = "<#Operating DiagnosticsEnabled#>"}
            DiagnosticsEnabled           :	BOOL;
        END_VAR
    END_CLASS
END_NAMESPACE

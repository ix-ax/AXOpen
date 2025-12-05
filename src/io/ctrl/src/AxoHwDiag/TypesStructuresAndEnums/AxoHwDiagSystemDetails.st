NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoHwDiagSystemDetails
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            // {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            // {#ix-set:AttributeName = "<#Component state detail#>"}
            ComponentStateDetail    :	AxoHwDiagComponentStateDetail;	
            {#ix-attr:[Container(Layout.Wrap)]}
            // {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#Component state#>"}
            ComponentState          :	AxoHwDiagComponentState;	       
            {#ix-attr:[Container(Layout.Wrap)]}
            // {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#Operating state#>"}
            OperatingState           :	AxoHwDiagOperatingState;	
            // {#ix-attr:[Container(Layout.Wrap)]}
            // {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            // {#ix-set:AttributeName = "<#IO state#>"}
            // IOState                 :	AxoHwDiagIOState;	            
        END_VAR
    END_CLASS
END_NAMESPACE

NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS DiagnosticDetails 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#Component state details#>"}
            ComponentStateDetail    :	ComponentStateDetail;	//  Represents detailed state information about the hardware component and the PLC.
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#Component state#>"}
            ComponentState          :	ComponentState;	        //  State of the component.
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#IO state#>"}
            IOState                 :	IOState;	            //  State of the inputs and outputs of the component.
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#Operating state#>"}
            OperatingState           :	OperatingState;	        //  Operating state of the PLC.        
        END_VAR
    END_CLASS
END_NAMESPACE

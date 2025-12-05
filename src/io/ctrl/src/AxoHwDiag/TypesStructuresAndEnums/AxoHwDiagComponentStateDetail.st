NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS AxoHwDiagComponentStateDetail
		VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#Hardware component state#>"}
            HardwareComponentState  :   AxoHwDiagHardwareComponentState;
            // {#ix-attr:[Container(Layout.Wrap)]}
            // {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            // {#ix-set:AttributeName = "<#PlcState#>"}
            // PlcState                :	AxoHwDiagPlcState;     
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#IO state#>"}
            IOState                 :	AxoHwDiagIOState;	         
        END_VAR
    END_CLASS
END_NAMESPACE

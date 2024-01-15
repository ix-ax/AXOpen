NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS ComponentStateDetail
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#Hardware component state#>"}
            HardwareComponentState  :   HardwareComponentState;  //	Represents detailed state information about the hardware component.
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-set:AttributeName = "<#PlcState#>"}
            PlcState                :	PlcState;                //	Represents detailed state information about the PLC.
        END_VAR
    END_CLASS
END_NAMESPACE

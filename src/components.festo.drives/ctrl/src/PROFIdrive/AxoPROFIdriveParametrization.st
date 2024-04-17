USING AXOpen.Core;
USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoPROFIdriveParametrization 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            Inputs				:	AxoPROFIdriveParametrizationIn;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs				:	AxoPROFIdriveParametrizationOut;
        END_VAR
    END_CLASS
END_NAMESPACE
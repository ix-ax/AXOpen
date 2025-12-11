NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoHwDiagDetails
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#PLC#>"}
            {#ix-attr:[ReadOnly()]}
            PLCDiagnosticDetails	                    :   AxoHwDiagCommonDetails;	  

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IOSystem#>"}
            {#ix-attr:[ReadOnly()]}
            IoSystemDiagnosticDetails	                :   AxoHwDiagCommonDetails;	  

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Station#>"}
            {#ix-attr:[ReadOnly()]}
            StationDiagnosticDetails	                :   AxoHwDiagCommonDetails;	  
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Module#>"}
            {#ix-attr:[ReadOnly()]}
            ModuleDiagnosticDetails	                    :   AxoHwDiagCommonDetails;	  
 
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Sub module#>"}
            {#ix-attr:[ReadOnly()]}
            SubModuleDiagnosticDetails	                :   AxoHwDiagCommonDetails;	  
 
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Faulty item details#>"}
            {#ix-attr:[ReadOnly()]}
            FaultyItemDetails	                        :   AxoHwDiagSystemDetails;	  
        END_VAR
    END_CLASS
END_NAMESPACE

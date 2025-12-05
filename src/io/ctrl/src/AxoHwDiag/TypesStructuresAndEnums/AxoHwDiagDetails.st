NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoHwDiagDetails
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#PLC#>"}
            {#ix-attr:[ReadOnly()]}
            PLCSubSystemDiagnosticDetails	        :   AxoHwDiagSubSystemDetails;	  

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IOSystem#>"}
            {#ix-attr:[ReadOnly()]}
            IoSystemSubSystemDiagnosticDetails	        :   AxoHwDiagSubSystemDetails;	  

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Station#>"}
            {#ix-attr:[ReadOnly()]}
            StationSubSystemDiagnosticDetails	        :   AxoHwDiagSubSystemDetails;	  
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Module#>"}
            {#ix-attr:[ReadOnly()]}
            ModuleSubSystemDiagnosticDetails	        :   AxoHwDiagSubSystemDetails;	  
 
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Sub module#>"}
            {#ix-attr:[ReadOnly()]}
            SubModuleSubSystemDiagnosticDetails	        :   AxoHwDiagSubSystemDetails;	  
 
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Details#>"}
            {#ix-attr:[ReadOnly()]}
            SystemDiagnosticDetails	                    :   AxoHwDiagSystemDetails;	  
 
        END_VAR
    END_CLASS
END_NAMESPACE

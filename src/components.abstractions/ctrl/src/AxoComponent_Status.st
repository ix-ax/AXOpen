USING AXOpen.Core;

NAMESPACE AXOpen.Components.Abstractions    
    CLASS PUBLIC AxoComponent_Status
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "ActionDescription: |[[1]ActionDescription]|"}
            {#ix-attr:[WarningLevel(600)]}
            {#ix-attr:[ErrorLevel(700)]}
            Action    :   AXOpen.Core.AxoTextList;	
            {#ix-set:AttributeName = "ErrorDescription: |[[1]ErrorDescription]|"}
            {#ix-attr:[WarningLevel(600)]}
            {#ix-attr:[ErrorLevel(700)]}
            Error     :   AXOpen.Core.AxoTextList;	
        END_VAR
    END_CLASS
END_NAMESPACE
USING AXOpen.Core;

NAMESPACE AXOpen.Components.Abstractions    
    CLASS PUBLIC AxoComponent_Status
        VAR PUBLIC
            {#ix-set:AttributeName = "ActionDescription |[[1]ActionDescription]|"}
            Action    :   AXOpen.Core.AxoTextList;	
            {#ix-set:AttributeName = "ErrorDescription |[[1]ErrorDescription]|"}
            Error     :   AXOpen.Core.AxoTextList;	
        END_VAR
    END_CLASS
END_NAMESPACE
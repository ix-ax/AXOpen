NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _rootObject :   AxoObject;
            compnentOne : Component_1;
        END_VAR
    
        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            compnentOne.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
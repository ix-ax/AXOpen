NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _rootObject:    AxoObject;
            componentOne    : Component_1;
            componentTwo    : Component_2;
        END_VAR
    
        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            componentOne.Run(_rootObject);
            // componentTwo.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
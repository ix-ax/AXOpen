NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            rootObject      : AxoObject;
            componentOne    : AXOpen.Components.Dukane.Welders.Component_1;
            componentTwo    : AXOpen.Components.Dukane.Welders.Component_2;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(rootObject);
            componentOne.Run(rootObject);
            componentTwo.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
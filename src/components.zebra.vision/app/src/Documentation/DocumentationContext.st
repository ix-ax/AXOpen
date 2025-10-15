NAMESPACE AXOpen.Components.Zebra.Vision
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            rootObject      : AxoObject;
            componentOne    : AXOpen.Components.Zebra.Vision.Component_1;
            componentTwo    : AXOpen.Components.Zebra.Vision.Component_2;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(rootObject);
            componentOne.Run(rootObject);
            componentTwo.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
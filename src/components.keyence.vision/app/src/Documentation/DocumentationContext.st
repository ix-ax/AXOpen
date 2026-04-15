NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            rootObject      : AxoObject;
            componentOne    : AXOpen.Components.Keyence.Vision.Component_1;
            componentTwo    : AXOpen.Components.Keyence.Vision.Component_2;
            componentThree  : AXOpen.Components.Keyence.Vision.Component_3;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(rootObject);
            componentOne.Run(rootObject);
            componentTwo.Run(rootObject);
            componentThree.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
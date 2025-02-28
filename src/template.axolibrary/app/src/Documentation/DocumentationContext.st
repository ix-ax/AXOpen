NAMESPACE Template.Axolibrary
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            rootObject      : AxoObject;
            componentOne    : Template.Axolibrary.Component_1;
            componentTwo    : Template.Axolibrary.Component_2;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            rootObject.InitializeWithContext(THIS);
            componentOne.Run(rootObject);
            componentTwo.Run(rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
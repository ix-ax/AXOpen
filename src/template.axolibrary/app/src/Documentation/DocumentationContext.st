NAMESPACE Template.Axolibrary
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            componentOne : Template.Axolibrary.Component_1;
            componentTwo : Template.Axolibrary.Component_2;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            componentOne.Run(THIS);
            componentTwo.Run(THIS);
        END_METHOD
    END_CLASS
END_NAMESPACE
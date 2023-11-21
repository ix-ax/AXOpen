CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        componentOne : Component_1;
    END_VAR
   
    METHOD PROTECTED OVERRIDE Main
        componentOne.Run(THIS);
    END_METHOD
END_CLASS

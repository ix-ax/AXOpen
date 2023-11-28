{S7.extern=ReadWrite}
CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        compnentOne : Component_1;
    END_VAR
   
    METHOD PROTECTED OVERRIDE Main
        compnentOne.Run(THIS);
    END_METHOD
END_CLASS

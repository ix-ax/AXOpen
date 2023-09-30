CLASS DocumentationContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        cylinder : Component;
    END_VAR
   
    METHOD PROTECTED OVERRIDE Main
        cylinder.Run(THIS);
    END_METHOD
END_CLASS

NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            componentOne : Component_1;
            componentTwo : Component_2;
        END_VAR
    
        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            componentOne.Run(_rootObject);
            componentTwo.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
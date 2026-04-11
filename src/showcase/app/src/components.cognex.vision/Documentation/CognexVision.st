USING AXOpen.Components.Cognex.Vision;

NAMESPACE AXOpen.Components.Cognex.Vision

    {S7.extern=ReadWrite}
    CLASS DocumentationContext EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject :   AxoObject;
            componentOne : Component_1;
            componentTwo : Component_2;
            componentThree : Component_3;
            componentFour : Component_4;
            componentFive : Component_5;
        END_VAR
    
        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            componentOne.Run(_rootObject);
            componentTwo.Run(_rootObject);
            componentThree.Run(_rootObject);
            componentFour.Run(_rootObject);
            componentFive.Run(_rootObject);
        END_METHOD
    END_CLASS
END_NAMESPACE
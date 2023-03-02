using ix.framework.core;

NAMESPACE core
    CLASS ComponentExamples EXTENDS ix.framework.core.IxContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Component example name"}
            MyComponent : ComponentExample;  
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  

            inHwReal : REAL := REAL#1.0001;
            inHwDint : DINT := DINT#1;
            outHwReal : REAL;
            outHwDint : DINT;

            {#ix-set:AttributeName = "Very simple component example with header only defined"}
            MyComponentWithHeaderOnly : ComponentHeaderOnlyExample;  
        END_VAR
//<MainExample>
        METHOD PROTECTED OVERRIDE Main   
            MyComponent.Initialize(THIS);
            MyComponent.Run(inReal :=  REAL#1.0001,
                            inDint :=  DINT#1);
            IF ActivateManualControl THEN
                MyComponent.ActivateManualControl();
            END_IF;
            
            // The `Initialize()` method must be called before any other method.
            MyComponentWithHeaderOnly.Initialize(THIS);
            // Example of the activation of the manual control. 
            IF ActivateManualControl THEN
                MyComponentWithHeaderOnly.ActivateManualControl();
            END_IF;
            // Calling the main method `Run` with respective input and output variables. 
            MyComponentWithHeaderOnly.Run(  inReal := inHwReal,
                                            inDint := inHwDint,
                                            outReal => outHwReal,
                                            outDint => outHwDint);
        END_METHOD
//</MainExample>
    END_CLASS
END_NAMESPACE
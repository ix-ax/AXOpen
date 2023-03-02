using ix.framework.core;

NAMESPACE core
    CLASS ComponentExamples EXTENDS ix.framework.core.IxContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Component example name"}
            MyComponent : ComponentExample;  
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  
        END_VAR
//<MainExample>
        METHOD PROTECTED OVERRIDE Main   
            MyComponent.Initialize(THIS);
            MyComponent.Run(inReal := REAL#1.0001,inDint := DINT#1);
            IF ActivateManualControl THEN
                MyComponent.ActivateManualControl();
            END_IF;
        END_METHOD
//</MainExample>
    END_CLASS
END_NAMESPACE
using ix.framework.core;

NAMESPACE core
    CLASS ComponentExamples EXTENDS ix.framework.core.IxContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Component example name"}
            MyComponent : ComponentExample;  
            {#ix-set:AttributeName = "<#Service mode#>"}
            ServiceMode : BOOL;  
        END_VAR
//<MainExample>
        METHOD PROTECTED OVERRIDE Main   
            MyComponent.Initialize(THIS);
            MyComponent.Execute();
            IF ServiceMode THEN
                MyComponent.Service();
            END_IF;
        END_METHOD
//</MainExample>
    END_CLASS
END_NAMESPACE
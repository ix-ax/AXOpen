USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleComponent : ComponentWithDiagnostics;      
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC                
        _hwID : WORD;
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        //<Initialization>        
        ExampleComponent.Run(THIS,_hwID);  
        //</Initialization>

    END_METHOD
END_CLASS

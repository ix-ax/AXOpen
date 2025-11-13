USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_3 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleComponent : AXOpen.Io.AxoRecordAccessTool;      
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
    END_VAR
    //</InitializationArgumentsDeclaration>    

    METHOD PUBLIC OVERRIDE Run
        VAR_INPUT
            inParent : IAxoObject;
        END_VAR     
    
        SUPER.Run(inParent);

        IF ActivateManualControl THEN
            ExampleComponent.ActivateManualControl();
        END_IF;
        
        //<Initialization>        
        ExampleComponent.Run(THIS);        
        //</Initialization>

    END_METHOD
END_CLASS

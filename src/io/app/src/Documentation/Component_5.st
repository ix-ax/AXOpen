USING AXOpen.Core;
USING AXOpen.Io;

{S7.extern=ReadWrite}
CLASS Component_5 EXTENDS AXOpen.Core.AxoObject
  
    //<ComponentDeclaration>
    VAR PUBLIC   
        ExampleComponent : AXOpen.Io.AxoHwDiag;      
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
    END_VAR
    //</InitializationArgumentsDeclaration>    

    METHOD PUBLIC OVERRIDE Run
        VAR_EXTERNAL
            HwIDs : HwIDs;
        END_VAR  
        VAR_INPUT
            inParent : IAxoObject;
        END_VAR     
    
        SUPER.Run(inParent);

        IF ActivateManualControl THEN
            ExampleComponent.ActivateManualControl();
        END_IF;
        
        //<Initialization>        
        ExampleComponent.Run(inParent   :=  THIS, 
                            hwIDsList   :=  HwIDs);

        //</Initialization>
    END_METHOD
END_CLASS

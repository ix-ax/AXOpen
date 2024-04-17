USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleReader : AXOpen.Components.Balluff.Identification.Axo_BIS_M_4XX_045;             
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            ExampleReader.ActivateManualControl();
        END_IF;

        //<Initialization>        
        ExampleReader.Run(parent := THIS,
                            hwID            := HwIdentifiers#BNIPNT507005Z040,
                            hwId_BISM       := HwIdentifiers#BNIPNT507005Z040_BIS_M_4XX_045_1);
        //</Initialization>

       THIS.UseInSequencer();
    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
    END_VAR

    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
        Sequencer.Open();

        IF(Steps[0].Execute(Sequencer, 'Read')) THEN
            IF(ExampleReader.Read().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Write')) THEN
            IF(ExampleReader.Write().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       
    END_METHOD
    
    //</Usage>
END_CLASS

USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleComponent : AXOpen.Io.AxoIoComponent;      
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
        ExampleComponent.Run(THIS, _hwID);        
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

        IF(Steps[0].Execute(Sequencer, 'Update diagnostic task')) THEN
            IF(ExampleComponent.UpdateHardwareDiagnosticsTask.Invoke().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;
      
    END_METHOD
    
    //</Usage>
END_CLASS

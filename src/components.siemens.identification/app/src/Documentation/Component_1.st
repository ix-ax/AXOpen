USING AXOpen.Core;
USING  AXOpen.Components.Siemens.Identification;

{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                

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
            ;
        END_IF;

        //<Initialization>        

        
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

        // IF(Steps[0].Execute(Sequencer, 'Move to home position')) THEN
        //     IF(ExampleCylinder.MoveToHome.Invoke().IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;

        // IF(Steps[1].Execute(Sequencer, 'Move to work position')) THEN
        //     IF(ExampleCylinder.MoveToWork.Invoke().IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;       
    END_METHOD
    
    //</Usage>
END_CLASS

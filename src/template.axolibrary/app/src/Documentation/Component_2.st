USING AXOpen.Core;
USING Template.Axolibrary;

{S7.extern=ReadWrite}
CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleCylinder : TemplateComponent;      
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC         
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
        _homeSensor : BOOL;
        _workSensor : BOOL;    
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            ExampleCylinder.ActivateManualControl();
        END_IF;

        //<Initialization>        
        ExampleCylinder.Run(THIS, 
                            WORD#64,
                            REF(_homeSensor), 
                            REF(_workSensor), 
                            REF(_moveHomeSignal), 
                            REF(_moveWorkSignal));
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

        IF(Steps[0].Execute(Sequencer, 'Move to home position')) THEN
            IF(ExampleCylinder.MoveToHome().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Move to work position')) THEN
            IF(ExampleCylinder.MoveToWork().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       
    END_METHOD
    
    //</Usage>
END_CLASS

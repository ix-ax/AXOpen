USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleRobot : AXOpen.Components.Mitsubishi.Robotics.AxoCr800_v_1_x_x;  
    END_VAR
    //</ComponentDeclaration>                          

    //<InitializationArgumentsDeclaration>
    VAR PUBLIC                
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;     

        manualControl   :   BOOL;  
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF(manualControl) THEN            
            ExampleRobot.ActivateManualControl();
        END_IF;

        //<Initialization>        
        ExampleRobot.Run(THIS);        
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
        //     IF(ExampleRobot.MoveToHome.Invoke().IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;

        // IF(Steps[1].Execute(Sequencer, 'Move to work position')) THEN
        //     IF(ExampleRobot.MoveToWork.Invoke().IsDone()) THEN                
        //         Sequencer.MoveNext();                
        //     END_IF;    
        // END_IF;       
    END_METHOD
    
    //</Usage>
END_CLASS

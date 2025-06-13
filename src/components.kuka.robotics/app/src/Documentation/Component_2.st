USING AXOpen.Core;

NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            ExampleRobot : AXOpen.Components.Kuka.Robotics.AxoKrc4_v_5_x_x;      
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC     
            movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;         
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    

            SUPER.Run(parent);

            IF ActivateManualControl THEN
                ExampleRobot.ActivateManualControl();
            END_IF;

            //<Initialization>        
            ExampleRobot.Run(THIS,HwIdentifiers#KRC4_HwID);
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Start at main')) THEN
                IF(ExampleRobot.StartAtMain().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Move to position')) THEN
                IF(ExampleRobot.StartMovements(movementParams).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[1].Execute(Sequencer, 'Stop')) THEN
                IF(ExampleRobot.StopMovements().IsDone()) THEN                
                    Sequencer.CompleteSequence();                
                END_IF;    
            END_IF;       
        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE
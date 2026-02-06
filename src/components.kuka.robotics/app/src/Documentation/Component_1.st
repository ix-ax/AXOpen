USING AXOpen.Core;

NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            ExampleRobot : AXOpen.Components.Kuka.Robotics.v_5_x_x.AxoKrc4;      
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
                inParent : IAxoObject;
            END_VAR    

            SUPER.Run(inParent);

            IF ActivateManualControl THEN
                ExampleRobot.ActivateManualControl();
            END_IF;

            ExampleRobot.Config.ErrorTime := T#0s;
            //<Initialization>        
            ExampleRobot.Run(THIS,HwIdentifiers#kuka_rb1_HwID);
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..14] OF AXOpen.Core.AxoStep;
        END_VAR


        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                ActivateManualControl := FALSE;
                ExampleRobot.Config.TaskTimeout   := LTIME#0S;
                ExampleRobot.Config.ErrorTime     := LTIME#0S;
                ExampleRobot.Restore();    
                Sequencer.MoveNext();                
            END_IF;
 
            IF(Steps[1].Execute(Sequencer, 'Start at main')) THEN
                IF(ExampleRobot.StartAtMain().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Start motors and program')) THEN
                IF(ExampleRobot.StartMotorsAndProgram().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[3].Execute(Sequencer, 'Move to position 100')) THEN
                movementParams.ActionNo         :=  BYTE#100;  
                movementParams.GlobalSpeed      :=  BYTE#5; 
                movementParams.ToolNo           :=  BYTE#10;  
                movementParams.WorkobjectNo     :=  BYTE#15; 
                movementParams.PointNo          :=  BYTE#20;  
                movementParams.UserSpecSpeed1   :=  INT#25;  
                movementParams.UserSpecSpeed2   :=  INT#30;  
                movementParams.Coordinates.X    :=  REAL#-1.2;
                movementParams.Coordinates.Y    :=  REAL#2.3;
                movementParams.Coordinates.Z    :=  REAL#3.4;
                movementParams.Coordinates.Rx   :=  REAL#4.5;
                movementParams.Coordinates.Ry   :=  REAL#5.6;
                movementParams.Coordinates.Rz   :=  REAL#6.7;

                IF(ExampleRobot.StartMovements(movementParams).IsDone()) THEN                
                    ExampleRobot.StartMovementsTask.Restore();           
                    Sequencer.MoveNext();     
                END_IF;    
            END_IF;       

            IF(Steps[4].Execute(Sequencer, 'Move to position 1')) THEN
                movementParams.ActionNo             :=  BYTE#1;  

                IF(ExampleRobot.StartMovements(movementParams).IsDone()) THEN                
                    ExampleRobot.StartMovementsTask.Restore();           
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[5].Execute(Sequencer, 'Move to position 3')) THEN
                movementParams.ActionNo             :=  BYTE#3;  

                IF(ExampleRobot.StartMovements(movementParams).IsBusy() AND Sequencer.CurrentStep.Duration >= T#500ms) THEN   
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       
            // Simulation of the entering the robotic cell during movement =>
            IF(Steps[6].Execute(Sequencer, 'Stop during movement')) THEN
                ExampleRobot.StartMovements(movementParams); // <- This line just emulates the cyclical call of the movement method 
                IF(ExampleRobot.StopMovements().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[7].Execute(Sequencer, '<#Unlocking and opening the robotic cell#>')) THEN
                //-------------------------------------------------------    
                ExampleRobot.StartMovements(movementParams); // <- This line just emulates the cyclical call of the movement method 
                IF (TRUE) THEN                
                    Sequencer.MoveNext();                
                END_IF;  
                //-------------------------------------------------------
            END_IF;

            IF (Steps[8].Execute(Sequencer, '<#Closing and locking the robotic cell#>')) THEN
                //-------------------------------------------------------    
                ExampleRobot.StartMovements(movementParams); // <- This line just emulates the cyclical call of the movement method 
                IF (TRUE) THEN                
                    Sequencer.MoveNext();                
                END_IF;  
                //-------------------------------------------------------
            END_IF;
            // <= Simulation of the entering the robotic cell during movement

            IF(Steps[9].Execute(Sequencer, 'Start motors and program')) THEN
                ExampleRobot.StartMovements(movementParams); // <- This line just emulates the cyclical call of the movement method 
                IF(ExampleRobot.StartMotorsAndProgram().IsDone()) THEN // <- Starting motor and program after safety circuit has been interupted
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[10].Execute(Sequencer, 'Continue to position 3')) THEN
                IF(ExampleRobot.StartMovementsTask.IsDone()) THEN                
                    ExampleRobot.StartMovementsTask.Restore();           
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[11].Execute(Sequencer, 'Move to position 100')) THEN
                movementParams.ActionNo             :=  BYTE#100;  

                IF(ExampleRobot.StartMovements(movementParams).IsDone()) THEN                
                    ExampleRobot.StartMovementsTask.Restore();           
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[12].Execute(Sequencer, 'Move to position 1')) THEN
                movementParams.ActionNo             :=  BYTE#1;  

                IF(ExampleRobot.StartMovements(movementParams).IsDone()) THEN                
                    ExampleRobot.StartMovementsTask.Restore();           
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[13].Execute(Sequencer, 'Stop movement and program')) THEN
                IF(ExampleRobot.StopMovementsAndProgram().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       
            IF(Steps[14].Execute(Sequencer, 'Restore')) THEN
                ExampleRobot.Restore();              
                Sequencer.CompleteSequence();                
            END_IF;   
        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE
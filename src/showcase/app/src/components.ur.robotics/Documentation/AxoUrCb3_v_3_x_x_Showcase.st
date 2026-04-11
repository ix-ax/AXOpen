USING AXOpen.Core;

NAMESPACE AXOpen.Components.Ur.Robotics

    {S7.extern=ReadWrite}
    CLASS AxoUrCb3_v_3_x_x_Showcase EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC               
            {#ix-set:AttributeName = "<#UR series CB3 example#>"}
            ExampleRobot : AXOpen.Components.Ur.Robotics.AxoUrCb3_v_3_x_x;
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC              
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;         
            {#ix-set:AttributeName = "<#Power on impulse#>"}
            PowerOnImpulse : BOOL;         
            movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
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

            //<Initialization>        
            ExampleRobot.Run(   inParent                                                := THIS,
                                hwID := AXOpen.Showcase.HwIdentifiers#ureol2l_HwID,
                                refPowerOnPulse                                         := REF (PowerOnImpulse));
            ExampleRobot.Config.IpAddress := '192.168.100.61';
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..10] OF AXOpen.Core.AxoStep;
    END_VAR

    METHOD PRIVATE UseInSequencer   
        Sequencer.Run(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
        // Sequencer.SteppingMode := eAxoSteppingMode#Continous;

        IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
            ActivateManualControl := FALSE;
            ExampleRobot.Restore();              
            Sequencer.MoveNext();                
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Stop movements and program')) THEN
            IF(ExampleRobot.StopMovementsAndProgram().IsDone()) THEN                
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
            movementParams.Coordinates.X    :=  REAL#1.2;
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
            movementParams.ActionNo         :=  BYTE#1;  

            IF(ExampleRobot.StartMovements(movementParams).IsDone()) THEN                
                ExampleRobot.StartMovementsTask.Restore();           
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[5].Execute(Sequencer, 'Move to position 100')) THEN
            movementParams.ActionNo         :=  BYTE#100;  

            IF(ExampleRobot.StartMovements(movementParams).IsBusy() AND Sequencer.CurrentStep.Duration >= T#500ms) THEN   
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[6].Execute(Sequencer, 'Stop during movement')) THEN
            IF(ExampleRobot.StopMovements().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[7].Execute(Sequencer, 'Start motors and program')) THEN
            IF(ExampleRobot.StartMotorsAndProgram().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[8].Execute(Sequencer, 'Continue to position 100')) THEN
            IF(ExampleRobot.StartMovementsTask.IsDone()) THEN                
                ExampleRobot.StartMovementsTask.Restore();           
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[9].Execute(Sequencer, 'Stop movement and program')) THEN
            IF(ExampleRobot.StopMovementsAndProgram().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;   

        IF(Steps[10].Execute(Sequencer, 'Restore')) THEN
            ExampleRobot.Restore();              
            Sequencer.CompleteSequence();                
        END_IF;       
    END_METHOD

    //</Usage>
    END_CLASS
END_NAMESPACE
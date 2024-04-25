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
        movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
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
        ExampleRobot.Run(   parent      := THIS,
                        hwID                := HwIdentifiers#TZ535_PN_HwID,
                        hwIdInOut_64_byte   := HwIdentifiers#TZ535_PN_In_Out_64_byte_1_In_Out__64_byte_HwID);     
    // hwID                := HwIdentifiers#TZ535_PN,
    // hwIdInOut_64_byte   := HwIdentifiers#TZ535_PN_In_Out_64_byte_1);     
        //</Initialization>

       THIS.UseInSequencer();
    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..5] OF AXOpen.Core.AxoStep;
    END_VAR

    METHOD PRIVATE UseInSequencer   
        Sequencer.Initialize(THIS);
        Sequencer.Open();
        Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
        Sequencer.SteppingMode := eAxoSteppingMode#StepByStep;

        IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
            manualControl := FALSE;
            ExampleRobot.Restore();              
            Sequencer.MoveNext();                
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Start motors and program')) THEN
            manualControl := FALSE;
            IF(ExampleRobot.StartMotorsAndProgram().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[2].Execute(Sequencer, 'Move to position')) THEN
            movementParams.ActionNo         :=  BYTE#1;  
            movementParams.GlobalSpeed      :=  BYTE#20; 
            movementParams.ToolNo           :=  BYTE#1;  
            movementParams.WorkobjectNo     :=  BYTE#1; 
            movementParams.PointNo          :=  BYTE#1;  
            movementParams.UserSpecSpeed1   :=  INT#10;  
            movementParams.UserSpecSpeed2   :=  INT#20;  
            movementParams.Coordinates.X    :=  REAL#1.1456;
            movementParams.Coordinates.Y    :=  REAL#1.1456;
            movementParams.Coordinates.Z    :=  REAL#1.1456;
            movementParams.Coordinates.Rx   :=  REAL#1.1456;
            movementParams.Coordinates.Ry   :=  REAL#1.1456;
            movementParams.Coordinates.Rz   :=  REAL#1.1456;

            IF(ExampleRobot.StartMovements(movementParams).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[3].Execute(Sequencer, 'Stop')) THEN
            IF(ExampleRobot.StopMovements().IsDone()) THEN                
                Sequencer.CompleteSequence();                
            END_IF;    
        END_IF;       
    END_METHOD
    
    //</Usage>
END_CLASS

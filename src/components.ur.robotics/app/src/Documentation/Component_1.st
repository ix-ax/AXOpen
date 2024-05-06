USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
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

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            ExampleRobot.ActivateManualControl();
        END_IF;

        //<Initialization>        
        ExampleRobot.Run(   parent                                                  := THIS,
                            hwID                                                    := HwIdentifiers#ureol2l_HwID,
                            hwIdAxoUrRobotics_T2O_State                             := HwIdentifiers#ureol2l_1_T2O_State_1_T2O_State_HwID,
                            hwIdAxoUrRobotics_T2O_IO                                := HwIdentifiers#ureol2l_2_T2O_IO_2_T2O_IO_HwID,
                            hwIdAxoUrRobotics_T2O_Joints                            := HwIdentifiers#ureol2l_3_T2O_Joints_3_T2O_Joints_HwID,
                            hwIdAxoUrRobotics_T2O_TCP                               := HwIdentifiers#ureol2l_4_T2O_TCP_4_T2O_TCP_HwID,
                            hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers     := HwIdentifiers#ureol2l_5_T2O_General_Purpose_Bit_Registers_5_T2O_General_Purpose_Bit_Registers_HwID,
                            hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers     := HwIdentifiers#ureol2l_6_T2O_General_Purpose_Int_Registers_6_T2O_General_Purpose_Int_Registers_HwID,
                            hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers   := HwIdentifiers#ureol2l_7_T2O_General_Purpose_Float_Registers_7_T2O_General_Purpose_Float_Registers_HwID,
                            hwIdAxoUrRobotics_O2T_Robot_IO                          := HwIdentifiers#ureol2l_8_O2T_Robot_IO_8_O2T_Robot_IO_HwID,
                            hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1       := HwIdentifiers#ureol2l_9_O2T_General_Purpose_Registers_1_9_O2T_General_Purpose_Registers_1_HwID,
                            hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2       := HwIdentifiers#ureol2l_10_O2T_General_Purpose_Registers_2_10_O2T_General_Purpose_Registers_2_HwID,
                            refPowerOnPulse                                         := REF (PowerOnImpulse));
        ExampleRobot.Config.IpAddress := '10.10.10.61';
        //</Initialization>

       THIS.UseInSequencer();
    END_METHOD

   //<Usage>    
   VAR PUBLIC                       
    Sequencer : AxoSequencer;       
    Steps : ARRAY[0..10] OF AXOpen.Core.AxoStep;
END_VAR

METHOD PRIVATE UseInSequencer   
    Sequencer.Initialize(THIS);
    Sequencer.Open();
    Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
    // Sequencer.SteppingMode := eAxoSteppingMode#Continous;

    IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
        ActivateManualControl := FALSE;
        ExampleRobot.Restore();              
        Sequencer.MoveNext();                
    END_IF;

    IF(Steps[1].Execute(Sequencer, 'Start motors and program')) THEN
        IF(ExampleRobot.StartMotorsAndProgram().IsDone()) THEN                
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

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

    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Setup date and time#>"}
        SetupDateTime : LDATE_AND_TIME;
        {#ix-set:AttributeName = "<#Click to set the date and time#>"}
        SetUTC : AxoTask;
    END_VAR
    VAR PRIVATE
        retval : WORD;
        _rtc : AXOpen.S71500.Rtc;

    END_VAR
    
    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    

        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            ExampleRobot.ActivateManualControl();
        END_IF;

        SetUTC.Initialize(THIS);

        IF(SetUTC.Execute()) THEN
            retval := _rtc.SetUTC(SetupDateTime);
            SetUTC.ThrowWhen(retval>WORD#0);
            SetUTC.DoneWhen(retval=WORD#0);
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
        Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
    END_VAR

    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
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

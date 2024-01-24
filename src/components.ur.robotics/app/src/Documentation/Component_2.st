USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
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

        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;              
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
                            hwID                                                    := TO_UINT(HwIdentifiers#URIODev1),
                            refAxoUrRobotics_T2O_State                              := REF(PlcInputs^.URIODev1_1_T2O_State_1),
                            refAxoUrRobotics_T2O_IO                                 := REF(PlcInputs^.URIODev1_2_T2O_IO_1),
                            refAxoUrRobotics_T2O_Joints                             := REF(PlcInputs^.URIODev1_3_T2O_Joints_1),
                            refAxoUrRobotics_T2O_TCP                                := REF(PlcInputs^.URIODev1_4_T2O_TCP_1),
                            refAxoUrRobotics_T2O_General_Purpose_Bit_Registers      := REF(PlcInputs^.URIODev1_5_T2O_General_Purpose_Bit_Registers_1),
                            refAxoUrRobotics_T2O_General_Purpose_Int_Registers      := REF(PlcInputs^.URIODev1_6_T2O_General_Purpose_Int_Registers_1),
                            refAxoUrRobotics_T2O_General_Purpose_Float_Registers    := REF(PlcInputs^.URIODev1_7_T2O_General_Purpose_Float_Registers_1),
                            refAxoUrRobotics_O2T_Robot_IO                           := REF(PlcOutputs^.URIODev1_8_O2T_Robot_IO_1),
                            refAxoUrRobotics_O2T_General_Purpose_Registers_1        := REF(PlcOutputs^.URIODev1_9_O2T_General_Purpose_Registers_1_1),
                            refAxoUrRobotics_O2T_General_Purpose_Registers_2        := REF(PlcOutputs^.URIODev1_10_O2T_General_Purpose_Registers_2_1),
                            refPowerOnPulse                                         := REF (PowerOnImpulse));
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

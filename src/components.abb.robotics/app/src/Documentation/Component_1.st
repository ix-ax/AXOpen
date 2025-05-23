USING AXOpen.Core;
NAMESPACE AXOpen.Components.Abb.Robotics
    {S7.extern=ReadWrite}
    CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            AxoIrc5_v_1_x_x : AXOpen.Components.Abb.Robotics.AxoIrc5_v_1_x_x;  
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC                
            movementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
            manualControl   :   BOOL;  
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    
            SUPER.Run(parent);

            IF(manualControl) THEN            
                AxoIrc5_v_1_x_x.ActivateManualControl();
            END_IF;

            //<Initialization>        
            AxoIrc5_v_1_x_x.Run(parent          := parent,
                                hwID            := HwIdentifiers#RobotBasicIO_HwID);        
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
                IF(AxoIrc5_v_1_x_x.StartAtMain().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Move to position')) THEN
                IF(AxoIrc5_v_1_x_x.StartMovements(movementParams).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[2].Execute(Sequencer, 'Stop')) THEN
                IF(AxoIrc5_v_1_x_x.StopMovements().IsDone()) THEN                
                    Sequencer.CompleteSequence();                
                END_IF;    
            END_IF;       
        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE
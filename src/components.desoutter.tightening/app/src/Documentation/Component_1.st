USING AXOpen.Core;
{S7.extern=ReadWrite}
CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
    //<ComponentDeclaration>
    VAR PUBLIC                
        ExampleScrewdriver : AXOpen.Components.Desoutter.Tightening.AxoCVIC_II;             
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
            ExampleScrewdriver.ActivateManualControl();
        END_IF;
          
        //<Initialization>        
        ExampleScrewdriver.Run( parent                  :=  THIS,
                                refStatus               := REF(PlcInputs^.wp462_t1_rh_deso_Input_1_byte_1),
                                refActScrewingProgram   := REF(PlcInputs^.wp462_t1_rh_deso_Input_1_byte_2),
                                refTorque               := REF(PlcInputs^.wp462_t1_rh_deso_Input_2_word_1),
                                refTorqueTrend          := REF(PlcInputs^.wp462_t1_rh_deso_Input_1_word_1),
                                refAngle                := REF(PlcInputs^.wp462_t1_rh_deso_Input_2_word_2),
                                refAngleTrend           := REF(PlcInputs^.wp462_t1_rh_deso_Input_1_word_2),
                                refControl              := REF(PlcOutputs^.wp462_t1_rh_deso_Output_1_byte_1),
                                refReqScrewingProgram   := REF(PlcOutputs^.wp462_t1_rh_deso_Output_1_byte_2));        
        //</Initialization>

       THIS.UseInSequencer();
    END_METHOD

    //<Usage>    
    VAR PUBLIC                       
        Sequencer : AxoSequencer;       
        Steps : ARRAY[0..4] OF AXOpen.Core.AxoStep;
    END_VAR

    METHOD PRIVATE UseInSequencer   

        Sequencer.Initialize(THIS);
        Sequencer.Open();

        IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
            ExampleScrewdriver.Restore();
            Sequencer.MoveNext();                
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Reset')) THEN
            IF(ExampleScrewdriver.Reset().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;
    
        IF(Steps[2].Execute(Sequencer, 'Set screwing program')) THEN
            IF(ExampleScrewdriver.SetScrewingProgram(1).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[3].Execute(Sequencer, 'Start screwing')) THEN
            IF(ExampleScrewdriver.StartScrewing(1).IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;
            
        IF(Steps[4].Execute(Sequencer, 'Evaluate results')) THEN
            Sequencer.CompleteSequence();  
        END_IF;
    END_METHOD

    //</Usage>
END_CLASS
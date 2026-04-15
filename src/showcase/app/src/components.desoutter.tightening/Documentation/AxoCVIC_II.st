USING AXOpen.Core;

NAMESPACE AXOpen.Components.Desoutter.Tightening
    {S7.extern=ReadWrite}
    CLASS AxoCVIC_II_Example EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            ExampleScrewdriver : AXOpen.Components.Desoutter.Tightening.AxoCVIC_II;             
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC                

            manualControl   :   BOOL;
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR    

            SUPER.Run(inParent);

            IF(manualControl) THEN            
                ExampleScrewdriver.ActivateManualControl();
            END_IF;
            
            //<Initialization>        
            ExampleScrewdriver.Run( inParent                  :=  THIS,
                                    hwID                   := AXOpen.Showcase.HwIdentifiers#desoutter_cvic_ii_HwID);       
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..4] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                ExampleScrewdriver.Config.InfoTime              := LTIME#2S;
                ExampleScrewdriver.Config.ErrorTime             := LTIME#5S;
                ExampleScrewdriver.Config.TaskTimeout           := LTIME#50S;
                ExampleScrewdriver.Config.ScrewingCycleTimeout  := TIME#60S;
                ExampleScrewdriver.Config.ProgramChangeTimeout  := TIME#2S;
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
END_NAMESPACE
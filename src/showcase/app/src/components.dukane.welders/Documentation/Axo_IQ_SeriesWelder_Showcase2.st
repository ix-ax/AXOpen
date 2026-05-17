USING AXOpen.Core;
NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    CLASS Axo_IQ_SeriesWelder_Showcase2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            Dukane_IQ_SeriesWelder : AXOpen.Components.Dukane.Welders.Axo_IQ_SeriesWelder;             
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC              
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
                Dukane_IQ_SeriesWelder.ActivateManualControl();
            END_IF;

            //<Initialization>        
            Dukane_IQ_SeriesWelder.Run(inParent  :=   THIS,hwID    :=   UINT#60);
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..30] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer   
            IF Sequencer.GetContext().OpenCycleCount() = ULINT#0 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            // IF(Steps[0].Execute(Sequencer, 'TemplateMethod_10steps_1')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_10steps_1().IsDone()) THEN                
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;

            // IF(Steps[1].Execute(Sequencer, 'TemplateMethod_10steps_2')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_10steps_2().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[2].Execute(Sequencer, 'TemplateMethod_10steps_3')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_10steps_3().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[3].Execute(Sequencer, 'TemplateMethod_10steps_4')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_10steps_4().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[4].Execute(Sequencer, 'TemplateMethod_10steps_5')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_10steps_5().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[5].Execute(Sequencer, 'TemplateMethod_10steps_6')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_10steps_6().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[6].Execute(Sequencer, 'TemplateMethod_20steps_1')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_1().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[7].Execute(Sequencer, 'TemplateMethod_20steps_2')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_2().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[8].Execute(Sequencer, 'TemplateMethod_20steps_3')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_3().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[9].Execute(Sequencer, 'TemplateMethod_20steps_4')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_4().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[10].Execute(Sequencer, 'TemplateMethod_20steps_5')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_5().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[11].Execute(Sequencer, 'TemplateMethod_20steps_6')) THEN
            //     IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_6().IsDone()) THEN     
            //         Sequencer.MoveNext();                
            //     END_IF;    
            // END_IF;       

            // IF(Steps[12].Execute(Sequencer, 'Restore')) THEN
            //     Dukane_IQ_SeriesWelder.Restore();
            //     Sequencer.CompleteSequence();    
            // END_IF;       

        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE
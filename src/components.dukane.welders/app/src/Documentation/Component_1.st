USING AXOpen.Core;
NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
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
                parent : IAxoObject;
            END_VAR    

            SUPER.Run(parent);

            IF ActivateManualControl THEN
                Dukane_IQ_SeriesWelder.ActivateManualControl();
            END_IF;

            //<Initialization>        
            Dukane_IQ_SeriesWelder.Run(parent := THIS, hwID := HwIdentifiers#DukaneIqSeriesWelder_1_HwID);
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            {#ix-set:AttributeName = "<#Run test sequence#>"}
            Sequencer   :   AxoSequencer;       
            Steps       :   ARRAY[0..12] OF AXOpen.Core.AxoStep;
            Good_Part   :   BOOL;
            Bad_Part    :   BOOL;
            WeldTime    :   DINT;
            WeldEnergy  :   DINT;
            WeldPower   :   DINT;
        END_VAR

        METHOD PRIVATE UseInSequencer   
            IF Sequencer.GetContext().OpenCycleCount() = ULINT#0 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                ActivateManualControl := FALSE;
                Dukane_IQ_SeriesWelder.Restore();            
                Sequencer.MoveNext();                
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'ClearError')) THEN
                IF(Dukane_IQ_SeriesWelder.ClearError().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'RunWeldingWithTime: Setup number: 2, Probe number: 1, Time: 2s')) THEN
                IF(Dukane_IQ_SeriesWelder.RunWeldingWithTime(SetupNumber := UINT#2, ProbeNumber := UINT#1, WeldingTime := T#2S).IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'Evaluation OK/NOK')) THEN
                Good_Part   := Dukane_IQ_SeriesWelder.Inputs.SystemStatus.Good_Part;
                Bad_Part    := Dukane_IQ_SeriesWelder.Inputs.SystemStatus.Bad_Part;
                Sequencer.MoveNext();                
            END_IF;       

            IF(Steps[4].Execute(Sequencer, 'Some results to store')) THEN
                WeldTime    :=  Dukane_IQ_SeriesWelder.Inputs.CycleWeldTime;
                WeldEnergy  :=  Dukane_IQ_SeriesWelder.Inputs.CycleWeldEnergy;
                WeldPower   :=  Dukane_IQ_SeriesWelder.Inputs.CycleWeldPeakPower;
                Sequencer.MoveNext();                
            END_IF;       

            IF(Steps[5].Execute(Sequencer, 'TemplateMethod_10steps_6')) THEN
                IF(Dukane_IQ_SeriesWelder.TemplateMethod_10steps_6().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[6].Execute(Sequencer, 'TemplateMethod_20steps_1')) THEN
                IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_1().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[7].Execute(Sequencer, 'TemplateMethod_20steps_2')) THEN
                IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_2().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[8].Execute(Sequencer, 'TemplateMethod_20steps_3')) THEN
                IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_3().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[9].Execute(Sequencer, 'TemplateMethod_20steps_4')) THEN
                IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_4().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[10].Execute(Sequencer, 'TemplateMethod_20steps_5')) THEN
                IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_5().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[11].Execute(Sequencer, 'TemplateMethod_20steps_6')) THEN
                IF(Dukane_IQ_SeriesWelder.TemplateMethod_20steps_6().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[12].Execute(Sequencer, 'Restore')) THEN
                Dukane_IQ_SeriesWelder.Restore();
                Sequencer.CompleteSequence();    
            END_IF;       

        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE
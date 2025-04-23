USING AXOpen.Core;
NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            ExampleComponent : AXOpen.Components.Rexroth.Tightening.TemplateComponent;             
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
                ExampleComponent.ActivateManualControl();
            END_IF;

            //<Initialization>        
            ExampleComponent.Run(
                                parent  :=   THIS,
                                hwID    :=   WORD#60,
                                hwID_1  :=   WORD#61,
                                hwID_2  :=   WORD#62,
                                hwID_3  :=   WORD#63,
                                hwID_4  :=   WORD#64,
                                hwID_5  :=   WORD#65,
                                hwID_6  :=   WORD#66,
                                hwID_7  :=   WORD#67,
                                hwID_8  :=   WORD#68,
                                hwID_9  :=   WORD#69,
                                hwID_10 :=   WORD#70,
                                hwID_11 :=   WORD#71,
                                hwID_12 :=   WORD#72,
                                hwID_13 :=   WORD#73,
                                hwID_14 :=   WORD#74,
                                hwID_15 :=   WORD#75,
                                hwID_16 :=   WORD#76,
                                hwID_17 :=   WORD#77,
                                hwID_18 :=   WORD#78,
                                hwID_19 :=   WORD#79,
                                hwID_20 :=   WORD#80);
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

            IF(Steps[0].Execute(Sequencer, 'TemplateMethod_10steps_1')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_1().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'TemplateMethod_10steps_2')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_2().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[2].Execute(Sequencer, 'TemplateMethod_10steps_3')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_3().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'TemplateMethod_10steps_4')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_4().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[4].Execute(Sequencer, 'TemplateMethod_10steps_5')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_5().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[5].Execute(Sequencer, 'TemplateMethod_10steps_6')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_6().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[6].Execute(Sequencer, 'TemplateMethod_20steps_1')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_1().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[7].Execute(Sequencer, 'TemplateMethod_20steps_2')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_2().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[8].Execute(Sequencer, 'TemplateMethod_20steps_3')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_3().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[9].Execute(Sequencer, 'TemplateMethod_20steps_4')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_4().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[10].Execute(Sequencer, 'TemplateMethod_20steps_5')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_5().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[11].Execute(Sequencer, 'TemplateMethod_20steps_6')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_6().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[12].Execute(Sequencer, 'Restore')) THEN
                ExampleComponent.Restore();
                Sequencer.CompleteSequence();    
            END_IF;       

        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE
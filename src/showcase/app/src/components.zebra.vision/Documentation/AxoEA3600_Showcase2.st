USING AXOpen.Core;
NAMESPACE AXOpen.Components.Zebra.Vision
    {S7.extern=ReadWrite}
    CLASS AxoEA3600_Showcase2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            ExampleComponent : AXOpen.Components.Zebra.Vision.AxoEA3600;             
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
                ExampleComponent.ActivateManualControl();
            END_IF;

            //<Initialization>        
            ExampleComponent.Run(parent  :=   THIS,hwID    :=   AXOpen.Showcase.HwIdentifiers#zebra_HwID);
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            {#ix-set:AttributeName = "<#Start test sequence#>"}
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..30] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer   
            IF Sequencer.GetContext().OpenCycleCount() = ULINT#0 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'ClearData')) THEN
                ActivateManualControl := FALSE;
                IF(ExampleComponent.ClearData().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Read')) THEN
                IF(ExampleComponent.Read().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[2].Execute(Sequencer, 'ClearError')) THEN
                IF(ExampleComponent.ClearError().IsDone()) THEN     
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
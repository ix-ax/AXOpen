USING AXOpen.Core;
NAMESPACE AXOpen.Components.Siem.Communication
    {S7.extern=ReadWrite}
    CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            ExampleComponent : AXOpen.Components.Siem.Communication.AxoCmPtp;             
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
            return;
            SUPER.Run(inParent);

            IF ActivateManualControl THEN
                ExampleComponent.ActivateManualControl();
            END_IF;

            //<Initialization>        
            ExampleComponent.Run(parent  :=   THIS,hwID    :=   UINT#60);
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            {#ix-set:AttributeName = "<#Start test sequence#>"}
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..30] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _dataToSend : AxoCmPtp_Data;
        END_VAR

        METHOD PRIVATE UseInSequencer  
            VAR
                i   :   INT;
            END_VAR
            
            IF Sequencer.GetContext().OpenCycleCount() = ULINT#0 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Port config')) THEN
                ActivateManualControl := FALSE;
                IF(ExampleComponent.PortConfig( Protocol    := eAxoCmPtp_Protocol#Freeport,
                                                BaudRate    := eAxoCmPtp_Baud#_9600,
                                                Parity      := eAxoCmPtp_Parity#NoParity,
                                                DataBits    := eAxoCmPtp_DataBits#_8dataBits,
                                                StopBits    := eAxoCmPtp_StopBits#_1stopBits,
                                                FlowControl := eAxoCmPtp_FlowControl#NoFlowControl).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Prepare data')) THEN
                FOR i := 0 TO 1023 DO
                    _dataToSend.Data[i] := TO_BYTE((i MOD 40 ) + 40) ;
                END_FOR;
                Sequencer.MoveNext();                
            END_IF;  

            IF(Steps[2].Execute(Sequencer, 'Send data')) THEN
                IF(ExampleComponent.SendData(_dataToSend).IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'Receive data')) THEN
                IF(ExampleComponent.NewDataReceived()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[4].Execute(Sequencer, 'TemplateMethod_10steps_4')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_4().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[5].Execute(Sequencer, 'TemplateMethod_10steps_5')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_5().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[6].Execute(Sequencer, 'TemplateMethod_10steps_6')) THEN
                IF(ExampleComponent.TemplateMethod_10steps_6().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[7].Execute(Sequencer, 'TemplateMethod_20steps_1')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_1().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[8].Execute(Sequencer, 'TemplateMethod_20steps_2')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_2().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[9].Execute(Sequencer, 'TemplateMethod_20steps_3')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_3().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[10].Execute(Sequencer, 'TemplateMethod_20steps_4')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_4().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[11].Execute(Sequencer, 'TemplateMethod_20steps_5')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_5().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[12].Execute(Sequencer, 'TemplateMethod_20steps_6')) THEN
                IF(ExampleComponent.TemplateMethod_20steps_6().IsDone()) THEN     
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[13].Execute(Sequencer, 'Restore')) THEN
                ExampleComponent.Restore();
                Sequencer.CompleteSequence();    
            END_IF;       

        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE
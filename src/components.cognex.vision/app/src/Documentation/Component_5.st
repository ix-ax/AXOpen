USING AXOpen.Core;

NAMESPACE AXOpen.Components.Cognex.Vision

    {S7.extern=ReadWrite}
    CLASS Component_5 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            VisionPro : AXOpen.Components.Cognex.Vision.AxoVisionPro;
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
                //<InsightManualControl>
                VisionPro.ActivateManualControl();
                //</InsightManualControl>
            END_IF;

            //<Initialization>        
            // VisionPro.Run(parent := THIS, hwID := HwIdentifiers#vision_pro_HwID, CameraNo := UINT#1);
            VisionPro.Run(parent := THIS, hwID := HwIdentifiers#CommunicationCard_HwID, CameraNo := UINT#1);
            //</Initialization>
            THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..10] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _InspectionResults : ARRAY[0..1300] OF BYTE;
            _UserData : ARRAY[0..1300] OF BYTE;
        END_VAR

        METHOD PRIVATE UseInSequencer   
            IF Sequencer.GetContext().OpenCycleCount() <= ULINT#10 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                VisionPro.Restore();
                Sequencer.MoveNext();                
            END_IF;       

            IF(Steps[1].Execute(Sequencer, 'HardResetAllCameras')) THEN
                IF(VisionPro.HardResetAllCameras().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Trigger')) THEN
                IF(VisionPro.Trigger().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'ReadResults')) THEN
                IF(VisionPro.ReadResults(JobID := UINT#1, Length := UINT#620, Data := _InspectionResults).IsDone()) THEN
                    Sequencer.MoveNext();                
                END_IF;       
            END_IF;       

            IF(Steps[4].Execute(Sequencer, 'SendData')) THEN
                IF(VisionPro.SendData(InspectionType := UINT#2, BufferID := UINT#3, JobID := UINT#1, Length := UINT#251, Data := _UserData).IsDone()) THEN
                    Sequencer.MoveNext();                
                END_IF;   
            END_IF;     

            IF(Steps[5].Execute(Sequencer, 'Reset')) THEN
                IF(VisionPro.Reset().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;   
            
            IF(Steps[6].Execute(Sequencer, 'Restore')) THEN
                VisionPro.Restore();
                Sequencer.CompleteSequence();                
            END_IF;       
        END_METHOD
        
        //</Usage>


    END_CLASS
END_NAMESPACE
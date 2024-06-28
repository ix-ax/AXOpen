USING AXOpen.Core;

NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0

    {S7.extern=ReadWrite}
    CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            Dataman_280 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;     
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC              
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;         
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoContext;
            END_VAR    

            THIS.Initialize(parent);

            IF ActivateManualControl THEN
                //<DatamanManualControl>
                Dataman_280.ActivateManualControl();
                //</DatamanManualControl>
            END_IF;

            //<Initialization>        
            Dataman_280.Run(parent                     :=  THIS,  
                            ResultDataSize             :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoDataman_ResultDataSize#RESULT_DATA_128B,
                            UserDataSize               :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoDataman_UserDataSize#USER_DATA_128B,
                            hwID                       :=  HwIdentifiers#reader_st1_HwID,
                            hwIdAcquisitionControl     :=  HwIdentifiers#reader_st1_Acquisition_Control_Acquisition_Control_HwID,
                            hwIdAcquisitionStatus      :=  HwIdentifiers#reader_st1_Acquisition_Status_Acquisition_Status_HwID,
                            hwIdResultsControl         :=  HwIdentifiers#reader_st1_Results_Control_Results_Control_HwID,
                            hwIdResultsStatus          :=  HwIdentifiers#reader_st1_Results_Status_Results_Status_HwID,
                            hwIdSoftEventControl       :=  HwIdentifiers#reader_st1_Soft_Event_Control_Soft_Event_Control_HwID,
                            hwIdResultData             :=  HwIdentifiers#reader_st1_Result_Data_128_bytes_Result_Data___128_bytes_HwID,
                            hwIdUserData               :=  HwIdentifiers#reader_st1_User_Data_128_bytes_User_Data___128_bytes_HwID);
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..4] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _ResultData  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman_ResultData;
        END_VAR

        METHOD PRIVATE UseInSequencer   

            Sequencer.Initialize(THIS);
            Sequencer.Open();

            
            IF(Steps[0].Execute(Sequencer, 'Clear result data')) THEN
                IF(Dataman_280.ClearResultData().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;  

            IF(Steps[1].Execute(Sequencer, 'Change job')) THEN
                IF(Dataman_280.Read().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Evaluate data')) THEN
                _ResultData := Dataman_280.ResultData;
                Sequencer.MoveNext();                
            END_IF;       
    

        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE
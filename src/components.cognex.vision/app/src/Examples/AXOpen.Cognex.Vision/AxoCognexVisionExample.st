USING AXOpen.Core;
USING AXOpen.Cognex.Vision.v_6_0_0_0;

NAMESPACE AxoCognexVisionExample

    CLASS AxoCognexVisionExampleContext EXTENDS AXOpen.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "someInsight"}
            MyInsight : AXOpen.Cognex.Vision.v_6_0_0_0.AxoInsight;  
            {#ix-set:AttributeName = "10A1"}
            MyDataman1 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoDataman;  
            {#ix-set:AttributeName = "reader_st2"}
            MyDataman2 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoDataman;  
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  
            PlcInputs : REF_TO PlcInputs;
            PlcOutputs : REF_TO PlcOutputs;          
        END_VAR

        METHOD PROTECTED OVERRIDE Main   
            // Example of the activation of the manual control. 
            IF ActivateManualControl THEN
                MyInsight.ActivateManualControl();
                MyDataman1.ActivateManualControl();
                MyDataman2.ActivateManualControl();
            END_IF;
            // Calling the main method `Run` with respective input and output variables. 
            //<CognexInsightHWIO_Assignement>
            MyInsight.Run(  parent                  :=  THIS,  
                            refAcquisitionControl   :=  REF(PlcOutputs^._7600_Acquisition_Control_1),
                            refAcquisitionStatus    :=  REF(PlcInputs^._7600_Acquisition_Status_1),
                            refInspectionControl    :=  REF(PlcOutputs^._7600_Inspection_Control_1),
                            refInspectionStatus     :=  REF(PlcInputs^._7600_Inspection_Status_1),
                            refCommandControl       :=  REF(PlcOutputs^._7600_Command_Control_1),
                            refCommandStatus        :=  REF(PlcInputs^._7600_Command_Control_1),
                            refSoftEventControl     :=  REF(PlcOutputs^._7600_SoftEvent_Control_1),
                            refSoftEventStatus      :=  REF(PlcInputs^._7600_SoftEvent_Control_1),
                            refResultData           :=  REF(PlcInputs^._7600_Results_64_bytes_1),
                            refUserData             :=  REF(PlcOutputs^._7600_User_Data_64_bytes_1));
            //</CognexInsightHWIO_Assignement>

            //<CognexDatamanHWIO_Assignement>
            MyDataman1.Run( parent                     :=  THIS,  
                            refAcquisitionControl      :=  REF(PlcOutputs^._10a1_Acquisition_Control_1),
                            refAcquisitionStatus       :=  REF(PlcInputs^._10a1_Acquisition_Status_1),
                            refResultsControl          :=  REF(PlcOutputs^._10a1_Results_Control_1),
                            refResultsStatus           :=  REF(PlcInputs^._10a1_Results_Status_1),
                            refSoftEventControl        :=  REF(PlcOutputs^._10a1_Soft_Event_Control_1),
                            refSoftEventStatus         :=  REF(PlcInputs^._10a1_Soft_Event_Control_1),
                            refResultData              :=  REF(PlcInputs^._10a1_Result_Data_128_bytes_1),
                            refUserData                :=  REF(PlcOutputs^._10a1_User_Data_128_bytes_1));
            //</CognexDatamanHWIO_Assignement>

            MyDataman2.Run( parent                     :=  THIS,  
                            refAcquisitionControl      :=  REF(PlcOutputs^.reader_st2_Acquisition_Control_1),
                            refAcquisitionStatus       :=  REF(PlcInputs^.reader_st2_Acquisition_Status_1),
                            refResultsControl          :=  REF(PlcOutputs^.reader_st2_Results_Control_1),
                            refResultsStatus           :=  REF(PlcInputs^.reader_st2_Results_Status_1),
                            refSoftEventControl        :=  REF(PlcOutputs^.reader_st2_Soft_Event_Control_1),
                            refSoftEventStatus         :=  REF(PlcInputs^.reader_st2_Results_Status_1),
                            refResultData              :=  REF(PlcInputs^.reader_st2_Result_Data_64_bytes_1),
                            refUserData                :=  REF(PlcOutputs^.reader_st2_User_Data_64_bytes_1));

        END_METHOD

        METHOD DocuExample
            VAR
                myDatamanData : ARRAY[0..245] OF BYTE;
                myInsightData : ARRAY[0..249] OF BYTE;
            END_VAR
    
            //<CognexDatamanClearResultData>
            IF MyDataman1.ClearResultData().IsDone() THEN
                //Data inside MyDataman1.Results.Data is cleared
                ;
            END_IF;                          
            //</CognexDatamanClearResultData>

            //<CognexDatamanRead>
            IF MyDataman1.Read().IsDone() THEN
                //Process the result data
                myDatamanData := MyDataman1.ResultData.Data;
                ;
            END_IF;                          
            //</CognexDatamanRead>

            //<CognexInsightClearInspectionResults>
            IF MyInsight.ClearInspectionResults().IsDone() THEN
                //Data inside MyInsight.InspectionResults.Data is cleared
                ;
            END_IF;    

            //<CognexInsightTrigger>
            IF MyInsight.Trigger().IsDone() THEN
                //Process the result data
                myInsightData := MyInsight.InspectionResults.Data;
            END_IF;                          
            //</CognexInsightTrigger>

            //<CognexInsightChangeJobByNumber>
            IF MyInsight.ChangeJob(UINT#5).IsDone() THEN
                ;
            END_IF;                          
            //</CognexInsightChangeJobByNumber>

            //<CognexInsightChangeJobByName>
            IF MyInsight.ChangeJob('MyJobName.job').IsDone() THEN
                ;
            END_IF;                          
            //</CognexInsightChangeJobByName>
            
            //<CognexInsightSoftEvent>
            IF MyInsight.SoftEvent(UINT#5).IsDone() THEN
                ;
            END_IF;                          
            //</CognexInsightSoftEvent>
        END_METHOD
    END_CLASS
END_NAMESPACE

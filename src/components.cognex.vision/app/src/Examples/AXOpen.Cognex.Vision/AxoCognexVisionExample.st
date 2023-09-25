USING AXOpen.Core;
USING AXOpen.Components.Cognex.Vision.v_6_0_0_0;

NAMESPACE AxoCognexVisionExample

    CLASS AxoCognexVisionExampleContext EXTENDS AXOpen.AxoContext
        //<InsightDeclaration>
        VAR PUBLIC
            Insight : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight; 
        END_VAR
        //</InsightDeclaration>

        //<DatamanDeclaration>
        VAR PUBLIC
            Dataman : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;
        END_VAR
        //</DatamanDeclaration>

        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  
            PlcInputs : REF_TO PlcInputs;
            PlcOutputs : REF_TO PlcOutputs;          
        END_VAR

        METHOD PROTECTED OVERRIDE Main   
            // Example of the activation of the manual control. 
            IF ActivateManualControl THEN
                //<InsightManualControl>
                Insight.ActivateManualControl();
                //</InsightManualControl>

                //<DatamanManualControl>
                Dataman.ActivateManualControl();
                //</DatamanManualControl>
            END_IF;
            // Calling the main method `Run` with respective input and output variables. 
            //<InsightInitialization>
            Insight.Run(parent                  :=  THIS,  
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
            //</InsightInitialization>

            //<DatamanInitialization>
            Dataman.Run(parent                     :=  THIS,  
                        refAcquisitionControl      :=  REF(PlcOutputs^._10a1_Acquisition_Control_1),
                        refAcquisitionStatus       :=  REF(PlcInputs^._10a1_Acquisition_Status_1),
                        refResultsControl          :=  REF(PlcOutputs^._10a1_Results_Control_1),
                        refResultsStatus           :=  REF(PlcInputs^._10a1_Results_Status_1),
                        refSoftEventControl        :=  REF(PlcOutputs^._10a1_Soft_Event_Control_1),
                        refSoftEventStatus         :=  REF(PlcInputs^._10a1_Soft_Event_Control_1),
                        refResultData              :=  REF(PlcInputs^._10a1_Result_Data_128_bytes_1),
                        refUserData                :=  REF(PlcOutputs^._10a1_User_Data_128_bytes_1));
            //</DatamanInitialization>
        END_METHOD

        METHOD DocuExample
            VAR
                myDatamanData : ARRAY[0..245] OF BYTE;
                myInsightData : ARRAY[0..249] OF BYTE;
            END_VAR
    
            //<CognexDatamanClearResultData>
            IF Dataman.ClearResultData().IsDone() THEN
                //Data inside MyDataman1.Results.Data is cleared
                ;
            END_IF;                          
            //</CognexDatamanClearResultData>

            //<CognexDatamanRead>
            IF Dataman.Read(myDatamanData).IsDone() THEN
                //Process the result data
                ;
            END_IF;                          
            //</CognexDatamanRead>

            //<CognexInsightClearInspectionResults>
            IF Insight.ClearInspectionResults().IsDone() THEN
                //Data inside MyInsight.InspectionResults.Data is cleared
                ;
            END_IF;   
            //</CognexInsightClearInspectionResults> 

            //<CognexInsightTrigger>
            IF Insight.Trigger().IsDone() THEN
                //Process the result data
                myInsightData := Insight.InspectionResults.Data;
            END_IF;                          
            //</CognexInsightTrigger>

            //<CognexInsightChangeJobByNumber>
            IF Insight.ChangeJob(UINT#5).IsDone() THEN
                ;
            END_IF;                          
            //</CognexInsightChangeJobByNumber>

            //<CognexInsightChangeJobByName>
            IF Insight.ChangeJob('MyJobName.job').IsDone() THEN
                ;
            END_IF;                          
            //</CognexInsightChangeJobByName>
            
            //<CognexInsightSoftEvent>
            IF Insight.SoftEvent(UINT#5).IsDone() THEN
                ;
            END_IF;                          
            //</CognexInsightSoftEvent>
        END_METHOD
    END_CLASS
END_NAMESPACE

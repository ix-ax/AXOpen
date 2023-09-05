USING AXOpen.Core;
USING AXOpen.Cognex.Vision.v_6_0_0_0;

NAMESPACE AxoCognexVisionInsightExamples

    CLASS AxoCognexVisionInsightExampleContext EXTENDS AXOpen.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "someInsight"}
            MyInsight : AXOpen.Cognex.Vision.v_6_0_0_0.AxoInsight;  
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  
            PlcInputs : REF_TO PlcInputs;
            PlcOutputs : REF_TO PlcOutputs;
        END_VAR

        METHOD PROTECTED OVERRIDE Main   
            // Example of the activation of the manual control. 
            IF ActivateManualControl THEN
                MyInsight.ActivateManualControl();
            END_IF;
            // Calling the main method `Run` with respective input and output variables. 
            //<HWIO_Assignement>
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
            //</HWIO_Assignement>
        END_METHOD


        METHOD DocuExample
            VAR
                myData : ARRAY[0..249] OF BYTE;
            END_VAR
                
                //<ClearInspectionResults>
                IF MyInsight.ClearInspectionResults().IsDone() THEN
                    //Data inside MyInsight.InspectionResults.Data is cleared
                    ;
                END_IF;    
                //</ClearInspectionResults>

                //<Trigger>
                IF MyInsight.Trigger().IsDone() THEN
                    //Process the result data
                    myData := MyInsight.InspectionResults.Data;
                END_IF;                          
                //</Trigger>

                //<ChangeJobByNumber>
                IF MyInsight.ChangeJob(UINT#5).IsDone() THEN
                    ;
                END_IF;                          
                //</ChangeJobByNumber>

                //<ChangeJobByName>
                IF MyInsight.ChangeJob('MyJobName.job').IsDone() THEN
                    ;
                END_IF;                          
                //</ChangeJobByName>
                
                //<SoftEvent>
                IF MyInsight.SoftEvent(UINT#5).IsDone() THEN
                    ;
                END_IF;                          
                //</SoftEvent>
                      
        END_METHOD

    END_CLASS
END_NAMESPACE

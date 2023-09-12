USING AXOpen.Core;
USING AXOpen.Components.Cognex.Vision.v_6_0_0_0;

NAMESPACE AxoCognexVisionDatamanExamples

    CLASS AxoCognexVisionDatamanExampleContext EXTENDS AXOpen.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "10A1"}
            MyDataman1 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;  
            {#ix-set:AttributeName = "reader_st2"}
            MyDataman2 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;  
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  
            PlcInputs : REF_TO PlcInputs;
            PlcOutputs : REF_TO PlcOutputs;
            myString : STRING;
        END_VAR

        METHOD PROTECTED OVERRIDE Main   
            // Example of the activation of the manual control. 
            IF ActivateManualControl THEN
                MyDataman1.ActivateManualControl();
                MyDataman2.ActivateManualControl();
            END_IF;
            // Calling the main method `Run` with respective input and output variables. 
            //<HWIO_Assignement>
            MyDataman1.Run( parent                     :=  THIS,  
                            refAcquisitionControl      :=  REF(PlcOutputs^._10a1_Acquisition_Control_1),
                            refAcquisitionStatus       :=  REF(PlcInputs^._10a1_Acquisition_Status_1),
                            refResultsControl          :=  REF(PlcOutputs^._10a1_Results_Control_1),
                            refResultsStatus           :=  REF(PlcInputs^._10a1_Results_Status_1),
                            refSoftEventControl        :=  REF(PlcOutputs^._10a1_Soft_Event_Control_1),
                            refSoftEventStatus         :=  REF(PlcInputs^._10a1_Soft_Event_Control_1),
                            refResultData              :=  REF(PlcInputs^._10a1_Result_Data_128_bytes_1),
                            refUserData                :=  REF(PlcOutputs^._10a1_User_Data_128_bytes_1));
            //</HWIO_Assignement>
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
                //<Read>
                IF MyDataman1.Read().IsDone() THEN
                    //Process the result data
                    // myString := MyDataman1.ResultData.Data;
                    ;
                END_IF;                          
                //</Read>

                //<ClearResultData>
                IF MyDataman1.ClearResultData().IsDone() THEN
                    //Data inside MyDataman1.Results.Data is cleared
                    ;
                END_IF;                          
                //</ClearResultData>
        END_METHOD

    END_CLASS
END_NAMESPACE

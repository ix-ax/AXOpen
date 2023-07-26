USING AXOpen.Core;
//USING AXOpen.Cognex.Vision.v_6_0_0_0;

NAMESPACE AxoCognexVisionDatamanExamples

    CLASS AxoCognexVisionDatamanExampleContext EXTENDS AXOpen.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "10A1"}
            MyDataman : AXOpen.Cognex.Vision.v_6_0_0_0.AxoDataman;  
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  
            PlcInputs : PlcInputs;
            PlcOutputs : PlcOutputs;
        END_VAR

        METHOD PROTECTED OVERRIDE Main   
            // Example of the activation of the manual control. 
            IF ActivateManualControl THEN
                MyDataman.ActivateManualControl();
            END_IF;
            // Calling the main method `Run` with respective input and output variables. 
            MyDataman.Run(  parent                  :=  THIS,  
                            AcquisitionStatus       :=  PlcInputs._10a1_Acquisition_Status_1,
                            ResultsStatus           :=  PlcInputs._10a1_Results_Status_1,
                            SoftEventStatus         :=  PlcInputs._10a1_Soft_Event_Control_1,
                            ResultData              :=  PlcInputs._10a1_Result_Data_128_bytes_1,
                            AcquisitionControl      :=  PlcOutputs._10a1_Acquisition_Control_1,
                            ResultsControl          :=  PlcOutputs._10a1_Results_Control_1,
                            SoftEventControl        :=  PlcOutputs._10a1_Soft_Event_Control_1,
                            UserData                :=  PlcOutputs._10a1_User_Data_128_bytes_1);
        END_METHOD
    END_CLASS
END_NAMESPACE

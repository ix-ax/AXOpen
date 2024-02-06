NAMESPACE axosimple.UnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;

    ///<summary>
    /// Groups components of this controller unit.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS Components
        EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            // HERE DECLARE COMPONENTS USED BY THIS CONTROLLED UNIT
            DI_1 : AXOpen.Elements.AxoDi;
            DI_2 : AXOpen.Elements.AxoDi;
            // DI_3 : AXOpen.Elements.AxoDi;
            // DI_4 : AXOpen.Elements.AxoDi;

            DO_1 : AXOpen.Elements.AxoDo;
            DO_2 : AXOpen.Elements.AxoDo;
            // DO_3 : AXOpen.Elements.AxoDo;
            // DO_4 : AXOpen.Elements.AxoDo;

            AI_1 : AXOpen.Elements.AxoAi;
            AI_2 : AXOpen.Elements.AxoAi;
            // AI_3 : AXOpen.Elements.AxoAi;
            // AI_4 : AXOpen.Elements.AxoAi;

            AO_1 : AXOpen.Elements.AxoAo;
            AO_2 : AXOpen.Elements.AxoAo;
            // AO_3 : AXOpen.Elements.AxoAo;
            // AO_4 : AXOpen.Elements.AxoAo;

            Cylinder_1 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_2 : AXOpen.Components.Pneumatics.AxoCylinder;
            // Cylinder_3 : AXOpen.Components.Pneumatics.AxoCylinder;
            // Cylinder_4 : AXOpen.Components.Pneumatics.AxoCylinder;

           
            Reader_1 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;
            Reader_2 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;

            Camera_1 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;
            Camera_2 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;

           
            {#ix-attr:[Container(Layout.Stack)]}
            Drive_R1  : AXOpen.Components.Rexroth.Drives.AxoIndraDrive;

            {#ix-attr:[Container(Layout.Stack)]}
            Drive_R2  : AXOpen.Components.Rexroth.Drives.AxoIndraDrive;

            {#ix-attr:[Container(Layout.Stack)]}
            Drive_F1  : AXOpen.Components.Festo.Drives.AxoCmmtAs;
            
            {#ix-attr:[Container(Layout.Stack)]}
            Drive_F2  : AXOpen.Components.Festo.Drives.AxoCmmtAs;

            _enable         : BOOL := TRUE;          
            _enablePositive : BOOL := TRUE;          
            _enableNegative : BOOL := TRUE; 

            {#ix-attr:[Container(Layout.Stack)]}
            Robot_A1  : AXOpen.Components.Abb.Robotics.AxoIrc5_v_1_x_x;  
            
            {#ix-attr:[Container(Layout.Stack)]}
            Robot_A2  : AXOpen.Components.Abb.Robotics.AxoOmnicore_v_1_x_x;  

        END_VAR

        
        METHOD PUBLIC Update
            VAR_INPUT
                parent : IAxoObject;
                Inputs : ref_to axosimple.Inputs; // must be a ref_to due to arrays in components
                Outputs : ref_to axosimple.Outputs;
            END_VAR
            THIS.Initialize(parent);
            
            THIS.Initialize(parent);
            // HERE INITIALIZE YOUR COMPONENTS
            
            DI_1.Run(THIS, Inputs^.D0[0]);
            DI_2.Run(THIS, Inputs^.D0[0]);
            // DI_3.Run(THIS, Inputs^.D0[0]);
            // DI_4.Run(THIS, Inputs^.D0[0]);

            DO_1.Run(THIS, Outputs^.D0[0]);
            DO_2.Run(THIS, Outputs^.D0[0]);
            // DO_3.Run(THIS, Outputs^.D0[0]);
            // DO_4.Run(THIS, Outputs^.D0[0]);

            AI_1.Run(THIS, Inputs^.A0[0]);
            AI_2.Run(THIS, Inputs^.A0[0]);
            // AI_3.Run(THIS, Inputs^.A0[0]);
            // AI_4.Run(THIS, Inputs^.A0[0]);

            AO_1.Run(THIS, Outputs^.A0[0]);
            AO_2.Run(THIS, Outputs^.A0[0]);
            // AO_3.Run(THIS, Outputs^.A0[0]);
            // AO_4.Run(THIS, Outputs^.A0[0]);


            Cylinder_1.Run(THIS, Inputs^.P0[0], Inputs^.P0[1], Outputs^.P0[0], Outputs^.P0[1]);
            Cylinder_2.Run(THIS, Inputs^.P0[2], Inputs^.P0[3], Outputs^.P0[2], Outputs^.P0[3]);
            // Cylinder_3.Run(THIS, Inputs^.P0[4], Inputs^.P0[5], Outputs^.P0[4], Outputs^.P0[5]);
            // Cylinder_4.Run(THIS, Inputs^.P0[6], Inputs^.P0[7], Outputs^.P0[6], Outputs^.P0[7]);

            Reader_1.Run(   parent                     :=  THIS,  
                            ResultDataSize             :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoDataman_ResultDataSize#RESULT_DATA_128B,
                            UserDataSize               :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoDataman_UserDataSize#USER_DATA_128B,
                            hwID                       :=  HwIdentifiers#Reader_1,
                            hwIdAcquisitionControl     :=  HwIdentifiers#Reader_1_Acquisition_Control_1,
                            hwIdAcquisitionStatus      :=  HwIdentifiers#Reader_1_Acquisition_Status_1,
                            hwIdResultsControl         :=  HwIdentifiers#Reader_1_Results_Control_1,
                            hwIdResultsStatus          :=  HwIdentifiers#Reader_1_Results_Status_1,
                            hwIdSoftEventControl       :=  HwIdentifiers#Reader_1_Soft_Event_Control_1,
                            hwIdResultData             :=  HwIdentifiers#Reader_1_Result_Data_128_bytes_1,
                            hwIdUserData               :=  HwIdentifiers#Reader_1_User_Data_128_bytes_1);

            Reader_2.Run(   parent                     :=  THIS,  
                            ResultDataSize             :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoDataman_ResultDataSize#RESULT_DATA_64B,
                            UserDataSize               :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoDataman_UserDataSize#USER_DATA_64B,
                            hwID                       :=  HwIdentifiers#Reader_2,
                            hwIdAcquisitionControl     :=  HwIdentifiers#Reader_2_Acquisition_Control_1,
                            hwIdAcquisitionStatus      :=  HwIdentifiers#Reader_2_Acquisition_Status_1,
                            hwIdResultsControl         :=  HwIdentifiers#Reader_2_Results_Control_1,
                            hwIdResultsStatus          :=  HwIdentifiers#Reader_2_Results_Status_1,
                            hwIdSoftEventControl       :=  HwIdentifiers#Reader_2_Soft_Event_Control_1,
                            hwIdResultData             :=  HwIdentifiers#Reader_2_Result_Data_64_bytes_1,
                            hwIdUserData               :=  HwIdentifiers#Reader_2_User_Data_64_bytes_1);
    

            Camera_1.Run(   parent                  :=  THIS,  
                            ResultDataSize          :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoInsight_ResultDataSize#RESULT_DATA_64B,
                            UserDataSize            :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoInsight_UserDataSize#USER_DATA_64B,
                            hwID                    :=  HwIdentifiers#Camera_1,
                            hwIdAcquisitionControl  :=  HwIdentifiers#Camera_1_Acquisition_Control,
                            hwIdAcquisitionStatus   :=  HwIdentifiers#Camera_1_Acquisition_Status,
                            hwIdInspectionControl   :=  HwIdentifiers#Camera_1_Inspection_Control,
                            hwIdInspectionStatus    :=  HwIdentifiers#Camera_1_Inspection_Status,
                            hwIdCommandControl      :=  HwIdentifiers#Camera_1_Command_Control,
                            hwIdSoftEventControl    :=  HwIdentifiers#Camera_1_SoftEvent_Control,
                            hwIdResultData          :=  HwIdentifiers#Camera_1_Results_64_bytes,
                            hwIdUserData            :=  HwIdentifiers#Camera_1_User_Data_64_bytes);

            Camera_2.Run(   parent                  :=  THIS,  
                            ResultDataSize          :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoInsight_ResultDataSize#RESULT_DATA_128B,
                            UserDataSize            :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoInsight_UserDataSize#USER_DATA_128B,
                            hwID                    :=  HwIdentifiers#Camera_2,
                            hwIdAcquisitionControl  :=  HwIdentifiers#Camera_2_Acquisition_Control,
                            hwIdAcquisitionStatus   :=  HwIdentifiers#Camera_2_Acquisition_Status,
                            hwIdInspectionControl   :=  HwIdentifiers#Camera_2_Inspection_Control,
                            hwIdInspectionStatus    :=  HwIdentifiers#Camera_2_Inspection_Status,
                            hwIdCommandControl      :=  HwIdentifiers#Camera_2_Command_Control,
                            hwIdSoftEventControl    :=  HwIdentifiers#Camera_2_SoftEvent_Control,
                            hwIdResultData          :=  HwIdentifiers#Camera_2_Results_128_bytes,
                            hwIdUserData            :=  HwIdentifiers#Camera_2_User_Data_128_bytes);


            Drive_R1.Run(   parent              :=  THIS,
                            hwID                :=  HwIdentifiers#Drive_R1,
                            hwIdParamCh_IDN     :=  HwIdentifiers#Drive_R1_ParamCh_IDN,
                            hwIdInput_9_Words   :=  HwIdentifiers#Drive_R1_Input_9_Words,
                            hwIdOutput_13_Words :=  HwIdentifiers#Drive_R1_Output_13_Words,
                            Enable              :=  _enable,
                            EnablePositive      :=  _enablePositive,
                            EnableNegative      :=  _enableNegative);


            Drive_R2.Run(   parent              :=  THIS,
                            hwID                :=  HwIdentifiers#Drive_R2,
                            hwIdParamCh_IDN     :=  HwIdentifiers#Drive_R2_ParamCh_IDN,
                            hwIdInput_9_Words   :=  HwIdentifiers#Drive_R2_Input_9_Words,
                            hwIdOutput_13_Words :=  HwIdentifiers#Drive_R2_Output_13_Words,
                            Enable              :=  _enable,
                            EnablePositive      :=  _enablePositive,
                            EnableNegative      :=  _enableNegative);


            Drive_F1.Run(   parent              :=  THIS,
                            hwId                :=  HwIdentifiers#Drive_F1_PN_IO_Interface,              
                            hwIdTelegram111     :=  HwIdentifiers#Drive_F1_DO_SERVO_1_Siemens_telegram_111_PZD_12_12,
                            hwIdTelegram750     :=  HwIdentifiers#Drive_F1_DO_SERVO_1_Siemens_telegram_750_PZD_4_1,
                            MAP_HW_ID           :=  HwIdentifiers#Drive_F1_DO_SERVO_1_Module_Access_Point,
                            Enable              :=  _enable,
                            EnablePositive      :=  _enablePositive,
                            EnableNegative      :=  _enableNegative);
            
            Drive_F2.Run(   parent              :=  THIS,
                            hwId                :=  HwIdentifiers#Drive_F2_PN_IO_Interface,              
                            hwIdTelegram111     :=  HwIdentifiers#Drive_F2_DO_SERVO_1_Siemens_telegram_111_PZD_12_12,
                            hwIdTelegram750     :=  HwIdentifiers#Drive_F2_DO_SERVO_1_Siemens_telegram_750_PZD_4_1,
                            MAP_HW_ID           :=  HwIdentifiers#Drive_F2_DO_SERVO_1_Module_Access_Point,
                            Enable              :=  _enable,
                            EnablePositive      :=  _enablePositive,
                            EnableNegative      :=  _enableNegative);

            Robot_A1.Run(    parent              :=  THIS,
                            hwID                :=  HwIdentifiers#Robot_A1,
                            hwIdDI_64_bytes     :=  HwIdentifiers#Robot_A1_DI_64_bytes,      
                            hwIdDO_64_bytes     :=  HwIdentifiers#Robot_A1_DO_64_bytes);   

            Robot_A2.Run(    parent              :=  THIS,
                            hwID                :=  HwIdentifiers#Robot_A2,
                            hwIdDI_64_bytes     :=  HwIdentifiers#Robot_A2_DI_64_bytes,      
                            hwIdDO_64_bytes     :=  HwIdentifiers#Robot_A2_DO_64_bytes);   

        END_METHOD
    END_CLASS
END_NAMESPACE    

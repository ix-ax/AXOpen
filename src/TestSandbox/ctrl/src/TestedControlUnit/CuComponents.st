NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;
    USING AXOpen.Cognex.Vision.v_6_0_0_0;
    

    ///<summary>
    /// Groups components of this controller unit.
    ///</summary>
    CLASS Components
        EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            counter : INT;
            {#ix-attr:[Container(Layout.Tabs)]}
           // HERE DECLARE COMPONENTS USED BY THIS CONTROLLED UNIT
            Cylinder_0 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_1 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_2 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_3 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_4 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_5 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_6 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_7 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_8 : AXOpen.Components.Pneumatics.AxoCylinder;
            Cylinder_9 : AXOpen.Components.Pneumatics.AxoCylinder;
            Camera_0 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoInsight;
            Camera_1 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoInsight;
            Reader_0 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoDataman;
            Reader_1 : AXOpen.Cognex.Vision.v_6_0_0_0.AxoDataman;
        END_VAR

        METHOD PUBLIC Update
            VAR_INPUT
                parent : IAxoObject;
            END_VAR
            VAR_INPUT
                Inputs : REF_TO sandboxtest.Inputs;
                Outputs : REF_TO sandboxtest.Outputs;
            END_VAR
            THIS.Initialize(parent);
            // HERE INITIALIZE YOUR COMPONENTS
            Cylinder_0.Run(THIS, Inputs^.B0[0], Inputs^.B0[1], Outputs^.B0[2], Outputs^.B0[3]);
            Cylinder_1.Run(THIS, Inputs^.B1[0], Inputs^.B1[1], Outputs^.B1[2], Outputs^.B1[3]);
            Cylinder_2.Run(THIS, Inputs^.B2[0], Inputs^.B2[1], Outputs^.B2[2], Outputs^.B2[3]);
            Cylinder_3.Run(THIS, Inputs^.B3[0], Inputs^.B3[1], Outputs^.B3[2], Outputs^.B3[3]);
            Cylinder_4.Run(THIS, Inputs^.B4[0], Inputs^.B4[1], Outputs^.B4[2], Outputs^.B4[3]);
            Cylinder_5.Run(THIS, Inputs^.B5[0], Inputs^.B5[1], Outputs^.B5[2], Outputs^.B5[3]);
            Cylinder_6.Run(THIS, Inputs^.B6[0], Inputs^.B6[1], Outputs^.B6[2], Outputs^.B6[3]);
            Cylinder_7.Run(THIS, Inputs^.B7[0], Inputs^.B7[1], Outputs^.B7[2], Outputs^.B7[3]);
            Cylinder_8.Run(THIS, Inputs^.B8[0], Inputs^.B8[1], Outputs^.B8[2], Outputs^.B8[3]);
            Cylinder_9.Run(THIS, Inputs^.B9[0], Inputs^.B9[1], Outputs^.B9[2], Outputs^.B9[3]);

            Reader_0.Run( parent            :=  THIS,  
                refAcquisitionStatus        :=  REF(Inputs^._Reader_0_Acquisition_Status_1),
                refSoftEventStatus          :=  REF(Inputs^._Reader_0_Soft_Event_Control_1),
                refResultsStatus            :=  REF(Inputs^._Reader_0_Results_Status_1),
                refResultData               :=  REF(Inputs^._Reader_0_Result_Data_128_bytes_1),
                refUserData                 :=  REF(Outputs^._Reader_0_User_Data_128_bytes_1),
                refAcquisitionControl       :=  REF(Outputs^._Reader_0_Acquisition_Control_1),
                refResultsControl           :=  REF(Outputs^._Reader_0_Results_Control_1),
                refSoftEventControl         :=  REF(Outputs^._Reader_0_Soft_Event_Control_1)
            );

            Reader_1.Run( parent            :=  THIS,  
                refAcquisitionStatus        :=  REF(Inputs^._Reader_1_Acquisition_Status_1),
                refSoftEventStatus          :=  REF(Inputs^._Reader_1_Soft_Event_Control_1),
                refResultsStatus            :=  REF(Inputs^._Reader_1_Results_Status_1),
                refResultData               :=  REF(Inputs^._Reader_1_Result_Data_128_bytes_1),
                refUserData                 :=  REF(Outputs^._Reader_1_User_Data_128_bytes_1),
                refAcquisitionControl       :=  REF(Outputs^._Reader_1_Acquisition_Control_1),
                refResultsControl           :=  REF(Outputs^._Reader_1_Results_Control_1),
                refSoftEventControl         :=  REF(Outputs^._Reader_1_Soft_Event_Control_1)
            );


            Camera_0.Run(  parent                  :=  THIS,  
                            refAcquisitionStatus    :=  REF(Inputs^ ._Camera_0_Acquisition_Status_1),
                            refInspectionStatus     :=  REF(Inputs^ ._Camera_0_Inspection_Status_1),
                            refCommandStatus        :=  REF(Inputs^ ._Camera_0_Command_Control_1),
                            refSoftEventStatus      :=  REF(Inputs^ ._Camera_0_SoftEvent_Control_1),
                            refResultData           :=  REF(Inputs^ ._Camera_0_Results_64_bytes_1),
                            refInspectionControl    :=  REF(Outputs^._Camera_0_Inspection_Control_1),
                            refCommandControl       :=  REF(Outputs^._Camera_0_Command_Control_1),
                            refAcquisitionControl   :=  REF(Outputs^._Camera_0_Acquisition_Control_1),
                            refSoftEventControl     :=  REF(Outputs^._Camera_0_SoftEvent_Control_1),
                            refUserData             :=  REF(Outputs^._Camera_0_User_Data_64_bytes_1));

            Camera_1.Run(  parent                  :=  THIS,  
                            refAcquisitionStatus    :=  REF(Inputs^ ._Camera_1_Acquisition_Status_1),
                            refInspectionStatus     :=  REF(Inputs^ ._Camera_1_Inspection_Status_1),
                            refCommandStatus        :=  REF(Inputs^ ._Camera_1_Command_Control_1),
                            refSoftEventStatus      :=  REF(Inputs^ ._Camera_1_SoftEvent_Control_1),
                            refResultData           :=  REF(Inputs^ ._Camera_1_Results_64_bytes_1),
                            refInspectionControl    :=  REF(Outputs^._Camera_1_Inspection_Control_1),
                            refCommandControl       :=  REF(Outputs^._Camera_1_Command_Control_1),
                            refAcquisitionControl   :=  REF(Outputs^._Camera_1_Acquisition_Control_1),
                            refSoftEventControl     :=  REF(Outputs^._Camera_1_SoftEvent_Control_1),
                            refUserData             :=  REF(Outputs^._Camera_1_User_Data_64_bytes_1));
                          ;  
        END_METHOD
    END_CLASS

END_NAMESPACE

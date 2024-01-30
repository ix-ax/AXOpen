NAMESPACE axosimple    
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT

            P0 : ARRAY[0..7] OF BOOL;
            P1 : ARRAY[0..7] OF BOOL;

            A0: ARRAY[0..7] OF DINT;
            A1 : ARRAY[0..7] OF DINT;

            D0 : ARRAY[0..7] OF BOOL;
            D1 : ARRAY[0..7] OF BOOL;


            Reader_1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
            Reader_1_Results_Status_1 : BYTE;
            Reader_1_Soft_Event_Control_1 : BYTE;
            Reader_1_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;
            
            Reader_2_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
            Reader_2_Results_Status_1 : BYTE;
            Reader_2_Soft_Event_Control_1 : BYTE;
            Reader_2_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;
            
            Camera_1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
            Camera_1_Inspection_Status_1 : DWORD;
            Camera_1_Command_Control_1 : WORD;
            Camera_1_SoftEvent_Control_1 : BYTE;
            Camera_1_Results_64_bytes_1 : ARRAY[0..67] OF BYTE;

            Camera_2_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
            Camera_2_Inspection_Status_1 : DWORD;
            Camera_2_Command_Control_1 : WORD;
            Camera_2_SoftEvent_Control_1 : BYTE;
            Camera_2_Results_64_bytes_1 : ARRAY[0..67] OF BYTE;

            Drive_R1_ParamCh_IDN_1 : ARRAY[0..9] OF BYTE;
            Drive_R1_Input_9_Words_1 : ARRAY[0..17] OF BYTE;
            
            Drive_R2_ParamCh_IDN_1 : ARRAY[0..9] OF BYTE;
            Drive_R2_Input_9_Words_1 : ARRAY[0..17] OF BYTE;
  

            Drive_F1_Siemens_telegram_111_PZD_12_12 : ARRAY[0..23] OF BYTE;
            Drive_F1_Siemens_telegram_750_PZD_4_1 : WORD;
            Drive_F1_HwId : WORD := WORD#256;

            Drive_F2_Siemens_telegram_111_PZD_12_12 : ARRAY[0..23] OF BYTE;
            Drive_F2_Siemens_telegram_750_PZD_4_1 : WORD;
            Drive_F2_HwId  : WORD := WORD#257;
            


            Drive_F1_PN_IO_Interface : WORD  :=	WORD#271;
            Drive_F1_PN_IO_Interface_Port_1 : WORD :=	WORD#260;
            Drive_F1_PN_IO_Interface_Port_2 : WORD :=	WORD#261;
            Drive_F1_CMMT_AS_MP : WORD :=	WORD#272;
            Drive_F1_DO_SERVO_1_Module_Access_Point : WORD :=	WORD#264;
            Drive_F1_DO_SERVO_1_Siemens_telegram_111_PZD_12_12 : WORD :=WORD#265;
            Drive_F1_DO_SERVO_1_Siemens_telegram_750_PZD_4_1 : WORD :=	WORD#266;

            Drive_F2_PN_IO_Interface : WORD :=	WORD#281;
            Drive_F2_PN_IO_Interface_Port_1 : WORD :=	WORD#280;
            Drive_F2_PN_IO_Interface_Port_2 : WORD :=	WORD#281;
            Drive_F2_CMMT_AS_MP:  WORD  :=	WORD#282;
            Drive_F2_DO_SERVO_1_Module_Access_Point : WORD :=	WORD#284;
            Drive_F2_DO_SERVO_1_Siemens_telegram_111_PZD_12_12 : WORD :=	WORD#285;
            Drive_F2_DO_SERVO_1_Siemens_telegram_750_PZD_4_1 : WORD :=	WORD#286;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE

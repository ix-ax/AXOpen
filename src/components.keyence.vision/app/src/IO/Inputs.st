NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
            sr_1000_1_BusyStatus AT %B168:  BYTE;
            sr_1000_1_CompletionStatus AT %B167:  BYTE;
            sr_1000_1_ErrorStatus AT %B166:  BYTE;
            sr_1000_1_HandshakeAndGeneralErrorStatus AT %B169:  BYTE;
            sr_1000_1_MatchingLevelAndTotalEvaluationGradeStatus AT %B156:  LWORD;
            sr_1000_1_OperationResultStatus_0 AT %B136:  DWORD;
            sr_1000_1_OperationResultStatus_1 AT %B140:  DWORD;
            sr_1000_1_OperationResultStatus_2 AT %B144:  DWORD;
            sr_1000_1_OperationResultStatus_3 AT %B148:  DWORD;
            sr_1000_1_OperationResultStatus_4 AT %B152:  DWORD;
            sr_1000_1_ReadData_128_bytes_0 AT %B0:  LWORD;
            sr_1000_1_ReadData_128_bytes_1 AT %B8:  LWORD;
            sr_1000_1_ReadData_128_bytes_2 AT %B16:  LWORD;
            sr_1000_1_ReadData_128_bytes_3 AT %B24:  LWORD;
            sr_1000_1_ReadData_128_bytes_4 AT %B32:  LWORD;
            sr_1000_1_ReadData_128_bytes_5 AT %B40:  LWORD;
            sr_1000_1_ReadData_128_bytes_6 AT %B48:  LWORD;
            sr_1000_1_ReadData_128_bytes_7 AT %B56:  LWORD;
            sr_1000_1_ReadData_128_bytes_8 AT %B64:  LWORD;
            sr_1000_1_ReadData_128_bytes_9 AT %B72:  LWORD;
            sr_1000_1_ReadData_128_bytes_10 AT %B80:  LWORD;
            sr_1000_1_ReadData_128_bytes_11 AT %B88:  LWORD;
            sr_1000_1_ReadData_128_bytes_12 AT %B96:  LWORD;
            sr_1000_1_ReadData_128_bytes_13 AT %B104:  LWORD;
            sr_1000_1_ReadData_128_bytes_14 AT %B112:  LWORD;
            sr_1000_1_ReadData_128_bytes_15 AT %B120:  LWORD;
            sr_1000_1_ReadData_128_bytes_16 AT %B128:  LWORD;
            sr_1000_1_TerminalStatus AT %B165:  BYTE;
            sr_1000_1_UnstableReadStatus AT %B164:  BYTE;
            sr_750_1_BusyStatus AT %B338:  BYTE;
            sr_750_1_CompletionStatus AT %B337:  BYTE;
            sr_750_1_ErrorStatus AT %B336:  BYTE;
            sr_750_1_HandshakeAndGeneralErrorStatus AT %B339:  BYTE;
            sr_750_1_MatchingLevelAndTotalEvaluationGradeStatus AT %B326:  LWORD;
            sr_750_1_OperationResultStatus_0 AT %B306:  DWORD;
            sr_750_1_OperationResultStatus_1 AT %B310:  DWORD;
            sr_750_1_OperationResultStatus_2 AT %B314:  DWORD;
            sr_750_1_OperationResultStatus_3 AT %B318:  DWORD;
            sr_750_1_OperationResultStatus_4 AT %B322:  DWORD;
            sr_750_1_ReadData_128_bytes_0 AT %B170:  LWORD;
            sr_750_1_ReadData_128_bytes_1 AT %B178:  LWORD;
            sr_750_1_ReadData_128_bytes_2 AT %B186:  LWORD;
            sr_750_1_ReadData_128_bytes_3 AT %B194:  LWORD;
            sr_750_1_ReadData_128_bytes_4 AT %B202:  LWORD;
            sr_750_1_ReadData_128_bytes_5 AT %B210:  LWORD;
            sr_750_1_ReadData_128_bytes_6 AT %B218:  LWORD;
            sr_750_1_ReadData_128_bytes_7 AT %B226:  LWORD;
            sr_750_1_ReadData_128_bytes_8 AT %B234:  LWORD;
            sr_750_1_ReadData_128_bytes_9 AT %B242:  LWORD;
            sr_750_1_ReadData_128_bytes_10 AT %B250:  LWORD;
            sr_750_1_ReadData_128_bytes_11 AT %B258:  LWORD;
            sr_750_1_ReadData_128_bytes_12 AT %B266:  LWORD;
            sr_750_1_ReadData_128_bytes_13 AT %B274:  LWORD;
            sr_750_1_ReadData_128_bytes_14 AT %B282:  LWORD;
            sr_750_1_ReadData_128_bytes_15 AT %B290:  LWORD;
            sr_750_1_ReadData_128_bytes_16 AT %B298:  LWORD;
            sr_750_1_TerminalStatus AT %B335:  BYTE;
            sr_750_1_UnstableReadStatus AT %B334:  BYTE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE

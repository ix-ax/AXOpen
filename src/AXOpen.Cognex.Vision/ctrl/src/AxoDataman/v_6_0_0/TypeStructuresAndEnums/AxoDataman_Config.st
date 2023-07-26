USING System.SerDe;

NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Stack)]}
        AxoDataman_Config : 
        STRUCT
            ResultDataSize : eAxoDataman_ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_64B;
            UserDataSize : eAxoDataman_UserDataSize := eAxoDataman_UserDataSize#USER_DATA_64B;
            DataFormat : Endianness := Endianness#Big;
            ContinuousReading : BOOL := FALSE;
            InfoTime : LTIME := LT#2S;
            ErrorTime : LTIME := LT#5S;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        AxoDataman_Results : 
        STRUCT
            Id: UINT;
            Code: UINT;
            Extended: UINT;
            Length : UINT;
            Data : ARRAY[0..245] OF BYTE;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
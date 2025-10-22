NAMESPACE AXOpen.Components.Siem.Communication
    TYPE
        eAxoCmPtp_Parity : UINT (
            NoParity        :=  UINT#1,
            EvenParity      :=  UINT#2,
            OddParity       :=  UINT#3,
            MarkParity      :=  UINT#4,
            SpaceParity     :=  UINT#5,
            Any             :=  UINT#6
            ) := NoParity; 
    END_TYPE
END_NAMESPACE
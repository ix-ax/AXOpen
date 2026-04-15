NAMESPACE AXOpen.Components.Siem.Communication
    TYPE
        eAxoCmPtp_BreakDetection : USINT (
            deactivated     := USINT#0,           //0: Break detection deactivated
            activated       := USINT#1            //1: Break detection activated
        ) := deactivated; 
    END_TYPE
END_NAMESPACE
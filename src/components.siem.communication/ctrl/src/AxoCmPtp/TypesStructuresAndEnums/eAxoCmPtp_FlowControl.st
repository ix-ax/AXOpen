NAMESPACE AXOpen.Components.Siem.Communication
    TYPE
        eAxoCmPtp_FlowControl : UINT (
            NoFlowControl                       :=  UINT#1,
            XON_XOFF                            :=  UINT#2,
            HardwareRTSalwaysON                 :=  UINT#3,
            HardwareRTSswitched                 :=  UINT#4,
            HardwareRTSalwaysONignoreDTR_DSR    :=  UINT#5
        ) := NoFlowControl; 
    END_TYPE
END_NAMESPACE

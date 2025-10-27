NAMESPACE AXOpen.Components.Siem.Communication
    TYPE
        eAxoCmPtp_Mode : USINT (
            FullDuplexRS232                 :=  USINT#0,     //  0: Full duplex (RS232)
            FullDuplexRS422_4wire_ptp       :=  USINT#1,     //  1: Full duplex (RS422) four-wire mode (point-to-point)
            FullDuplexRS422_4wire_mpm       :=  USINT#2,     //  2: Full duplex (RS 422) four-wire mode (multipoint master; CM PtP (ET 200SP))
            FullDuplexRS422_4wire_mps       :=  USINT#3,     //  3: Full duplex (RS 422) four-wire mode (multipoint slave; CM PtP (ET 200SP))
            HalfDuplexRS485_2wire_1         :=  USINT#4      //  4: Half duplex (RS485) two-wire mode 1)
        ) := FullDuplexRS232; 
    END_TYPE
END_NAMESPACE
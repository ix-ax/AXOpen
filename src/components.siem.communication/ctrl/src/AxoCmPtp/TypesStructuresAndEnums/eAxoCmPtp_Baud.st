NAMESPACE AXOpen.Components.Siem.Communication
    TYPE
        eAxoCmPtp_Baud : UINT (
            _300        := UINT#1,
            _600        := UINT#2,
            _1200       := UINT#3,
            _2400       := UINT#4,
            _4800       := UINT#5,
            _9600       := UINT#6,
            _19200      := UINT#7,
            _38400      := UINT#8,
            _57600      := UINT#9,
            _76800      := UINT#10,
            _115200     := UINT#11,
            _250000     := UINT#12
        ) := _9600; 
    END_TYPE
END_NAMESPACE
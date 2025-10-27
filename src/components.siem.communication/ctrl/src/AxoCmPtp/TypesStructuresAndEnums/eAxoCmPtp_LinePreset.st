NAMESPACE AXOpen.Components.Siem.Communication
    TYPE
        eAxoCmPtp_LinePreset : USINT (
            NoInitialState          := USINT#0,     //0: No initial state
            SignalRA_5VsignalRB_0V  := USINT#1,     //1: Signal R(A)=5 V, signal R(B)=0 V (break detection): Break detection is possible with this initial state. Can only be selected with: "Full duplex (RS422) four-wire mode (point-to-point connection)" and "Full duplex (RS422) four-wire mode (multipoint slave)".
            SignalRA_0VsignalRB_5V  := USINT#2      //2: Signal R(A)=0 V, signal R(B)=5 V: This default setting corresponds to the idle state (no active send operation). No break detection is possible with this initial state.
        ) := NoInitialState; 
    END_TYPE
END_NAMESPACE
NAMESPACE AXOpen.Components.Siem.Communication
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoCmPtp_PortConfig
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Protocol#>"}
            Protocol : eAxoCmPtp_Protocol := eAxoCmPtp_Protocol#Freeport;
            {#ix-set:AttributeName = "<#Baudrate#>"}
            BaudRate : eAxoCmPtp_Baud := eAxoCmPtp_Baud#_9600;
            {#ix-set:AttributeName = "<#Parity#>"}
            Parity : eAxoCmPtp_Parity := eAxoCmPtp_Parity#NoParity;
            {#ix-set:AttributeName = "<#Data bits#>"}
            DataBits : eAxoCmPtp_DataBits := eAxoCmPtp_DataBits#_8dataBits;
            {#ix-set:AttributeName = "<#Stop bits#>"}
            StopBits : eAxoCmPtp_StopBits := eAxoCmPtp_StopBits#_1stopBits;
            {#ix-set:AttributeName = "<#Flow control#>"}
            FlowControl : eAxoCmPtp_FlowControl := eAxoCmPtp_FlowControl#NoFlowControl;
            {#ix-set:AttributeName = "<#Xon char#>"}
            XonChar	: CHAR;
            {#ix-set:AttributeName = "<#Xoff char#>"}
            XoffChar	: CHAR;
            {#ix-set:AttributeName = "<#Wait time [ms]#>"}
            WaitTime	: UINT;
            {#ix-set:AttributeName = "<#Mode#>"}
            Mode    :   eAxoCmPtp_Mode := eAxoCmPtp_Mode#FullDuplexRS232; 
            {#ix-set:AttributeName = "<#Linepreset#>"}
            LinePreset  :   eAxoCmPtp_LinePreset := eAxoCmPtp_LinePreset#NoInitialState;
            {#ix-set:AttributeName = "<#Break detection#>"}
            BreakDetection  :   eAxoCmPtp_BreakDetection := eAxoCmPtp_BreakDetection#deactivated;
        END_VAR 
    END_CLASS    
END_NAMESPACE


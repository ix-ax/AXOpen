NAMESPACE AXOpen.Components.Zebra.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoEA3600_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : AxoEA3600_HWIDs;
            {#ix-set:AttributeName = "<#Enable handshake#>"}
            HandshakeEnable : BOOL := TRUE;   // Use ACK handshake
            {#ix-set:AttributeName = "<#Enable fragments#>"}
            FragmentEnable : BOOL := TRUE;   // Accept fragmented payloads (>64B)
            {#ix-set:AttributeName = "<#Continous reading#>"}
            ContinuousReading : BOOL := FALSE;
        END_VAR 
    END_CLASS    
END_NAMESPACE


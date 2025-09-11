NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_SystemStatusBitDefinition
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#res_bit24#>"}
            res_bit24 : BOOL;   // bit24
            {#ix-set:AttributeName = "<#res_bit25#>"}
            res_bit25 : BOOL;   // bit25
            {#ix-set:AttributeName = "<#res_bit26#>"}
            res_bit26 : BOOL;   // bit26
            {#ix-set:AttributeName = "<#res_bit27#>"}
            res_bit27 : BOOL;   // bit27
            {#ix-set:AttributeName = "<#res_bit28#>"}
            res_bit28 : BOOL;   // bit28
            {#ix-set:AttributeName = "<#res_bit29#>"}
            res_bit29 : BOOL;   // bit29
            {#ix-set:AttributeName = "<#res_bit30#>"}
            res_bit30 : BOOL;   // bit30
            {#ix-set:AttributeName = "<#SetupChanged#>"}
            SetupChanged : BOOL;   // bit31
            {#ix-set:AttributeName = "<#InCycle#>"}
            InCycle : BOOL;   // bit16
            {#ix-set:AttributeName = "<#InCycle_No_AB#>"}
            InCycle_No_AB : BOOL;   // bit17
            {#ix-set:AttributeName = "<#OverTemp#>"}
            OverTemp : BOOL;   // bit18
            {#ix-set:AttributeName = "<#In_AfterBurst#>"}
            In_AfterBurst : BOOL;   // bit19
            {#ix-set:AttributeName = "<#In_Test#>"}
            In_Test : BOOL;   // bit20
            {#ix-set:AttributeName = "<#In_TestScan#>"}
            In_TestScan : BOOL;   // bit21
            {#ix-set:AttributeName = "<#MPC_Present#>"}
            MPC_Present : BOOL;   // bit22
            {#ix-set:AttributeName = "<#res_bit23#>"}
            res_bit23 : BOOL;   // bit23
            {#ix-set:AttributeName = "<#PowerOK#>"}
            PowerOK : BOOL;   // bit8
            {#ix-set:AttributeName = "<#MPC_Ready#>"}
            MPC_Ready : BOOL;   // bit9
            {#ix-set:AttributeName = "<#Ready#>"}
            Ready : BOOL;   // bit10
            {#ix-set:AttributeName = "<#Any_Fault#>"}
            Any_Fault : BOOL;   // bit11
            {#ix-set:AttributeName = "<#Overload#>"}
            Overload : BOOL;   // bit12
            {#ix-set:AttributeName = "<#Estop#>"}
            Estop : BOOL;   // bit13
            {#ix-set:AttributeName = "<#Online#>"}
            Online : BOOL;   // bit14
            {#ix-set:AttributeName = "<#In_Hold#>"}
            In_Hold : BOOL;   // bit15
            {#ix-set:AttributeName = "<#Good_Part#>"}
            Good_Part : BOOL;   // bit0
            {#ix-set:AttributeName = "<#Bad_Part#>"}
            Bad_Part : BOOL;   // bit1
            {#ix-set:AttributeName = "<#Suspect_Part#>"}
            Suspect_Part : BOOL;   // bit2
            {#ix-set:AttributeName = "<#CycleStartReject#>"}
            CycleStartReject : BOOL;   // bit3
            {#ix-set:AttributeName = "<#Amplitude_Regulation#>"}
            Amplitude_Regulation : BOOL;   // bit4
            {#ix-set:AttributeName = "<#Power_Regulation#>"}
            Power_Regulation : BOOL;   // bit5
            {#ix-set:AttributeName = "<#Trigger_Status#>"}
            Trigger_Status : BOOL;   // bit6
            {#ix-set:AttributeName = "<#US_Status#>"}
            US_Status : BOOL;   // bit7      
        END_VAR 
    END_CLASS
END_NAMESPACE

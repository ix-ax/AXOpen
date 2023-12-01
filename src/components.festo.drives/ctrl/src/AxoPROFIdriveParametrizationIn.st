USING AXOpen.Core;
USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoPROFIdriveParametrizationIn 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Enable#>"}
            Enable          :   BOOL;
            {#ix-set:AttributeName = "<#ReadWrite#>"}
            ReadWrite       :   BOOL;
            {#ix-set:AttributeName = "<#ParameterNo#>"}
            ParameterNo     :   INT;
            {#ix-set:AttributeName = "<#Subindex#>"}
            Subindex        :   INT;
            {#ix-set:AttributeName = "<#AxisNo#>"}
            AxisNo	        :   BYTE;
            {#ix-set:AttributeName = "<#HardwareId#>"}
            HardwareId	    :   WORD;    
            {#ix-set:AttributeName = "<#ValueWriteREAL#>"}
            ValueWriteREAL  :   REAL;
            {#ix-set:AttributeName = "<#ValueWriteLINT#>"}
            ValueWriteLINT  :   LINT;
            {#ix-set:AttributeName = "<#ValueWriteBOOL#>"}
            ValueWriteBOOL  :   BOOL;
        END_VAR
    END_CLASS
END_NAMESPACE
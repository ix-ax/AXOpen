USING AXOpen.Core;
USING Siemens.Simatic.S71500.DistributedIO;

NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoPROFIdriveParametrizationOut 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#ValueReadREAL#>"}
            ValueReadREAL  :   REAL;
            {#ix-set:AttributeName = "<#ValueReadLINT#>"}
            ValueReadLINT  :   LINT;
            {#ix-set:AttributeName = "<#ValueReadBOOL#>"}
            ValueReadBOOL  :   BOOL;
            {#ix-set:AttributeName = "<#Busy#>"}
            Busy	:   BOOL;
            {#ix-set:AttributeName = "<#Done#>"}
            Done	:   BOOL;
            {#ix-set:AttributeName = "<#Error#>"}
            Error	:   BOOL;
            {#ix-set:AttributeName = "<#ErrorId#>"}
            ErrorId :	DWORD;
        END_VAR

    END_CLASS
END_NAMESPACE
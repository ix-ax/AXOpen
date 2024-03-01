NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoData256 EXTENDS AXOpen.Core.AxoByteArray  
        VAR PUBLIC 
            Data : ARRAY [0..255] OF BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE

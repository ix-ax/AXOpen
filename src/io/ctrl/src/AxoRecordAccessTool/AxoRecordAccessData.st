NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoRecordAccessData EXTENDS AXOpen.Core.AxoByteArray  
        VAR PUBLIC 
            Data : ARRAY [0..255] OF BYTE;
        END_VAR 
    END_CLASS
END_NAMESPACE

NAMESPACE AXOpen.Components.Zebra.Vision
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoEA3600_ReadData EXTENDS AXOpen.Core.AxoByteArray  
        VAR PUBLIC 
            Data : ARRAY [0..1023] OF BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE

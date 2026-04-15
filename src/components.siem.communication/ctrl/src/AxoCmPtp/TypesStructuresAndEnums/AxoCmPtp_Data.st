NAMESPACE AXOpen.Components.Siem.Communication
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoCmPtp_Data EXTENDS AXOpen.Core.AxoByteArray  
        VAR PUBLIC 
            Data : ARRAY [0..1023] OF BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE
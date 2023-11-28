USING AXOpen.Components.Cognex.Vision.v_6_0_0_0;
USING AxoDataFramentsExchangeDocuExample;
USING AXOpen.Core;

NAMESPACE AxoByteArrayExample
    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-set:AttributeName = "Byte array type with 10 items"}
    {#ix-set:DisplayFormat = "hexadecimal"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoByteArray10 EXTENDS AXOpen.Core.AxoByteArray  
        VAR PUBLIC 
            Data : ARRAY [0..9] OF BYTE;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-set:AttributeName = "Byte array type with 20 items"}
    {#ix-set:DisplayFormat = "string"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoByteArray20 EXTENDS AXOpen.Core.AxoByteArray  
        VAR PUBLIC 
            Data : ARRAY [0..19] OF BYTE;
        END_VAR
    END_CLASS


    {S7.extern=ReadWrite}
    CLASS AxoByteArrayExampleContext EXTENDS AxoContext
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Byte array instance with 10 items"}
            MyArray10 : AxoByteArray10;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Byte array instance with 20 items"}
            MyArray20 : AxoByteArray20;

        END_VAR


        METHOD PROTECTED OVERRIDE Main   
            VAR
                _openCycleCount : ULINT;
                _i : INT;
            END_VAR
            
            _openCycleCount := THIS.OpenCycleCount();

            FOR _i := 0 TO 9 DO
                MyArray10.Data[_i] := TO_BYTE(_openCycleCount * TO_ULINT(_i + INT#1));
                MyArray20.Data[_i] := TO_BYTE(_openCycleCount / TO_ULINT(_i+ INT#1));
            END_FOR;
            FOR _i := 10 TO 19 DO
                MyArray20.Data[_i] := TO_BYTE(_openCycleCount / TO_ULINT(_i+ INT#1));
            END_FOR;

            IF _openCycleCount MOD ULINT#100 = ULINT#0 THEN
                MyArray10.ToggleDataChangedFlag();
                MyArray20.ToggleDataChangedFlag();
            END_IF;
        END_METHOD
    END_CLASS
END_NAMESPACE

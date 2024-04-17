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

    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-set:AttributeName = "Byte array type with 30 items"}
    {#ix-set:DisplayFormat = "string"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoByteArray30 EXTENDS AXOpen.Core.AxoByteArray  
        VAR PUBLIC 
            Data : ARRAY [0..29] OF BYTE;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS AxoByteArrayExampleContext EXTENDS AxoContext
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Byte array instance with 10 items"}
            {#ix-attr:[ReadOnly()]}
            MyArray10 : AxoByteArray10;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Byte array instance with 20 items"}
            {#ix-attr:[ReadOnly()]}
            MyArray20 : AxoByteArray20;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Byte array instance with 30 items"}
            MyArray30 : AxoByteArray30;
        END_VAR
        VAR PRIVATE
            _openCycleCount_PV : ULINT;
        END_VAR

        METHOD PROTECTED OVERRIDE Main   
            VAR
                _openCycleCount : ULINT;
                _i : INT;
            END_VAR
            
            _openCycleCount := THIS.OpenCycleCount();

            FOR _i := 0 TO 9 DO
                MyArray10.Data[_i] := TO_BYTE(_openCycleCount * TO_ULINT(_i + INT#1));
            END_FOR;

            IF _openCycleCount >= _openCycleCount_PV + ULINT#300 THEN
                FOR _i := 0 TO 19 DO
                    MyArray20.Data[_i] := TO_BYTE(_openCycleCount / TO_ULINT(_i+ INT#1));
                END_FOR;
            END_IF;


            IF _openCycleCount MOD ULINT#100 = ULINT#0 THEN
                MyArray10.ToggleDataChangedFlag();
                MyArray20.ToggleDataChangedFlag();
            END_IF;

            IF MyArray30.DataHasChanged() THEN
                FOR _i := 0 TO 19 DO
                    MyArray20.Data[_i] := MyArray30.Data[_i];
                END_FOR;
                MyArray20.ToggleDataChangedFlag();
                _openCycleCount_PV := _openCycleCount;
            END_IF;
        END_METHOD
    END_CLASS
END_NAMESPACE

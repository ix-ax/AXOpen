USING AXOpen.Core;

NAMESPACE AxoByteArrayExample
    //<AxoByteArrayTypeDeclaration>
    // Extend AxoByteArray and declare a Data array of the desired size.
    // DisplayFormat controls HMI rendering: "hexadecimal" or "string".
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
    //</AxoByteArrayTypeDeclaration>

    {S7.extern=ReadWrite}
    CLASS AxoByteArrayExampleContext EXTENDS AxoObject
        //<AxoByteArrayInstanceDeclaration>
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
        //</AxoByteArrayInstanceDeclaration>
        VAR PRIVATE
            _openCycleCount_PV : ULINT;
        END_VAR

        //<AxoByteArrayUsage>
        METHOD PUBLIC Execute
            VAR
                _openCycleCount : ULINT;
                _i : INT;
            END_VAR

            _openCycleCount := THIS.GetContext().OpenCycleCount();

            // Write byte values into array each cycle
            FOR _i := 0 TO 9 DO
                MyArray10.Data[_i] := TO_BYTE(_openCycleCount * TO_ULINT(_i + INT#1));
            END_FOR;

            // Periodic update of second array
            IF _openCycleCount >= _openCycleCount_PV + ULINT#300 THEN
                FOR _i := 0 TO 19 DO
                    MyArray20.Data[_i] := TO_BYTE(_openCycleCount / TO_ULINT(_i+ INT#1));
                END_FOR;
            END_IF;

            // ToggleDataChangedFlag signals HMI that data was updated
            IF _openCycleCount MOD ULINT#100 = ULINT#0 THEN
                MyArray10.ToggleDataChangedFlag();
                MyArray20.ToggleDataChangedFlag();
            END_IF;

            // DataHasChanged detects when HMI writes new values
            IF MyArray30.DataHasChanged() THEN
                FOR _i := 0 TO 19 DO
                    MyArray20.Data[_i] := MyArray30.Data[_i];
                END_FOR;
                MyArray20.ToggleDataChangedFlag();
                _openCycleCount_PV := _openCycleCount;
            END_IF;
        END_METHOD
        //</AxoByteArrayUsage>
    END_CLASS
END_NAMESPACE

USING AXOpen.Core;

NAMESPACE AxoBoolArrayExample
    //<AxoBoolArrayTypeDeclaration>
    // Extend AxoBoolArray and declare a Data array of the desired size.
    // The HMI renders each element as an individual bit indicator.
    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-set:AttributeName = "Bool array type with 8 items"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoBoolArray8 EXTENDS AXOpen.Core.AxoBoolArray
        VAR PUBLIC
            Data : ARRAY [0..7] OF BOOL;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-set:AttributeName = "Byte array type with 16 items"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoBoolArray16 EXTENDS AXOpen.Core.AxoBoolArray
        VAR PUBLIC
            Data : ARRAY [0..15] OF BOOL;
        END_VAR
    END_CLASS
    //</AxoBoolArrayTypeDeclaration>

    {S7.extern=ReadWrite}
    CLASS AxoBoolArrayExampleContext EXTENDS AxoObject
        //<AxoBoolArrayInstanceDeclaration>
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Bool array instance with 8 items"}
            MyArray8 : AxoBoolArray8;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Bool array instance with 16 items"}
            MyArray16 : AxoBoolArray16;
        END_VAR
        //</AxoBoolArrayInstanceDeclaration>

        //<AxoBoolArrayUsage>
        METHOD PUBLIC Execute
            VAR
                _openCycleCount : ULINT;
                _i : INT;
            END_VAR

            _openCycleCount := THIS.GetContext().OpenCycleCount();

            // Write boolean values into the array each cycle
            FOR _i := 0 TO 7 DO
                MyArray8.Data[_i] :=  THIS.RandomBool(_openCycleCount * TO_ULINT(_i + INT#1));
                MyArray16.Data[_i] := THIS.RandomBool(_openCycleCount / TO_ULINT(_i+ INT#1));
            END_FOR;
            FOR _i := 8 TO 15 DO
                MyArray16.Data[_i] := TO_BOOL(_openCycleCount / TO_ULINT(_i+ INT#1));
            END_FOR;

            // ToggleDataChangedFlag signals the HMI that data was updated
            IF _openCycleCount MOD ULINT#100 = ULINT#0 THEN
                MyArray8.ToggleDataChangedFlag();
                MyArray16.ToggleDataChangedFlag();
            END_IF;
        END_METHOD
        //</AxoBoolArrayUsage>

        METHOD PRIVATE RandomBool : BOOL
            VAR_INPUT
                value : ULINT;
            END_VAR
            IF value MOD ULINT#100 > ULINT#50 THEN
                RandomBool := TRUE;
            ELSE
                RandomBool := FALSE;
            END_IF;
        END_METHOD
    END_CLASS
END_NAMESPACE

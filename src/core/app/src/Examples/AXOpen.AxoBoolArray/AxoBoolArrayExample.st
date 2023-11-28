USING AXOpen.Core;

NAMESPACE AxoBoolArrayExample
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


    {S7.extern=ReadWrite}
    CLASS AxoBoolArrayExampleContext EXTENDS AxoContext
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Bool array instance with 8 items"}
            MyArray8 : AxoBoolArray8;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Bool array instance with 16 items"}
            MyArray16 : AxoBoolArray16;

        END_VAR


        METHOD PROTECTED OVERRIDE Main   
            VAR
                _openCycleCount : ULINT;
                _i : INT;
            END_VAR
            
            _openCycleCount := THIS.OpenCycleCount();

            FOR _i := 0 TO 7 DO
                MyArray8.Data[_i] :=  THIS.RandomBool(_openCycleCount * TO_ULINT(_i + INT#1));
                MyArray16.Data[_i] := THIS.RandomBool(_openCycleCount / TO_ULINT(_i+ INT#1));
            END_FOR;
            FOR _i := 8 TO 15 DO
                MyArray16.Data[_i] := TO_BOOL(_openCycleCount / TO_ULINT(_i+ INT#1));
            END_FOR;

            IF _openCycleCount MOD ULINT#100 = ULINT#0 THEN
                MyArray8.ToggleDataChangedFlag();
                MyArray16.ToggleDataChangedFlag();
            END_IF;
        END_METHOD

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

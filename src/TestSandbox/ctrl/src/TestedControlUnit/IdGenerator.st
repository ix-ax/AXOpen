NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;
    USING AXOpen.Cognex.Vision.v_6_0_0_0;


    // just prepared but not used -> reason -> Exist task not exist yet
    INTERFACE PUBLIC ITestIdGenerator
        METHOD GetSize : Int
        END_METHOD
        METHOD Increment : BOOL
        END_METHOD
        METHOD GetRootRecordName : STRING
        END_METHOD
        METHOD GetNext : STRING
        END_METHOD
        METHOD InitializeWithPrefix
            VAR_INPUT
                Prefix : STRING;
            END_VAR
        END_METHOD
    END_INTERFACE

    {#ix-attr:[RenderIgnore()]}
    CLASS PUBLIC TestIdGenerator
        EXTENDS AXOpen.Core.AxoObject
        IMPLEMENTS ITestIdGenerator
        // VAR  CONSTANT PUBLIC
        //     {#ix-attr:[RenderIgnore()]}
        //     MAX_SIZE : INT := 1000; (* Comment *)
        //     {#ix-attr:[RenderIgnore()]}
        //     ROOT_RECORD_NAME : STRING := 'process_set'; (* Comment *)
        // END_VAR 
        VAR
            {#ix-attr:[RenderIgnore()]}
            _Names : ARRAY[0..10] OF STRING;
            CurrentIndex : INT;
            LastId : STRING;
        END_VAR

        METHOD PUBLIC GetNext : STRING
            IF CurrentIndex < 0 THEN
                CurrentIndex := 0;
            END_IF;
            IF CurrentIndex > 10 THEN
                CurrentIndex := 0;
            END_IF;
            LastId := _Names[CurrentIndex];
            GetNext := LastId;
        END_METHOD

        METHOD PUBLIC Increment : BOOL
            CurrentIndex := CurrentIndex + 1;
            Increment := CurrentIndex <= 10;
        END_METHOD

        METHOD PUBLIC GetSize : INT
            GetSize := 10;
        END_METHOD

        METHOD PUBLIC GetRootRecordName : STRING
            GetRootRecordName := 'process_set';
        END_METHOD

        METHOD PUBLIC InitializeWithPrefix
            VAR_INPUT
                Prefix : STRING;
            END_VAR
            VAR
                index : INT := 0; (* LOCAL INDEX *)
            END_VAR
            THIS.CurrentIndex := 0;
            FOR index := 0 TO 10 BY 1 DO
                _Names[index] := Concat(Prefix, '_', ToString(index));
            END_FOR;
        END_METHOD
    END_CLASS

END_NAMESPACE

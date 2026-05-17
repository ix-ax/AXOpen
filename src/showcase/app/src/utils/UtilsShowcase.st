USING AXOpen.Core;

// Showcase examples for AXOpen.Utils — demonstrates AxoStringBuilder
// and CRC checksum functions.
NAMESPACE AXOpen.Showcase.Utils

    {S7.extern=ReadWrite}
    CLASS UtilsShowcase EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AxoObject;
            _utilsDoc : UtilsDoc;
            _automat : UtilsAutomat;
            _startExample : BOOL := FALSE;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            _utilsDoc.Run(_rootObject);
            _automat.Execute(_rootObject);

            IF _startExample THEN
                _automat.Invoke();
            END_IF;
        END_METHOD
    END_CLASS

    // Demonstrates string builder and CRC utility usage.
    {S7.extern=ReadWrite}
    CLASS PUBLIC UtilsDoc EXTENDS AXOpen.Core.AxoObject
        //<UtilsDeclarations>
        VAR PUBLIC
            _stringBuilder : AXOpen.Utils.AxoStringBuilder;
            _builtString : STRING[254];
            _crc8Result : BYTE;
            _crc16Result : WORD;
            _crc32Result : DWORD;
            _testInput : STRING[254] := 'Hello AXOpen';
            _intValue : INT := 42;
            _realValue : REAL := REAL#3.14;
        END_VAR
        //</UtilsDeclarations>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            //<StringBuilderUsage>
            // Build a composite string from multiple typed values.
            _stringBuilder.Clear();
            _stringBuilder.Append('Part ID: ');
            _stringBuilder.Append(_intValue);
            _stringBuilder.Append(' | Weight: ');
            _stringBuilder.Append(_realValue);
            _builtString := _stringBuilder.AsString();
            //</StringBuilderUsage>

            //<CrcUsage>
            // Calculate CRC checksums for data integrity verification.
            _crc8Result := AXOpen.Utils.AxoCRC_8(_testInput);
            _crc16Result := AXOpen.Utils.AxoCRC_16(_testInput);
            _crc32Result := AXOpen.Utils.AxoCRC_32(_testInput);
            //</CrcUsage>
        END_METHOD
    END_CLASS

    // Sequencer-based demonstration of utility operations.
    {#ix-set:AttributeName = "<#UTILS AUTOMAT#>"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC UtilsAutomat EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            Steps : ARRAY[0..50] OF AxoStep;
            _stringBuilder : AXOpen.Utils.AxoStringBuilder;
            _result : STRING[254];
            _crc16 : WORD;
        END_VAR

        METHOD OVERRIDE Main

            THIS.SequenceMode := eAxoSequenceMode#Cyclic;

            IF (Steps[0].Execute(THIS, TRUE, 'Build a string from multiple parts')) THEN
                _stringBuilder.Clear();
                _stringBuilder.Append('Batch-');
                _stringBuilder.Append(INT#2024);
                _stringBuilder.Append('-OK');
                _result := _stringBuilder.AsString();
                THIS.MoveNext();
            END_IF;

            IF (Steps[1].Execute(THIS, TRUE, 'Calculate CRC-16 of built string')) THEN
                _crc16 := AXOpen.Utils.AxoCRC_16(_result);
                THIS.MoveNext();
            END_IF;

            IF (Steps[2].Execute(THIS, TRUE, 'Build another string with REAL value')) THEN
                _stringBuilder.Clear();
                _stringBuilder.Append('Measurement: ');
                _stringBuilder.Append(REAL#98.6);
                _stringBuilder.Append(' mm');
                _result := _stringBuilder.AsString();
                THIS.MoveNext();
            END_IF;

            THIS.Close(Steps[3]);
        END_METHOD
    END_CLASS

END_NAMESPACE

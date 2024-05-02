USING AxUnit;
USING AXOpen.Utils;
USING System.Strings;

NAMESPACE AXOpen.Utils.Unit_Tests


    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoStringBuilder_UnitTests 
        VAR PROTECTED
            _sb : AxoStringBuilder;
         END_VAR    
 
        {Test}
        METHOD PUBLIC StringBuilderWillAppendText
            VAR
                wordsToAppend: ARRAY[0..8] OF STRING := ['Hello','how','are','you','doing','?','Fine','Thank','You'];
                expected : STRING;
                wordToAppend : STRING;
                i : INT;
                emptyString : STRING[254];
            END_VAR
            //arrange
            _sb.Clear();
            expected := '';
            
            //act
            FOR i := 0 TO 8 DO
                expected := CONCAT(expected,wordsToAppend[i],',');
                _sb.Append(CONCAT(wordsToAppend[i],','));
            END_FOR;

            //assert
            Assert.Equal(FALSE, _sb.AsString() = emptyString);
            Assert.Equal(FALSE, expected = emptyString);
            Assert.Equal(TRUE, expected = _sb.AsString());
        END_METHOD

        {Test}
        METHOD PUBLIC FluentApiWorks
            //arrange/act
            _sb.Clear().Append(1).Append(2).Append(3).Append(4).Clear().Append(1).Append(2).Append(3).Append(4);
 
            //assert
            Assert.Equal(FALSE, _sb.AsString() = '');
            Assert.Equal(TRUE, '1234' = _sb.AsString());
        END_METHOD

        {Test}
        METHOD PUBLIC ClearMethodWillAbandonWorkingString
            //arrange
            _sb.Clear();
            //act
            _sb.Append(1).Append(2).Append(3).Append(4);
            Assert.Equal(TRUE, '1234' = _sb.AsString());
            _sb.Clear();
            //assert
            Assert.Equal(TRUE, _sb.AsString() = '');
        END_METHOD

        {Test}
        METHOD PUBLIC WorksAsCSharpSb
            //arrange
            _sb.Clear();
            //act
            _sb.Append('One').Clear().Append('Two').Append('Three');
           //assert
           Assert.Equal(FALSE, _sb.AsString() ='');
           Assert.Equal(TRUE, 'TwoThree' = _sb.AsString());
       END_METHOD

    END_CLASS
END_NAMESPACE

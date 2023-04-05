USING AxUnit;
USING ix.core;
USING ix.framework.utils;
USING System.Strings;

NAMESPACE ix.core.IxUtilities_Tests


    {TestFixture}
    CLASS IxStringBuilder_UnitTests 
        VAR PROTECTED
            _sb : StringBuilder;
         END_VAR    
 
        {Test}
        METHOD PUBLIC StringBuilderWillAppendText
            VAR
                wordsToAppend: ARRAY[0..8] OF STRING := ['Hello','how','are','you','doing','?','Fine','Thank','You'];
                expected : STRING;
                wordToAppend : STRING;
                i : INT;
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
            Assert.NotEqual(_sb.AsString(),'');
            Assert.NotEqual(expected,'');
            Assert.Equal(expected, _sb.AsString());
        END_METHOD

        {Test}
        METHOD PUBLIC FluentApiWorks
            //arrange/act
            _sb.Clear().Append(1).Append(2).Append(3).Append(4).Clear().Append(1).Append(2).Append(3).Append(4);
 
            //assert
            Assert.NotEqual(_sb.AsString(),'');
            Assert.Equal('1234', _sb.AsString());
        END_METHOD

        {Test}
        METHOD PUBLIC ClearMethodWillAbandonWorkingString
            //arrange
            _sb.Clear();
            //act
            _sb.Append(1).Append(2).Append(3).Append(4);
            Assert.Equal('1234', _sb.AsString());
            _sb.Clear();
            //assert
            Assert.Equal(_sb.AsString(),'');
        END_METHOD

        {Test}
        METHOD PUBLIC WorksAsCSharpSb
            //arrange
            _sb.Clear();
            //act
            _sb.Append('One').Clear().Append('Two').Append('Three');
           //assert
           Assert.NotEqual(_sb.AsString(),'');
           Assert.Equal('TwoThree', _sb.AsString());
       END_METHOD

    END_CLASS
END_NAMESPACE

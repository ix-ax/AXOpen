USING AXOpen.Messaging;

NAMESPACE AXOpen.MessagingTests
    {TestFixture}
    CLASS AxoLoggerTest
        VAR
            _sut : AxoLogger;
        END_VAR    

        {Test}
        METHOD PUBLIC Log_should_log_info_message                    
            _sut.Log('this is info message', eLogLevel#Information);
            AxUnit.Assert.Equal(_sut.LogEntries[0].Message, 'this is info message');
            AxUnit.Assert.Equal(true, eLogLevel#Information = _sut.LogEntries[0].Level);
        END_METHOD
    END_CLASS    
END_NAMESPACE



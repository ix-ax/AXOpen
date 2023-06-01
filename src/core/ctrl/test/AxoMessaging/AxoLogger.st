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
            AxUnit.Assert.Equal(true, _sut.LogEntries[0].ToDequeue);            
        END_METHOD

        {Test}
        METHOD PUBLIC MinumuLevel_should_not_set_loggers_min_level            
            _sut.MinimumLevel(eLogLevel#Error);            
            AxUnit.Assert.Equal(true, eLogLevel#Error = _sut.MinLevel);            
        END_METHOD

        // {Test}
        // METHOD PUBLIC Log_should_not_log_message_when_min_level_set_higher    
        //     // _sut.MinimumLevel(eLogLevel#Error);        
        //     // _sut.Log('this is verbose message', eLogLevel#Verbose);
        //     // AxUnit.Assert.Equal(_sut.LogEntries[0].Message, '');
        //     // AxUnit.Assert.Equal(true, _sut.LogEntries[0].ToDequeue);
        //     // //AxUnit.Assert.Equal(true, eLogLevel#NoCat = _sut.LogEntries[0].Level);    
        //     AxUnit.Assert.Equal(TRUE, TRUE);        
        // END_METHOD
    END_CLASS    
END_NAMESPACE



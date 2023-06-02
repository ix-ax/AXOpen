USING AXOpen.Messaging;
USING AxUnit;

NAMESPACE AXOpen.MessagingTests
    {TestFixture}
    CLASS AxoLoggerTest
        VAR
            _sut : AxoLogger;
            _sender : AXOpen.Core.AxoObject;
        END_VAR    

        {Test}
        METHOD PUBLIC Log_should_log_info_message           
            _sut.MinimumLevel(eLogLevel#Information);                     
            _sut.Log('this is info message', eLogLevel#Information, _sender);
            AxUnit.Assert.Equal(_sut.LogEntries[_sut.Carret - 1].Message, 'this is info message');
            AxUnit.Assert.Equal(true, eLogLevel#Information = _sut.LogEntries[_sut.Carret - 1].Level);   
            AxUnit.Assert.Equal(true, _sut.LogEntries[_sut.Carret - 1].ToDequeue);            
        END_METHOD

        {Test}
        METHOD PUBLIC Log_should_log_info_message_2
            VAR 
                _message : STRING[80];
                _isInformation : BOOL;
                _isToDequeue : BOOL;
            END_VAR     
            _sut.MinimumLevel(eLogLevel#Verbose);                     
            _sut.Log('this is info message', eLogLevel#Information, _sender);
            _message := _sut.LogEntries[0].Message;
            _isInformation := eLogLevel#Information = _sut.LogEntries[0].Level;
            _isToDequeue := _sut.LogEntries[0].ToDequeue;

            Assert.Equal(_message, 'this is info message');
            Assert.Equal(true, _isInformation);   
            Assert.Equal(true, _sut.LogEntries[0].ToDequeue);            
        END_METHOD
        
        {Test}
        METHOD PUBLIC MinumuLevel_should_set_loggers_min_level            
            _sut.MinimumLevel(eLogLevel#Error);            
            Assert.Equal(true, eLogLevel#Error = _sut.MinLevel);            
        END_METHOD

        {Test}
        METHOD PUBLIC Log_should_not_log_message_when_min_level_set_higher    
            _sut.MinimumLevel(eLogLevel#Error);        
            _sut.Log('this is verbose message', eLogLevel#Verbose);
            Assert.Equal(_sut.LogEntries[0].Message, '');
            Assert.Equal(true, _sut.LogEntries[0].ToDequeue);
            Assert.Equal(true, eLogLevel#NoCat = _sut.LogEntries[0].Level);                
        END_METHOD
    END_CLASS    
END_NAMESPACE



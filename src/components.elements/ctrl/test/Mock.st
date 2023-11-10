USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;
NAMESPACE AxoIO.Tests
    CLASS INTERNAL AxoRtcMock IMPLEMENTS IAxoRtc
        VAR PRIVATE 
            _NowUTC : LDATE_AND_TIME;
        END_VAR
    
        METHOD INTERNAL SetNowUTC : LDATE_AND_TIME
            VAR_INPUT
                Set :  LDATE_AND_TIME;
            END_VAR;
            _NowUTC := Set;
        END_METHOD
    
        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            NowUTC := _NowUTC;
        END_METHOD        
    END_CLASS  
    
    CLASS INTERNAL AxoLoggerMock IMPLEMENTS AXOpen.Logging.IAxoLogger
        VAR PUBLIC
           
        END_VAR
        
        /// <summary>
        /// Log method that captures a message, logging level, and the sender of the log.
        /// </summary>
        /// <param name="_message">The message to be logged.</param>
        /// <param name="_level">The severity level of the log.</param>
        /// <param name="_sender">The object that sends the log.</param>
        METHOD PUBLIC Log
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;  
                _sender : IAxoObject;              
            END_VAR
           
          ;
        END_METHOD
              
        /// <summary>
        /// Log method that captures a message and logging level.
        /// </summary>
        /// <param name="_message">The message to be logged.</param>
        /// <param name="_level">The severity level of the log.</param>
        METHOD PUBLIC Log
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;
            END_VAR
            
           ;
        END_METHOD

        /// <summary>
        /// Sets the minimum logging level to be captured by this logger.
        /// </summary>
        /// <param name="_level">The minimum log level.</param>
        /// <returns>Returns the instance of the logger.</returns>
        METHOD PUBLIC SetMinimumLevel : IAxoLoggerConfig
            VAR_INPUT
                _level : eLogLevel;
            END_VAR
            ;
        END_METHOD
    END_CLASS    
END_NAMESPACE

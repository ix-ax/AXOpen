USING AXOpen.Core;
USING AXOpen.Core;

NAMESPACE AXOpen.Logging
    /// <summary>
    /// AxoLogger class for logging purposes.
    /// This class implements IAxoLogger and IAxoLoggerConfig interfaces.
    /// </summary>
    CLASS PUBLIC AxoLogger IMPLEMENTS IAxoLogger, IAxoLoggerConfig
        VAR PUBLIC
            /// <summary>
            /// The current position in the log entries array.
            /// </summary>
            Carret : INT := 0;
            
            /// <summary>
            /// The minimum logging level to be captured by this logger.
            /// </summary>
            MinimumLevel : eLogLevel;
            
            /// <summary>
            /// The array containing log entries.
            /// </summary>
            LogEntries : ARRAY[0..100] OF AxoLogEntry;
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
           
            IF(_level >= THIS.MinimumLevel) THEN
                IF(Carret > 100) THEN
                    Carret := 0;
                END_IF;
                
                LogEntries[Carret].Message := _message;
                LogEntries[Carret].Level := _level;
                                
                IF(_sender <> NULL) THEN
                    LogEntries[Carret].Sender := _sender.GetIdentity();
                END_IF;
                
                LogEntries[Carret].ToDequeue := TRUE;
                Carret := Carret + 1;
            END_IF;
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
            
            IF(_level >= THIS.MinimumLevel) THEN
                IF(Carret > 100) THEN
                    Carret := 0;
                END_IF;
                
                LogEntries[Carret].Message := _message;
                LogEntries[Carret].Level := _level;
                LogEntries[Carret].ToDequeue := TRUE;
                Carret := Carret + 1;
            END_IF;
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
            THIS.MinimumLevel := _level;
            SetMinimumLevel := THIS;
        END_METHOD
    END_CLASS
END_NAMESPACE

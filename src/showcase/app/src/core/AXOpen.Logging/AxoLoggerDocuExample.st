USING AXOpen.Core;
USING AXOpen.Logging;

NAMESPACE AxoLoggerExamples
    {S7.extern=ReadWrite}
    CLASS Loggers EXTENDS AXOpen.Core.AxoObject
        //<DeclareLoggers>
        VAR PUBLIC
           LoggerOne : AXOpen.Logging.AxoLogger;
           LoggerTwo : AXOpen.Logging.AxoLogger;
           InnerObject : ContextLoggerInNestedObject;
        END_VAR
        //</DeclareLoggers>

        //<InjectLoggers>
        METHOD PUBLIC Execute
            // Logging to `LoggerOne`
            THIS.GetContext().InjectLogger(LoggerOne);
            // This will report only Errors and more severe
            THIS.GetContext().GetLogger().SetMinimumLevel(eLogLevel#Error);
            THIS.GetContext().GetLogger().Log('Here I am logging an error.', eLogLevel#Error);
            THIS.GetContext().GetLogger().Log('Here I am logging an infomation.', eLogLevel#Information);

            // Logging to `LoggerTwo`
            THIS.GetContext().InjectLogger(LoggerTwo);
            // This will report all messages from Infomation level and more severe
            THIS.GetContext().GetLogger().SetMinimumLevel(eLogLevel#Information);
            THIS.GetContext().GetLogger().Log('Here I am logging an error.', eLogLevel#Error);
            THIS.GetContext().GetLogger().Log('Here I am logging an infomation.', eLogLevel#Information);

            // Logging from inner object
            InnerObject.Run(THIS);
            InnerObject.Foo();
        END_METHOD
        //</InjectLoggers>

        METHOD LogLevelExamples
        //<LogLevels>
            // Available log levels (from least to most severe):
            THIS.GetContext().GetLogger().Log('Verbose trace message', eLogLevel#Verbose, THIS);
            THIS.GetContext().GetLogger().Log('Debug diagnostic info', eLogLevel#Debug, THIS);
            THIS.GetContext().GetLogger().Log('Informational message', eLogLevel#Information, THIS);
            THIS.GetContext().GetLogger().Log('Warning: approaching limit', eLogLevel#Warning, THIS);
            THIS.GetContext().GetLogger().Log('Error occurred in process', eLogLevel#Error, THIS);
            THIS.GetContext().GetLogger().Log('Fatal: system shutdown', eLogLevel#Fatal, THIS);
        //</LogLevels>

        //<SetMinimumLevel>
            // SetMinimumLevel filters out messages below the threshold.
            // Only messages at or above this level are captured.
            THIS.GetContext().GetLogger().SetMinimumLevel(eLogLevel#Warning);
            // After this call, Verbose/Debug/Information messages are discarded.
            // Only Warning, Error, and Fatal messages are logged.
        //</SetMinimumLevel>

        //<LogWithSender>
            // Log with sender — records the object identity for traceability
            THIS.GetContext().GetLogger().Log('Cycle timeout detected', eLogLevel#Error, THIS);
            // The sender's identity (from GetIdentity()) is stored in the log entry
        //</LogWithSender>

        //<LogWithMessageCode>
            // Log with message code — enables structured log lookup
            THIS.GetContext().GetLogger().Log('Drive fault', eLogLevel#Error, THIS, ULINT#1001);
            // MessageCode can be used by .NET side to look up detailed descriptions
        //</LogWithMessageCode>
        END_METHOD
    END_CLASS


    //<UseLoggerFromInnerObject>
    {S7.extern=ReadWrite}
    CLASS ContextLoggerInNestedObject EXTENDS AxoObject
        METHOD PUBLIC Foo
            THIS.GetContext().GetLogger().Log('Loggin on context logger', eLogLevel#Error, THIS);
        END_METHOD
    END_CLASS
    //</UseLoggerFromInnerObject>
END_NAMESPACE

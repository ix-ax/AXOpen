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

USING AXOpen.Core;
USING AXOpen.Logging;

NAMESPACE AxoLoggerExamples
    CLASS Loggers EXTENDS AXOpen.Core.AxoContext
        //<DeclareLoggers>  
        VAR PUBLIC
           LoggerOne : AXOpen.Logging.AxoLogger;
           LoggerTwo : AXOpen.Logging.AxoLogger;
           InnerObject : ContextLoggerInNestedObject;
        END_VAR    
        //</DeclareLoggers>    

        //<InjectLoggers> 
        METHOD PROTECTED OVERRIDE Main                              
            // Logging to `LoggerOne`
            THIS.InjectLogger(LoggerOne);  
            // This will report only Errors and more severe
            THIS.GetLogger().SetMinimumLevel(eLogLevel#Error);
            THIS.GetLogger().Log('Here I am logging an error.', eLogLevel#Error);                     
            THIS.GetLogger().Log('Here I am logging an infomation.', eLogLevel#Information);
           
            // Logging to `LoggerTwo`
            THIS.InjectLogger(LoggerTwo);
            // This will report all messages from Infomation level and more severe
            THIS.GetLogger().SetMinimumLevel(eLogLevel#Information);
            THIS.GetLogger().Log('Here I am logging an error.', eLogLevel#Error);
            THIS.GetLogger().Log('Here I am logging an infomation.', eLogLevel#Information);
            
            // Logging from inner object
            InnerObject.Initialize(THIS);
            InnerObject.Foo();
        END_METHOD            
        //</InjectLoggers> 
    END_CLASS    
    

    //<UseLoggerFromInnerObject>
    CLASS ContextLoggerInNestedObject EXTENDS AxoObject        
        METHOD PUBLIC Foo
            THIS.GetContext().GetLogger().Log('Loggin on context logger', eLogLevel#Error, THIS);
        END_METHOD    
    END_CLASS
    //</UseLoggerFromInnerObject>
END_NAMESPACE

USING AXOpen.Core;
USING AXOpen.Core;
NAMESPACE AXOpen.Logging              
    INTERFACE PUBLIC IAxoLogger                 
        METHOD Log 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;
                _sender : IAxoObject;
            END_VAR                         
        END_METHOD                
        
        METHOD Log 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;                
            END_VAR                         
        END_METHOD      
    END_INTERFACE

    INTERFACE IAxoLoggerConfig
        METHOD SetMinimumLevel : IAxoLoggerConfig
            VAR_INPUT
                _level : eLogLevel;  
            END_VAR            
        END_METHOD
    END_INTERFACE
END_NAMESPACE
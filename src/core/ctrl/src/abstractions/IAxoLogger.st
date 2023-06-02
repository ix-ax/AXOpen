USING AXOpen.Core;
USING AXOpen.Core;
NAMESPACE AXOpen.Messaging   
    
    TYPE PUBLIC
        eLogLevel : INT (NoCat := 0, Verbose := 1, Debug  := 2, Information  := 3, Warning  := 4, Error  := 5, Fatal  := 6) := NoCat;
    END_TYPE
    
    INTERFACE PUBLIC IAxoLogger                 
        METHOD Log 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;
                _sender : IAxoObject;
            END_VAR                         
        END_METHOD                
    END_INTERFACE

    INTERFACE IAxoLoggerConfig
        METHOD MinimumLevel : IAxoLoggerConfig
            VAR_INPUT
                _level : eLogLevel;  
            END_VAR            
        END_METHOD
    END_INTERFACE
END_NAMESPACE
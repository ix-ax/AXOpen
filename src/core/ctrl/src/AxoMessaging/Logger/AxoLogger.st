USING AXOpen.Core;
USING AXOpen.Messaging;

NAMESPACE AXOpen.Messaging    
    CLASS PUBLIC LogEntry
        VAR PUBLIC            
            Message : STRING[80];
            Level : eLogLevel; 
            Sender : ULINT;                
            ToDequeue : BOOL;       
        END_VAR             
    END_CLASS

    CLASS PUBLIC AxoLogger IMPLEMENTS IAxoLogger, IAxoLoggerConfig 
        VAR PUBLIC
            LogEntries : ARRAY[0..100] OF LogEntry; 
            Carret : INT := 0;
            MinLevel : eLogLevel;
        END_VAR
        
        METHOD PUBLIC Log 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel := eLogLevel#Information;
                _sender : IAxoObject;
            END_VAR 
            
            IF(_level >= MinLevel) THEN
                RETURN;
            END_IF;    

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
        END_METHOD
        
        METHOD PUBLIC MinimumLevel : IAxoLoggerConfig
            VAR_INPUT
                _level : eLogLevel;  
            END_VAR   
            THIS.MinLevel := _level; 
            MinimumLevel := THIS;
        END_METHOD
    END_CLASS
END_NAMESPACE
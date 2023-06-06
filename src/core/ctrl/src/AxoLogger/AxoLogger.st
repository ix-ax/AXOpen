USING AXOpen.Core;
USING AXOpen.Messaging;

NAMESPACE AXOpen.Logging    
    CLASS PUBLIC AxoLogger IMPLEMENTS IAxoLogger, IAxoLoggerConfig 
        VAR PUBLIC           
            Carret : INT := 0;
            MinimumLevel : eLogLevel;
            LogEntries : ARRAY[0..100] OF LogEntry; 
        END_VAR
        
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

        METHOD PUBLIC SetMinimumLevel : IAxoLoggerConfig
            VAR_INPUT
                _level : eLogLevel;  
            END_VAR               
            THIS.MinimumLevel := _level; 
            SetMinimumLevel := THIS;
        END_METHOD
    END_CLASS
END_NAMESPACE
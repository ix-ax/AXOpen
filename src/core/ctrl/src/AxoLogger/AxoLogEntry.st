NAMESPACE AXOpen.Logging
    CLASS PUBLIC LogEntry
        VAR PUBLIC            
            Message : STRING[80];
            Level : eLogLevel; 
            Sender : ULINT;                
            ToDequeue : BOOL;       
        END_VAR             
    END_CLASS
END_NAMESPACE
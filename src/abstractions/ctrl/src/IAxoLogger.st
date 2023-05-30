USING AXOpen.Core;
USING AXOpen.Core;
NAMESPACE AXOpen.Messaging   
    
    TYPE
        eLogLevel : (Verbose, Debug, Information, Warning, Error, Fatal) := Information;
    END_TYPE

    INTERFACE PUBLIC IAxoLogger                 
        METHOD Log 
            VAR_INPUT
                _message : STRING[254];
                _level : eLogLevel;
                _sender : IAxoObject;
            END_VAR                         
        END_METHOD        
    END_INTERFACE
END_NAMESPACE
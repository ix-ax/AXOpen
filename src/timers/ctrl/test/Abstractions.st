USING AxUnit;
USING AXOpen.Timers;
USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Rtm;

NAMESPACE AXOpen.Timers_tests


    {S7.extern=ReadWrite}
    CLASS INTERNAL _NULL_LOGGER IMPLEMENTS IAxoLogger                   
        METHOD PUBLIC Log 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;
                _sender : IAxoObject;
            END_VAR   
            ;         
        END_METHOD   
               
        METHOD PUBLIC Log 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;             
            END_VAR
            ;                         
        END_METHOD 
        
        METHOD PUBLIC SetMinimumLevel : IAxoLoggerConfig
            VAR_INPUT
                _level : eLogLevel;  
            END_VAR 
            ;           
        END_METHOD
    END_CLASS    

    {S7.extern=ReadWrite}
    CLASS INTERNAL AxoRtmMock IMPLEMENTS IAxoRtm
        VAR PRIVATE 
            _elapsed : LTIME;
        END_VAR

        METHOD INTERNAL SetElapsed : LDATE_AND_TIME
            VAR_INPUT
                Set :  LTIME;
            END_VAR;
            _elapsed := Set;
        END_METHOD

        METHOD PUBLIC Elapsed : LTIME
            Elapsed := _elapsed;
        END_METHOD        
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS INTERNAL TestContext IMPLEMENTS IAxoContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
            _rtc :  IAxoRtc;
            _rtm :  IAxoRtm;
         END_VAR       
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;
        END_METHOD

        METHOD PUBLIC ClosedCycleCount : ULINT
            ClosedCycleCount := _closeCounter;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT            
            _identityCounter := _identityCounter + ULINT#1;
            CreateIdentity := _identityCounter;
        END_METHOD         

        METHOD PUBLIC GetRtc : IAxoRtc ; 
            GetRtc := _rtc;
        END_METHOD

        METHOD PUBLIC InjectRtc
             VAR_INPUT Rtc : IAxoRtc; 
            END_VAR ;

            _rtc := Rtc;
        END_METHOD

        VAR PRIVATE
            NULL_LOGGER : _NULL_LOGGER;
        END_VAR    
        METHOD PUBLIC GetLogger : AXOpen.Logging.IAxoLogger GetLogger := NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : AXOpen.Logging.IAxoLogger; END_VAR ; END_METHOD

    
        METHOD PUBLIC GetRtm : IAxoRtm GetRtm := _rtm; END_METHOD
        METHOD PUBLIC InjectRtm VAR_INPUT inRtm : IAxoRtm; END_VAR _rtm := inRtm; END_METHOD
    
        METHOD PUBLIC IsValid : BOOL
            IsValid := TRUE;
        END_METHOD
    END_CLASS      
END_NAMESPACE

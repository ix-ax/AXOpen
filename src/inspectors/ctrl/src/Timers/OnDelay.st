USING AXOpen.Core;

NAMESPACE AXOpen.Timers
    // CLASS OnDelay
    //     VAR            
    //         _timeBase : LINT := LINT#10;
    //         _timeBaseTickCounter : INT;
    //         _previousSignalStatus : BOOL;            
    //         _timeasint : LINT;            
    //     END_VAR
        

    //     METHOD PUBLIC Delay : BOOL
    //         VAR_INPUT               
    //             Signal : BOOL;
    //             TimeDelay : TIME;
    //         END_VAR    

    //         IF(Signal AND NOT _previousSignalStatus) THEN
    //             _timeasint := TO_LINT(TimeDelay);
    //             _timeBaseTickCounter := 0;
    //         END_IF;    


    //         _timeBaseTickCounter := _timeBaseTickCounter + 1;
    //         Delay := TO_TIME((_timeBaseTickCounter * _timeBase)) >= TimeDelay;
            
    //         _previousSignalStatus := Signal;
    //     END_METHOD    

    // END_CLASS
    
    CLASS OnDelayContext
        VAR PUBLIC
            output : BOOL;
        END_VAR    
        VAR             
          _startTime : LDATE_AND_TIME;
          _previousSignalStatus : BOOL;        
        END_VAR
        

        METHOD PUBLIC Delay : BOOL
            VAR_INPUT 
                Context : IAxoContext;              
                Signal : BOOL;
                TimeDelay : LTIME;
            END_VAR    
           
            IF(Context = NULL) THEN RETURN; END_IF;

            IF(Signal AND NOT THIS._previousSignalStatus) THEN
                THIS._startTime := Context.GetRtc().NowUTC();
            END_IF;    

            Delay := (THIS._startTime - Context.GetRtc().NowUTC()) >= TimeDelay;
            output := Delay;
            THIS._previousSignalStatus := Signal;
        END_METHOD    


        METHOD PUBLIC Delay : BOOL
            VAR_INPUT 
                Parent : IAxoObject;              
                Signal : BOOL;
                TimeDelay : LTIME;
            END_VAR    
           
            IF(Parent = NULL) THEN RETURN; END_IF;

            IF(Signal AND NOT THIS._previousSignalStatus) THEN
                THIS._startTime := Parent.GetContext().GetRtc().NowUTC();
            END_IF;    

            Delay := (THIS._startTime - Parent.GetContext().GetRtc().NowUTC()) >= TimeDelay;
            output := Delay;
            THIS._previousSignalStatus := Signal;
        END_METHOD    
    END_CLASS
END_NAMESPACE
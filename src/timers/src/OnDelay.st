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
            elapsedTime : LTIME;
        END_VAR    

        VAR PRIVATE           
          _startTime : LDATE_AND_TIME;
          _previousSignalStatus : BOOL;  
          _currentTimeDiff : LTIME;
          
        END_VAR
        

        METHOD PUBLIC OnDelay : BOOL
            VAR_INPUT 
                Context : IAxoContext;              
                inSignal : BOOL;
                TimeDelay : LTIME;
            END_VAR    
           
            IF(Context = NULL) THEN RETURN; END_IF;

            IF(inSignal AND NOT THIS._previousSignalStatus) THEN
                THIS._startTime := Context.GetRtc().NowUTC();
            END_IF;    

            // if input signal was turned off and previous signal was true, that means output must by false, we do not need to compute time
            // let's afterwards restore timer to default values
            IF(NOT inSignal AND THIS._previousSignalStatus) THEN
                OnDelay := FALSE;
                output := OnDelay;
                THIS.Restore();
                elapsedTime := _currentTimeDiff;
                RETURN;
            END_IF;    


            _currentTimeDiff := Context.GetRtc().NowUTC() - THIS._startTime ;

            OnDelay := _currentTimeDiff >= TimeDelay;
            output := OnDelay;
            elapsedTime :=  _currentTimeDiff;
            THIS._previousSignalStatus := inSignal;
        END_METHOD    

        //LDT#1980-01-23-13:14:33.123456
        // LTIME#13:14:3.45;
        METHOD PUBLIC Restore
            //_startTime := LDT#0;

            _previousSignalStatus := FALSE;
            _currentTimeDiff := LTIME#0s;
            _startTime := LDATE_AND_TIME#1970-01-01-00:00:00.000;

        END_METHOD   
        // METHOD PUBLIC Delay : BOOL
        //     VAR_INPUT 
        //         Parent : IAxoObject;              
        //         Signal : BOOL;
        //         TimeDelay : LTIME;
        //     END_VAR    
           
        //     IF(Parent = NULL) THEN RETURN; END_IF;

        //     IF(Signal AND NOT THIS._previousSignalStatus) THEN
        //         THIS._startTime := Parent.GetContext().GetRtc().NowUTC();
        //     END_IF;    

        //     Delay := (THIS._startTime - Parent.GetContext().GetRtc().NowUTC()) >= TimeDelay;
        //     output := Delay;
        //     THIS._previousSignalStatus := Signal;
        // END_METHOD    
    END_CLASS
END_NAMESPACE
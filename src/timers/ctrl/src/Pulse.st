USING AXOpen.Core;

NAMESPACE AXOpen.Timers
    
    
    CLASS PulseTimer
        VAR PUBLIC
            output : BOOL;
            elapsedTime : LTIME;
        END_VAR    

        VAR PRIVATE           
          _startTime : LDATE_AND_TIME;
          _previousSignalStatus : BOOL;  
          _currentTimeDiff : LTIME;
          
        END_VAR
        
        METHOD PUBLIC Pulse : BOOL
            VAR_INPUT 
                Parent : IAxoObject;              
                inSignal : BOOL;
                PulseLenght : LTIME;
            END_VAR    
            Pulse := THIS.Pulse(Parent.GetContext(), inSignal, PulseLenght);
        END_METHOD    

        ///<summary>W
        /// Pulse timer, which output is TRUE only during time counting.
        /// Counting of timer start on RISING edge.
        /// 
        /// If IN is FALSE, the outputs are FALSE or 0. 
        /// As soon as IN becomes TRUE, Q also becomes TRUE and remains TRUE for the pulse duration PT. 
        /// As long as Q is TRUE, the time is incremented in milliseconds in ET, until the value reaches PT. 
        /// The value then remains constant. 
        /// The output Q remains TRUE until the pulse duration has elapsed, irrespective of the state of the input IN. 
        /// Q therefore supplies a signal over the interval specified in PT.
        ///</summary>
        METHOD PUBLIC Pulse : BOOL
            VAR_INPUT 
                Context : IAxoContext;              
                inSignal : BOOL;
                PulseLenght : LTIME;
            END_VAR    
           
            IF(Context = NULL) THEN RETURN; END_IF;

            // always, when input is false, outputs are false
            IF(NOT inSignal ) THEN
                Pulse := FALSE;
                output := Pulse;
                elapsedTime := _currentTimeDiff;
                RETURN;
            END_IF;     

            // start counting on RISING edge
            // output is true during counting period
            IF(inSignal AND NOT THIS._previousSignalStatus) THEN
                THIS._startTime := Context.GetRtc().NowUTC();
            END_IF;    

            
            _currentTimeDiff := Context.GetRtc().NowUTC() - THIS._startTime ;

            // output is true, if counting is in progress and time diff is smaller then pulse length
            Pulse := _currentTimeDiff < PulseLenght;
            output := Pulse;
            elapsedTime :=  _currentTimeDiff;
            THIS._previousSignalStatus := inSignal;

        END_METHOD    

  
        METHOD PUBLIC Restore
            _previousSignalStatus := FALSE;
            _currentTimeDiff := LTIME#0s;
            _startTime := LDATE_AND_TIME#1970-01-01-00:00:00.000;
        END_METHOD 

 
    END_CLASS
END_NAMESPACE
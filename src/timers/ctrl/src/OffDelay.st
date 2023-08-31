USING AXOpen.Core;

NAMESPACE AXOpen.Timers
 
    ///<summary>
    /// OffDelayTimer class, which contains OffDelay method representing timer.
    /// Counting of timer start on FALLING edge.
    ///</summary>
    CLASS OffDelayTimer
        VAR PUBLIC
            output : BOOL;
            elapsedTime : LTIME;
        END_VAR    

        VAR PRIVATE           
          _startTime : LDATE_AND_TIME;
          _previousSignalStatus : BOOL;  
          _currentTimeDiff : LTIME;
          _isCounting : BOOL;
          
        END_VAR
        
        ///<summary>
        /// OffDelay timer, which output it FALSE when time delay is counted, otherwise always returns TRUE.
        /// Counting of timer start on FALLING edge.
        /// IAxoObject is used to acquire context automatically.
        ///</summary>
        METHOD PUBLIC OffDelay : BOOL
            VAR_INPUT 
                Parent : IAxoObject;              
                inSignal : BOOL;
                TimeDelay : LTIME;
            END_VAR    
            OffDelay := THIS.OffDelay(Parent.GetContext(), inSignal, TimeDelay);
        END_METHOD

        

        ///<summary>
        /// OffDelay timer, which output it FALSE when time delay is counted, otherwise always returns TRUE.
        /// Counting of timer start on FALLING edge.
        /// IAxoContext is directly required.
        /// 
        /// When IN is TRUE, Q is TRUE and ET is 0.
        /// As soon as IN becomes FALSE, the time will begin to be counted in milliseconds in ET until its value is equal to that of PT. 
        /// It will then remain constant. 
        /// Q is FALSE when IN is FALSE and ET is equal to PT. 
        /// Otherwise it is TRUE. 
        /// Thus, Q has a falling edge when the time indicated in PT in milliseconds has run out. 
        ///</summary>
        METHOD PUBLIC OffDelay : BOOL
            VAR_INPUT 
                Context : IAxoContext;              
                inSignal : BOOL;
                TimeDelay : LTIME;
            END_VAR    
           
            IF(Context = NULL) THEN RETURN; END_IF;


            // if input signal is off and previous signal was off, no edge detected, return output false
            IF(NOT inSignal AND NOT THIS._previousSignalStatus) THEN
                OffDelay := FALSE;
                output := OffDelay;
                THIS._previousSignalStatus := inSignal;
                RETURN;
            END_IF; 

            // RISING EDGE detected, set output to true
            // if inSignal is true, and previous is false, set output to true
            // restore timer on rising edge
            IF(inSignal AND NOT THIS._previousSignalStatus) THEN
                THIS.Restore();
                OffDelay := TRUE;
                output := OffDelay;
                THIS._previousSignalStatus := inSignal;
                RETURN;
            END_IF;    

           // FALLING EDGE  detected start timer counting
           // start computing on falling edge (if actual signal is false, but previous was true)
            IF(NOT inSignal AND THIS._previousSignalStatus) THEN
                THIS._startTime := Context.GetRtc().NowUTC();
                _isCounting := TRUE;
            END_IF;    


            // if timer is counting, compute difference and watch for end of timer
            IF(THIS._isCounting) THEN
                _currentTimeDiff := Context.GetRtc().NowUTC() - THIS._startTime ;
                // if timer passed, set output to false
                OffDelay := NOT (_currentTimeDiff >= TimeDelay);
                output := OffDelay;
                elapsedTime :=  _currentTimeDiff;
                THIS._previousSignalStatus := inSignal;

            ELSE
                // here timer is not counting, therefore output will be set to true
                // I get here, when previousSignal was true, and actual signal is still true
                OffDelay := TRUE;
                output := OffDelay;
                elapsedTime :=  LTIME#0s;
                THIS._previousSignalStatus := inSignal;
            END_IF;   
        
        END_METHOD    

        ///<summary>
        /// Method for restoring default values of timer.
        ///</summary>
        METHOD PUBLIC Restore
            _isCounting := FALSE;
            _previousSignalStatus := FALSE;
            _currentTimeDiff := LTIME#0s;
            _startTime := LDATE_AND_TIME#1970-01-01-00:00:00.000;
        END_METHOD   
      
    END_CLASS
END_NAMESPACE
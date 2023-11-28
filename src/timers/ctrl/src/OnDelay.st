USING AXOpen.Core;

NAMESPACE AXOpen.Timers
    
    ///<summary>
    /// OnDelayTimer class, which contains OnDelay method representing timer.
    /// Counting of timer start on RISING edge.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS OnDelayTimer
        VAR PUBLIC
            output : BOOL;
            elapsedTime : LTIME;
        END_VAR    

        VAR PRIVATE           
          _startTime : LDATE_AND_TIME;
          _previousSignalStatus : BOOL;  
          _currentTimeDiff : LTIME;
          
        END_VAR
        
        ///<summary>
        /// OnDelay timer, which output is TRUE when time delay is counted, otherwise always returns FALSE.
        /// Counting of timer start on RISING edge.
        ///</summary>
        METHOD PUBLIC OnDelay : BOOL
            VAR_INPUT 
                Parent : IAxoObject;              
                inSignal : BOOL;
                TimeDelay : LTIME;
            END_VAR 

            OnDelay := THIS.OnDelay(Parent.GetContext(), inSignal, TimeDelay);
        END_METHOD

        /// LOGIC OF ONDELAY TIMER
        /// If IN is FALSE, Q is FALSE and ET is 0.
        /// As soon as IN becomes TRUE, the time will begin to be counted in milliseconds in ET until its value is equal to PT. 
        /// It will then remain constant. Q is TRUE when IN is TRUE and ET is equal to PT. 
        /// Otherwise it is FALSE. 
        /// Thus, Q has a rising edge when the time indicated in PT in milliseconds has run out.

        ///<summary>
        /// OnDelay timer, which output is TRUE when time delay is counted, otherwise always returns FALSE.
        /// Counting of timer start on RISING edge.
        ///</summary>
        METHOD PUBLIC OnDelay : BOOL            
            VAR_INPUT                               
                Context : IAxoContext;
                inSignal : BOOL;
                TimeDelay : LTIME;
            END_VAR    
           
            IF(Context = NULL) THEN RETURN; END_IF;

            // beggining, if all is turn off, return false
            IF(NOT inSignal AND NOT THIS._previousSignalStatus) THEN
                OnDelay := FALSE;
                output := OnDelay;
                elapsedTime := LTIME#0s;
                RETURN;
            END_IF;     

            // start counting on RISING edge
            // start counting when inputSignal is true and previous signal was not set
            IF(inSignal AND NOT THIS._previousSignalStatus) THEN
                THIS._startTime := Context.GetRtc().NowUTC();
            END_IF;    

            // FALLING edge detected
            // if input signal is turned off and previous signal was true, that means output must by false, we do not need to compute time
            // let's afterwards restore timer to default values
            IF(NOT inSignal AND THIS._previousSignalStatus) THEN
                THIS.Restore();
                THIS._previousSignalStatus := inSignal;
                OnDelay := FALSE;
                output := OnDelay;
                elapsedTime := _currentTimeDiff;
                
                RETURN;
            END_IF;    


            _currentTimeDiff := Context.GetRtc().NowUTC() - THIS._startTime ;
            OnDelay := _currentTimeDiff >= TimeDelay;
            output := OnDelay;
            elapsedTime :=  _currentTimeDiff;
            THIS._previousSignalStatus := inSignal;

        END_METHOD    

        ///<summary>
        /// Method for restoring default values of timer.
        ///</summary>
        METHOD PUBLIC Restore
            _previousSignalStatus := FALSE;
            _currentTimeDiff := LTIME#0s;
        END_METHOD 
      
    END_CLASS
END_NAMESPACE

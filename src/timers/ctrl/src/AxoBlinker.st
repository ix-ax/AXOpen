USING AXOpen.Core;

NAMESPACE AXOpen.Timers
 
    ///<summary>
    /// Provides periodic on/off switcher.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS AxoBlinker
        VAR PUBLIC
            output : BOOL;
        END_VAR    

        VAR PRIVATE           
            _onTimer    : OnDelayTimer;
            _offTimer   : OnDelayTimer;

            _nextExpectedCycle : ULINT;
            _state : INT;
        END_VAR
        
        ///<summary>
        /// Provides periodic on/off switcher.
        ///</summary>
        METHOD PUBLIC Blink : BOOL
            VAR_INPUT 
                Parent : IAxoObject;              
                ///<summary>
                /// Time duration for on duty output.
                ///</summary>
                inOnTime : TIME;
                ///<summary>
                /// Time duration for off duty output.
                ///</summary>
                inOffTime : TIME;
            END_VAR   

            IF Parent = NULL THEN
                RETURN;
            END_IF;
           
            Blink := THIS.Execute(Parent,inOnTime,inOffTime);
        END_METHOD

        ///<summary>
        /// Provides periodic on/off switcher.
        ///</summary>
        METHOD PUBLIC Blink : BOOL
            VAR_INPUT 
                Context : IAxoContext;              
                ///<summary>
                /// Time duration for on duty output.
                ///</summary>
                inOnTime : TIME;
                ///<summary>
                /// Time duration for off duty output.
                ///</summary>
                inOffTime : TIME;
            END_VAR   

            IF Context = NULL THEN
                RETURN;
            END_IF;
            
            Blink := THIS.Execute(Context,inOnTime,inOffTime);
        END_METHOD
      
        METHOD PRIVATE Execute : BOOL
            VAR_INPUT 
                Context : IAxoContext;              
                inOnTime : TIME;
                inOffTime : TIME;
            END_VAR   

            IF( Context.OpenCycleCount() <>  _nextExpectedCycle) THEN
                _state := 0;
            END_IF;
            
            _nextExpectedCycle := Context.OpenCycleCount() + ULINT#1;
            
            IF(_state = 0) THEN
                _offTimer.OnDelay(Context := Context, inSignal := FALSE, TimeDelay := T#0S);	
                 _onTimer.OnDelay(Context := Context, inSignal := FALSE, TimeDelay := T#0S);
                _state := 1;
            END_IF;		
            
            IF(_state = 1) THEN
                output := TRUE;
                IF(_onTimer.OnDelay(Context := Context ,inSignal := TRUE, TimeDelay:=inOnTime)) THEN
                    _state := 2;
                    RETURN;
                END_IF;
            END_IF;		
            
            IF(_state = 2) THEN	
                output := FALSE;
                IF(_offTimer.OnDelay(Context := Context, inSignal := TRUE, TimeDelay:=inOffTime)) THEN
                    _state := 0;
                END_IF;		
            END_IF;
        END_METHOD
  
        METHOD PRIVATE Execute : BOOL
            VAR_INPUT 
                Parent : IAxoObject;              
                inOnTime : TIME;
                inOffTime : TIME;
            END_VAR   

            IF( Parent.GetContext().OpenCycleCount() <>  _nextExpectedCycle) THEN
                _state := 0;
            END_IF;
            
            _nextExpectedCycle := Parent.GetContext().OpenCycleCount() + ULINT#1;
            
            IF(_state = 0) THEN
                _offTimer.OnDelay(Parent := Parent,inSignal := FALSE, TimeDelay:=T#0S);	
                _onTimer.OnDelay(Parent := Parent,inSignal := FALSE, TimeDelay:=T#0S);
                _state := 1;
            END_IF;		
            
            IF(_state = 1) THEN
                output := TRUE;
                IF(_onTimer.OnDelay(Parent:= Parent ,inSignal := TRUE, TimeDelay:=inOnTime)) THEN
                    _state := 2;
                    RETURN;
                END_IF;
            END_IF;		
            
            IF(_state = 2) THEN	
                output := FALSE;
                IF(_offTimer.OnDelay(Parent := Parent,inSignal := TRUE, TimeDelay:=inOffTime)) THEN
                    _state := 0;
                END_IF;		
            END_IF;
        END_METHOD
  

        ///<summary>
        /// Method for restoring default values of blinker.
        ///</summary>
        METHOD PUBLIC Restore
            _onTimer.Restore();
            _offTimer.Restore();
            _nextExpectedCycle := ULINT#0;
            _state := INT#0;
            output := FALSE;
        END_METHOD   
    END_CLASS
END_NAMESPACE

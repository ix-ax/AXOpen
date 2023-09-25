# AxOpen.Timers.OffDelayTimer

`OffDelayTimer` class contains `OffDelay` method, where logic of OffDelayTimer is implemented. `OffDelay` method has following input:

```C#
VAR_INPUT 
    Parent : IAxoObject; // or IAxoContext, parent provides RTC implementation              
    inSignal : BOOL; // starts timer with falling edge, resets timer with rising edge
    TimeDelay : LTIME; // time to pass, before output is set
END_VAR 
```

The OffDelay method returns `output`, which *is FALSE, `TimeDelay` seconds after falling edge of `inSignal` is detected*.

The `OffDelayTimer` have also public variables which can be used to access timer results:

```C#
VAR PUBLIC
    output : BOOL; // is FALSE, TimeDelay seconds after falling edge of inSignal is detected
    elapsedTime : LTIME; // elapsed time 
END_VAR 
```


The LOGIC of `OffDelayTimer` is following:


When `inSignal` is TRUE, `output` is TRUE and `elapsedTime` is 0. As soon as `inSignal` becomes FALSE, the time will begin to be counted in `elapsedTime` until its value is equal to that of `TimeDelay`. It will then remain constant. The `output` is FALSE when `inSignal` is FALSE and `elapsedTime` is equal to `TimeDelay`. Otherwise it is TRUE. Thus, `output` has a falling edge when the time indicated in `TimeDelay` has run out.


Example usage of `OffDelay` timer:

```
USING AXOpen.Timers;


VAR 
    _signal : BOOL; // input signal, which is set somewhere in application
    _testTimerOffDelay: AXOpen.Timers.OffDelayTimer; // timer instance
    _testTimeDelay: LTIME := LTIME#5s; // time delay
END_VAR  

// call OffDelay method somewhere in application
// THIS must type of IAxoObject
_testTimerOffDelay.OffDelay(THIS, _signal, _testTimeDelay);

// check for output
IF(_testTimerOffDelay.output) THEN

    // handle result

ENDIF;
```
# AxOpen.Timers.OnDelayTimer

`OnDelayTimer` class contains `OnDelay` method, where logic of OnDelayTimer is implemented. `OnDelay` method has following input:

```C#
VAR_INPUT 
    Parent : IAxoObject; // or IAxoContext, parent provides RTC implementation              
    inSignal : BOOL; // starts timer with rising edge, resets timer with falling edge 
    TimeDelay : LTIME; // time to pass, before output is set
END_VAR 
```

The OnDelay method returns `output`, which *is TRUE, `TimeDelay` seconds after rising edge of `inSignal` is detected*.

The `OnDelayTimer` have also public variables which can be used to access timer results:

```C#
VAR PUBLIC
    output : BOOL; // is TRUE, TimeDelay seconds after rising edge of inSignal is detected.
    elapsedTime : LTIME; // elapsed time 
END_VAR 
```


The LOGIC of `OnDelayTimer` is following:

If `inSignal` is FALSE, `output` is FALSE and `elapsedTime` is 0. As soon as `input` becomes TRUE, the time will begin to be counted in `elapsedTime` until its value is equal to `TimeDelay`. It will then remain constant. The `output` is TRUE when `inSignal` is TRUE and `elapsedTime` is equal to `TimeDelay`. Otherwise it is FALSE. Thus, `output` has a rising edge when the time indicated in `TimeDelay` has run out.

Example usage of `OnDelay` timer:

```
USING AXOpen.Timers;


VAR 
    _signal : BOOL; // input signal
    _testTimerOnDelay: AXOpen.Timers.OnDelayTimer; // timer instance
    _testTimeDelay: LTIME := LTIME#5s; // time delay
END_VAR  

// call OnDelay method somewhere in application
// THIS must type of IAxoObject
_testTimerOnDelay.OnDelay(THIS, _signal, _testTimeDelay);

// check for output
IF(_testTimerOnDelay.output) THEN

    // handle result

ENDIF;
```
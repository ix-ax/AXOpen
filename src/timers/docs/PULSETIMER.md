# AxOpen.Timers.PulseTimer

`PulseTimer` class contains `Pulse` method, where logic of PulseTimer is implemented. `Pulse` method has following input:

```C#
VAR_INPUT 
    Parent : IAxoObject; // or IAxoContext, parent provides RTC implementation              
    inSignal : BOOL; // Trigger for start of the pulse signal
    PulseLenght : LTIME; // the length of the pulse signal
END_VAR 
```

The Pulse timer returns output, which *is TRUE only during time counting*. It creates pulses with a defined pulse duration.


The `PulseTimer` have also public variables which can be used to access timer results:

```C#
VAR PUBLIC
    output : BOOL; // the pulse
    elapsedTime : LTIME; // the current phase of the pulse
END_VAR 
```


The LOGIC of `PulseTimer` is following:

If `inSignal` is FALSE, the `output` is FALSE and `elapsedTime` is 0. As soon as `inSignal` becomes TRUE, `output` also becomes TRUE and remains TRUE for the pulse duration `PulseLength`. As long as `output` is TRUE, the time is incremented in `elapsedTime`, until the value reaches PT. The value then remains constant. The `output` remains TRUE until the pulse duration has elapsed, irrespective of the state of the input `inSignal`. The `output` therefore supplies a signal over the interval specified in `PulseLength`.

Example usage of `Pulse` timer:

```
USING AXOpen.Timers;


VAR 
    _signal : BOOL; // input signal, which is set somewhere in application
    _testTimerPulse: AXOpen.Timers.PulseTimer; // timer instance
    _testPulseLength: LTIME := LTIME#5s; // pulse length
END_VAR  

// call Pulse method somewhere in application
// THIS must type of IAxoObject
_testTimerPulse.Pulse(THIS, _signal, _testPulseLength);

// check for output
IF(_testTimerPulse.output) THEN

    // handle result

ENDIF;
```
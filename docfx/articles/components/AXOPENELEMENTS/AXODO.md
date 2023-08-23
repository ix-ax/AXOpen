## AXOpenElements.AxoDo

AxoDo is used for setting values of digital inputs.

### Example

```
//define variables
VAR
    _testDo : AXOpen.Elements.AxoDo;  
    _testInOutSignal : BOOL;  
END_VAR

// set manual control
_testDo.ActivateManualControl();
// run AxoDO logic on input/output signal
_testDo.Run(THIS, _testInOutSignal);
```

![AxoDo](~/images/axodo.gif)
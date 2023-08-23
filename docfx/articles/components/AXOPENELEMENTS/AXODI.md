## AXOpenElements.AxoDi

AxoDi is used for checking values of digital inputs.

### Example

```
//define variables
VAR
    _testDi : AXOpen.Elements.AxoDi;  
    _testsignal : BOOL;  
END_VAR

// set manual control
_testDi.ActivateManualControl();
_testsignal := TRUE;
// run AxoDI logic on input signal
_testDi.Run(THIS, _testsignal);

IF _testDi.IsTrue() THEN
    // handle signal on
ENDIF;

```

![AxoDi](~/images/axodi.gif)
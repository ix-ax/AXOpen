## AXOpenElements.AxoAo

AxoAo is used for setting analogue values. AxoAo un-scales input signal based on `SetPoint` anda values in `AxoAoConfig` class.


AxoAoConfig contains:
```
CLASS AxoAoConfig
    VAR PUBLIC

    // 	Lowest possible value of the raw input.										
    RawLow : DINT;
    
    // 	Highest possible value of the raw input.											
    RawHigh : DINT;
    

    // 	Lowest threshold of scaled value.
    // 	`RealLow` and `RealHigh` should represent the real range of an continuous input. 											
    RealLow  : REAL;
    
    // 	Highest threshold range of scaled value.
    // 	`RealLow` and `RealHigh` should represent the real range of an continuous input. 	 										
    RealHigh : REAL;

    //  Allows simple adjustment of the calculated value multiplying the value by factor of `Gain`.								 	 										
    Gain : REAL := REAL#1.0;
    // 	Allows simple adjustment of the calculated value by adding `Offset` value.			
					 	 											
    Offset : REAL := REAL#0.0;
    END_VAR
END_CLASS
```

### Example

```
//define variables
VAR
    _testAo : AXOpen.Elements.AxoAo;  
    _testAoOutput : DINT;
END_VAR

// set manual control
_testAo.ActivateManualControl();
// run AxoAo logic on input/output signal
_testAo.Run(THIS, _testAoOutput);

```

![AxoAo](~/images/axoao.gif)
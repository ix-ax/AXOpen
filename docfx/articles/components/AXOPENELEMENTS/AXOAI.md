## AXOpenElements.AxoAi

AxoAi is used for checking values of analogue inputs. AxoAi scales input signal based on values in `AxoAiConfig` class.


AxoAiConfig contains:
```
CLASS AxoAiConfig
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
    _testAi : AXOpen.Elements.AxoAi;  
    _testAiInput : DINT := DINT#10;  
END_VAR

// set manual control
_testAi.ActivateManualControl();
// run AxoDI logic on input signal
_testAi.Run(THIS, _testAiInput);

```

![AxoDi](~/images/axoai.gif)
USING AxUnit;
USING AXOpen.Elements;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoIO.Tests
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoAoTests 
        VAR 
            context : TestContext;
            _testAxoAo : AxoAo;
            _signal : DINT;
      
            _unscaledResult : DINT;
        END_VAR   


      

        {Test(required := 100, setVal := 100)}
        {Test(required := 50, setVal := 50)}
        {Test(required := 0, setVal := 0)}
        {Test(required := -50, setVal := -50)}
        {Test(required := -100, setVal := -100)}
        METHOD PUBLIC RoundedRawRoundedRealTest
            VAR_INPUT
                required : DINT;
                setVal : REAL;
            END_VAR

            context.Open();
            _signal := 0;

            _testAxoAo._config.RawLow := -100;
            _testAxoAo._config.RawHigh := 100;
            _testAxoAo._config.RealLow := -100;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 0;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
        
            AxUnit.Assert.Equal(TRUE, required = TO_DINT(_testAxoAo._unscaled));
            AxUnit.Assert.Equal(TRUE, _signal = required);

            context.Close();            

        END_METHOD

        {Test(required := 32767, setVal := 100, epsilon := 0)}
        {Test(required := REAL#16383.5, setVal := 50, epsilon := 1)}
        {Test(required := 0, setVal := 0, epsilon := 1)}

        METHOD PUBLIC UnsignedRawTest
            VAR_INPUT
                required : REAL;
                setVal : REAL;
                epsilon : DINT;
            END_VAR

            context.Open();
            _signal := 0;
            _unscaledResult := 0;
            _testAxoAo._config.RawLow := 0;
            _testAxoAo._config.RawHigh := 32767;
            _testAxoAo._config.RealLow := 0;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 0;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
            _unscaledResult := TO_DINT(_testAxoAo._status.Unscaled);

            AxUnit.Assert.Equal(TRUE, TO_REAL(_unscaledResult - epsilon) <= required AND required <= TO_REAL(_unscaledResult + epsilon));
            AxUnit.Assert.Equal(TRUE, _signal = TO_DINT(required));

            context.Close();            

        END_METHOD

        {Test(required := 32767, setVal := 100, epsilon := 0)}
        {Test(required := 0, setVal := 50, epsilon := 1)}
        {Test(required := -32768, setVal := 0, epsilon := 1)}

        METHOD PUBLIC SignedRawTest
            VAR_INPUT
                required : REAL;
                setVal : REAL;
                epsilon : DINT;
            END_VAR

            context.Open();
            _signal := 0;
            _testAxoAo._status.Unscaled := 0;
            _testAxoAo._config.RawLow := -32768;
            _testAxoAo._config.RawHigh := 32767;
            _testAxoAo._config.RealLow := 0;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 0;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
            _unscaledResult := TO_DINT(_testAxoAo._status.Unscaled);
            AxUnit.Assert.Equal(TRUE, TO_REAL(_unscaledResult - epsilon) <= required AND required <= TO_REAL(_unscaledResult + epsilon));
            AxUnit.Assert.Equal(TRUE, _signal = TO_DINT(required));

            context.Close();            

        END_METHOD

        {Test(required := 32767, setVal := 100, epsilon := 0)}
        {Test(required := REAL#16383.5, setVal := 75, epsilon := 1)}
        {Test(required := 0, setVal := 50, epsilon := 0)}
        METHOD PUBLIC UnSignedRawTest_RealOffsetTest
            VAR_INPUT
                required : REAL;
                setVal : REAL;
                epsilon : DINT;
            END_VAR

            context.Open();
            _signal := 0;
            _unscaledResult := 0;
            _testAxoAo._config.RawLow := 0;
            _testAxoAo._config.RawHigh := 32767;
            _testAxoAo._config.RealLow := 50;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 0;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
            _unscaledResult := TO_DINT(_testAxoAo._status.Unscaled);
            AxUnit.Assert.Equal(TRUE, TO_REAL(_unscaledResult - epsilon) <= required AND required <= TO_REAL(_unscaledResult + epsilon));
            AxUnit.Assert.Equal(TRUE, _signal = TO_DINT(required));

            context.Close();            

        END_METHOD

        {Test(required := 32767, setVal := 100, epsilon := 0)}
        {Test(required := 0, setVal := 75, epsilon := 1)}
        {Test(required := -32768, setVal := 50, epsilon := 0)}
        METHOD PUBLIC SignedRawTest_RealOffsetTest
            VAR_INPUT
                required : REAL;
                setVal : REAL;
                epsilon : DINT;
            END_VAR

            context.Open();
            _signal := 0;
            _unscaledResult := 0;
            _testAxoAo._config.RawLow := -32768;
            _testAxoAo._config.RawHigh := 32767;
            _testAxoAo._config.RealLow := 50;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 0;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
            _unscaledResult := TO_DINT(_testAxoAo._status.Unscaled);
            AxUnit.Assert.Equal(TRUE, TO_REAL(_unscaledResult - epsilon) <= required AND required <= TO_REAL(_unscaledResult + epsilon));
            AxUnit.Assert.Equal(TRUE, _signal = TO_DINT(required));

            context.Close();            

        END_METHOD

        {Test(required := 32767, setVal := 100, epsilon := 0)}
        {Test(required := 16384, setVal := 0, epsilon := 2)}
        {Test(required := 0, setVal := -100, epsilon := 0)}
        METHOD PUBLIC UnsignedRawTest_RealSignedOffsetTest
            VAR_INPUT
                required : REAL;
                setVal : REAL;
                epsilon : DINT;
            END_VAR

            context.Open();
            _signal := 0;
            _unscaledResult := 0;
            _testAxoAo._config.RawLow := 0;
            _testAxoAo._config.RawHigh := 32767;
            _testAxoAo._config.RealLow := -100;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 0;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
            _unscaledResult := TO_DINT(_testAxoAo._status.Unscaled);
            AxUnit.Assert.Equal(TRUE, TO_REAL(_unscaledResult - epsilon) <= required AND required <= TO_REAL(_unscaledResult + epsilon));
            AxUnit.Assert.Equal(TRUE, _signal = TO_DINT(required));

            context.Close();            

        END_METHOD

        {Test(required := 32767, setVal := 100, epsilon := 0)}
        {Test(required := 0, setVal := 0, epsilon := 1)}
        {Test(required := -32768, setVal := -100, epsilon := 0)}
        METHOD PUBLIC SignedRawTest_RealSignedOffsetTest
            VAR_INPUT
                required : REAL;
                setVal : REAL;
                epsilon : DINT;
            END_VAR

            context.Open();
            _signal := 0;
            _unscaledResult := 0;
            _testAxoAo._config.RawLow := -32768;
            _testAxoAo._config.RawHigh := 32767;
            _testAxoAo._config.RealLow := -100;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 0;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
            _unscaledResult := TO_DINT(_testAxoAo._status.Unscaled);
            AxUnit.Assert.Equal(TRUE, TO_REAL(_unscaledResult - epsilon) <= required AND required <= TO_REAL(_unscaledResult + epsilon));
            AxUnit.Assert.Equal(TRUE, _signal = TO_DINT(required));

            context.Close();            

        END_METHOD

        {Test(required := REAL#32787.0, setVal := 100, epsilon := 0)}
        {Test(required := 16404, setVal := 0, epsilon := 1)}
        {Test(required := 20, setVal := -100, epsilon := 0)}
        METHOD PUBLIC UnSignedRawTest_RealSignedOffset_WithOffsetCorrectionTest
            VAR_INPUT
            
                required : REAL;
                setVal : REAL;
                epsilon : DINT;
            END_VAR

            context.Open();
            _signal := 0;
            _unscaledResult := 0;
            _testAxoAo._config.RawLow := 0;
            _testAxoAo._config.RawHigh := 32767;
            _testAxoAo._config.RealLow := -100;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 20;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
        
            _unscaledResult := TO_DINT(_testAxoAo._status.Unscaled);
            AxUnit.Assert.Equal(TRUE, TO_REAL(_unscaledResult - epsilon) <= required AND required <= TO_REAL(_unscaledResult + epsilon));
            AxUnit.Assert.Equal(TRUE, _signal = TO_DINT(required));

            context.Close();            

        END_METHOD

        {Test(required := REAL#32787.0, setVal := 100, epsilon := 0)}
        {Test(required := 16404, setVal := 0, epsilon := 1)}
        {Test(required := 20, setVal := -100, epsilon := 0)}
        METHOD PUBLIC SignedRawTest_RealSignedOffset_WithOffsetCorrectionTest
            VAR_INPUT
                required : REAL;
                setVal : REAL;
                epsilon : DINT;
            END_VAR

            context.Open();
            _signal := 0;
            _unscaledResult := 0;
            _testAxoAo._config.RawLow := 0;
            _testAxoAo._config.RawHigh := 32767;
            _testAxoAo._config.RealLow := -100;
            _testAxoAo._config.RealHigh := 100;
            _testAxoAo._config.Gain := 1;
            _testAxoAo._config.Offset := 20;

            _testAxoAo._requiredValue := setVal;
         

            _testAxoAo.Run(context.SignalParent, _signal);
        
            _unscaledResult := TO_DINT(_testAxoAo._status.Unscaled);
            AxUnit.Assert.Equal(TRUE, TO_REAL(_unscaledResult - epsilon) <= required AND required <= TO_REAL(_unscaledResult + epsilon));
            AxUnit.Assert.Equal(TRUE, _signal = TO_DINT(required));

            context.Close();            

        END_METHOD

    END_CLASS    
END_NAMESPACE

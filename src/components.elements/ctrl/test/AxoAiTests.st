USING AxUnit;
USING AXOpen.Elements;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoIO.Tests
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoAiTests 
        VAR 
            context : TestContext;
            _testAxoAi : AxoAi;
            _signal : DINT;
      
            _done : BOOL;
        END_VAR   


        {Test(signal := 100, required := 100)}
        {Test(signal := 50, required := 50)}
        {Test(signal := 0, required := 0)}
        {Test(signal := -50, required := -50)}
        {Test(signal := -100, required := -100)}
        METHOD PUBLIC RoundedRawRoundedReal
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := -100;
            _testAxoAi._config.RawHigh := 100;
            _testAxoAi._config.RealLow := -100;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.Run(context, _signal);
        
            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           

            context.Close();            
        
            
            
        END_METHOD

        {Test(signal := 32767, required := 100)}
        {Test(signal := 16384, required := 50)}
        {Test(signal := 0, required := 0)}
        METHOD PUBLIC UnsignedRawTest
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := 0;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := 0;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD

        {Test(signal := 32767, required := 100)}
        {Test(signal := 0, required := 50)}
        {Test(signal := -32768, required := 0)}
        METHOD PUBLIC SignedRawTest
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := -32768;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := 0;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD

        {Test(signal := 32767, required := 100)}
        {Test(signal := 16384, required := 75)}
        {Test(signal := 0, required := 50)}
        METHOD PUBLIC UnsignedRaw_RealOffsetTest
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := 0;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := 50;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD


        {Test(signal := 32767, required := 100)}
        {Test(signal := 0, required := 75)}
        {Test(signal := -32768, required := 50)}
        METHOD PUBLIC SignedRaw_RealOffsetTest
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := -32768;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := 50;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD

        {Test(signal := 32767, required := 100)}
        {Test(signal := 16384, required := 0)}
        {Test(signal := 0, required := -100)}
        METHOD PUBLIC UnsignedRaw_RealSignedOffsetTest
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := 0;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := -100;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD

        {Test(signal := 32767, required := 100)}
        {Test(signal := 0, required := 0)}
        {Test(signal := -32768, required := -100)}
        METHOD PUBLIC SignedRaw_RealSignedOffsetTest
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := -32768;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := -100;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD

        {Test(signal := 32767, required := 120)}
        {Test(signal := 16384, required := 20)}
        {Test(signal := 0, required := -80)}
        METHOD PUBLIC UnSignedRaw_RealSignedOffset_WithOffsetCorrectionTest
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := 0;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := -100;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 20;
            _signal := signal;

            _testAxoAi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD

        {Test(signal := 32767, required := 120)}
        {Test(signal := 0, required := 20)}
        {Test(signal := -32768, required := -80)}
        METHOD PUBLIC SignedRaw_RealSignedOffset_WithOffsetCorrectionTest
            VAR_INPUT
                signal : DINT;
                required : REAL;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := -32768;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := -100;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 20;
            _signal := signal;

            _testAxoAi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, TO_DINT(required) = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD

      

    END_CLASS    
END_NAMESPACE

USING AxUnit;
USING AXOpen.Elements;
USING AXOpen.Pneumatics;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoAi.Tests
    CLASS TestContext IMPLEMENTS AXOpen.Core.IAxoContext
        VAR
            _openCounter : ULINT;
            _closeCounter : ULINT; 
        END_VAR
              
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT
            ;
        END_METHOD

        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;
        END_METHOD

        METHOD PUBLIC GetRtc : AXOpen.Rtc.IAxoRtc
            ;
        END_METHOD

        METHOD PUBLIC InjectRtc
            VAR_INPUT
                Rtc : IAxoRtc;
            END_VAR

            ;
        END_METHOD

        METHOD PUBLIC GetLogger : IAxoLogger
            ;
        END_METHOD

        METHOD PUBLIC InjectLogger
            VAR_INPUT
                _logger : IAxoLogger;
            END_VAR

            ;
        END_METHOD
    END_CLASS
    {TestFixture}
    CLASS AxoTests 
        VAR 
            context : TestContext;
            _testAxoAi : AxoAi;
            _signal : DINT;
      
            _done : BOOL;
        END_VAR   

        {Test(signal := 100, required := 100, digit := 0)}
        {Test(signal := 50, required := 50, digit := 0)}
        {Test(signal := 0, required := 0, digit := 0)}
        {Test(signal := -50, required := -50, digit := 0)}
        {Test(signal := -100, required := -100, digit := 0)}
        METHOD PUBLIC RoundedRawRoundedReal
            VAR_INPUT
                signal : DINT;
                required : DINT;
                digit : DINT;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := -100;
            _testAxoAi._config.RawHigh := 100;
            _testAxoAi._config.RealLow := -100;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.AxoAiSignal(context, _signal);

        
            AxUnit.Assert.Equal(TRUE, required = TO_DINT(_testAxoAi._scaled));
           

            context.Close();            
        
            
            
        END_METHOD

        {Test(signal := 32767, required := 100, digit := 0)}
        {Test(signal := 16384, required := 50, digit := 2)}
        {Test(signal := 0, required := 0, digit := 0)}
        METHOD PUBLIC UnsignedRawTest
            VAR_INPUT
                signal : DINT;
                required : DINT;
                digit : DINT;
            END_VAR


            context.Open();
    
            _testAxoAi._config.RawLow := 0;
            _testAxoAi._config.RawHigh := 32767;
            _testAxoAi._config.RealLow := 0;
            _testAxoAi._config.RealHigh := 100;
            _testAxoAi._config.Gain := 1;
            _testAxoAi._config.Offset := 0;
            _signal := signal;

            _testAxoAi.AxoAiSignal(context, _signal);

            AxUnit.Assert.Equal(TRUE, required = TO_DINT(_testAxoAi._scaled));
           
            context.Close();            
        
            
            
        END_METHOD

        // {Test}
        // METHOD PUBLIC CheckForSignalStatusFalse
   
        //     context.Open();
        //     _signal := FALSE;
        //     _testAxoDi.AxoDiSignal(context,_signal);

        //     AxUnit.Assert.Equal(FALSE, _testAxoDi.IsTrue());
        //     AxUnit.Assert.Equal(TRUE, _testAxoDi.IsFalse());

        //     context.Close();            
        
            
            
        // END_METHOD

    END_CLASS    
END_NAMESPACE

USING AxUnit;
USING AXOpen.Elements;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoIO.Tests
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDiTests 
        VAR 
            context : TestContext;
            _testAxoDi : AxoDi;
            _signal : BOOL;
      
            _done : BOOL;
        END_VAR   

        {Test}
        METHOD PUBLIC CheckForSignalStatusTrue
   
            context.Open();
            _signal := TRUE;
            _testAxoDi.Run(context, _signal);

            AxUnit.Assert.Equal(TRUE, _testAxoDi.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testAxoDi.IsFalse());

            context.Close();            
        
            
            
        END_METHOD

        {Test}
        METHOD PUBLIC CheckForSignalStatusFalse
   
            context.Open();
            _signal := FALSE;
            _testAxoDi.Run(context,_signal);

            AxUnit.Assert.Equal(FALSE, _testAxoDi.IsTrue());
            AxUnit.Assert.Equal(TRUE, _testAxoDi.IsFalse());

            context.Close();            
        
            
            
        END_METHOD

    END_CLASS    
END_NAMESPACE

USING AxUnit;
USING AXOpen.Elements;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoIO.Tests
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDoTests 
        VAR 
            context : TestContext;
            _testAxoDo : AxoDo;
            _signal : BOOL;
      
            _done : BOOL;
        END_VAR   

        {Test}
        METHOD PUBLIC SetSignalOn
   
            context.Open();
            _testAxoDo.Run(context.SignalParent,_signal);
            _testAxoDo.Set();

            AxUnit.Assert.Equal(TRUE, _testAxoDo.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testAxoDo.IsFalse());

            context.Close();            
          
        END_METHOD

        {Test}
        METHOD PUBLIC SetSignalOff
   
            context.Open();
            _signal := TRUE;
            _testAxoDo.Run(context.SignalParent,_signal);
            _testAxoDo.Reset();

            AxUnit.Assert.Equal(FALSE, _testAxoDo.IsTrue());
            AxUnit.Assert.Equal(TRUE, _testAxoDo.IsFalse());

            context.Close();            
        
            
            
        END_METHOD

    END_CLASS    
END_NAMESPACE

USING AxUnit;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Rtm;
USING AXOpen.Core.Dummies;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
NAMESPACE AXOpen.Core
    NAMESPACE AxoRemoteTasksTests        
    
    {S7.extern=ReadWrite}
   CLASS TestContext EXTENDS MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS     


    {S7.extern=ReadWrite}
    CLASS TestObject EXTENDS MockAxoObject     
        VAR PUBLIC 
            _messenger : AxoMessenger;
        END_VAR
    END_CLASS    
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS IxRemoteTaskTests 
        VAR PROTECTED
           _context : TestContext;
           _rootObject : MockAxoObject;
           myTask : AxoRemoteTask;
           expState:  eAxoTaskState;
           actState:  eAxoTaskState;
           initValue : ULINT;           
        END_VAR    

        METHOD PRIVATE Initialize
            _rootObject.InitializeWithContext(_context);
            myTask.Run(_rootObject);           
        END_METHOD     

        METHOD Equal : BOOL
            VAR_INPUT
                 expected:  eAxoTaskState;
                 actual:  eAxoTaskState;
            END_VAR
            Equal := expected = actual;
        END_METHOD 

        VAR
            _contextClean   :   TestContext;
            _rtm            :   AXOpen.Core.Dummies.MockAxoRtm;
            _rtc            :   AXOpen.Core.Dummies.MockAxoRtc;
            myTaskClean     :   AxoRemoteTask;
            expStateClean   :   eAxoTaskState;
            actStateClean   :   eAxoTaskState;
            initValueClean  :   ULINT;           
         END_VAR    
    


         
        {TestSetup}
        METHOD PUBLIC TestSetup
            _context := _contextClean;
            _rtm.SetElapsed(LTIME#2s);
            _context.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            _context.InjectRtc(_rtc);
            myTask := myTaskClean;
            expState    :=  expStateClean;
            actState    :=  actStateClean;
            initValue   :=  initValueClean;
        END_METHOD

        {TestTearDown}
        METHOD PUBLIC TestTearDown
            ;
        END_METHOD

        {FixtureSetup}
        METHOD PUBLIC FixtureSetup
            ;
        END_METHOD

        {FixtureTearDown}
        METHOD PUBLIC FixtureTearDown
            ;
        END_METHOD

        {Test}
        METHOD PUBLIC should_invoke_remote_task             
            // Arrange
            THIS.Initialize();
            _context.Open();
            myTask.Invoke();
            Assert.Equal(TRUE, myTask.Execute());             
            _context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC should_invoke_remote_task_and_set_context_counter
            VAR
                _contexCounter : ULINT;
            END_VAR;    
            // Arrange
            THIS.Initialize();
            _context.Open();
            _contexCounter := _context.OpenCycleCount();
            //Act/Assert
            myTask.Invoke();
            Assert.Equal(FALSE, _contexCounter = myTask.GetStartSignature());
            Assert.Equal(TRUE, myTask.Execute());  
            Assert.Equal(_contexCounter, myTask.GetStartSignature());                
            _context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC should_complete_remote_task
            VAR
                _contexCounter : ULINT;
            END_VAR;    
            // Arrange
            THIS.Initialize();
            myTask.IsInitialized := TRUE; //initialization from .net side
            _context.Open();
            _contexCounter := _context.OpenCycleCount();
            //Act/Assert
            myTask.Invoke();   //to kicking state       
            Assert.Equal(TRUE, myTask.Execute());  //to busy state 
            Assert.Equal(TRUE, myTask.IsBusy());             

            _context.Close();
            _context.Open();

            myTask.SetDoneSignature();
            myTask.Execute();
            Assert.Equal(TRUE, THIS.Equal(eAxoTaskState#Done, myTask.Status));

            Assert.Equal(FALSE, myTask.Execute());     

            _context.Close();
        END_METHOD

    END_CLASS
    END_NAMESPACE
END_NAMESPACE

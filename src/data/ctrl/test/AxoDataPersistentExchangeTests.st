USING AXOpen.Core;
USING AXOpen.Rtc;
USING AxUnit;

NAMESPACE AXOpen.Data 
    NAMESPACE AxoDataPersistentExchangeTests
        {S7.extern=ReadWrite}
        CLASS TestContext EXTENDS Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD                 
        END_CLASS

        // {S7.extern=ReadWrite}
        // CLASS AxoRtcMock IMPLEMENTS IAxoRtc
        //     VAR PRIVATE 
        //         _NowUTC : LDATE_AND_TIME;
        //     END_VAR
    
        //     METHOD INTERNAL SetNowUTC : LDATE_AND_TIME
        //         VAR_INPUT
        //             Set :  LDATE_AND_TIME;
        //         END_VAR;
        //         _NowUTC := Set;
        //     END_METHOD
    
        //     METHOD PUBLIC NowUTC : LDATE_AND_TIME
        //         NowUTC := _NowUTC;
        //     END_METHOD    
        // END_CLASS


        {TestFixture}
        {S7.extern=ReadWrite}
        CLASS AxoDataExchange_Tests
            VAR PROTECTED
                _context : TestContext;
                _rtc : AXOpen.Core.Dummies.MockAxoRtc;
                _rtm : AXOpen.Core.Dummies.MockAxoRtm;

                _dataExchange : AxoDataPersistentExchange;

                caller_1 : AxoObject;
                caller_2 : AxoObject;
            END_VAR    
        

            VAR
                _contextBlank : TestContext;                
                _dataExchangeBlank : AxoDataPersistentExchange;
                caller_1Blank : AxoObject;
                caller_2Blank : AxoObject;          
            END_VAR    
    
            {TestSetup}
            METHOD PUBLIC TestSetup
            // Will be called before MyTest_A AND before Test_B are executed
                _context := _contextBlank;
                _rtm.SetElapsed(LTIME#2s);
                _context.InjectRtm(_rtm);
                _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
                _context.InjectRtc(_rtc);
                _dataExchange := _dataExchangeBlank;
                caller_1 := caller_1Blank;
                caller_2 := caller_2Blank;
            END_METHOD
        
            {TestTearDown}
            METHOD PUBLIC TestTearDown
            // Will be called after MyTest_A AND before Test_B where executed
                ;
            END_METHOD
        
            {FixtureSetup}
            METHOD PUBLIC FixtureSetup
            // Will be called once before the Tests are executed
                ;
            END_METHOD
        
            {FixtureTearDown}
            METHOD PUBLIC FixtureTearDown
            // Will be called after the Tests where executed
                ;
            END_METHOD

            METHOD PUBLIC RunContextMultipleltipleTimes
                VAR_INPUT
                    cycleCount : INT;
                end_var
                VAR
                    iteration : INT;
                END_VAR
                FOR iteration := 0 TO cycleCount DO
                    _context.Open();
                    _dataExchange.Run(_context);
                    _context.Close();
                END_FOR;
            END_METHOD


            {Test}
            METHOD PUBLIC InvokeRead_NotInvoked_WhenFirstReadDoneNotFinish
                VAR
                    IdentifierCaller_1 : STRING[254];

                    ResultCaller_1 :BOOL;

                    startTime : LDATE_AND_TIME;
                END_VAR    
                // initializtion
                startTime := LDATE_AND_TIME#2023-11-11-11:11:11.111;
                _rtc.SetNowUTC(startTime);
                _context.InjectRtc(_rtc);
                caller_1.Initialize(_context);
                caller_1.Identity :=  _context.CreateIdentity();
                IdentifierCaller_1 := '1';
                _dataExchange.Operation.IsInitialized := true; //simulate intit from .net side

                // needs to simulate + 2 cycles
                THIS.RunContextMultipleltipleTimes(3);
                
                 //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); 
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = '');
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();

                //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); 
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = '');
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();

                //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); 
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = '');
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();
            END_METHOD

            {Test}
            METHOD PUBLIC InvokeRead_Invoked_WhenFirstReadDoneFinish
                VAR
                    IdentifierCaller_1 : STRING[254];

                    ResultCaller_1 :BOOL;

                    startTime : LDATE_AND_TIME;
                END_VAR    
                // initializtion
                startTime := LDATE_AND_TIME#2023-11-11-11:11:11.111;
                _rtc.SetNowUTC(startTime);
                _context.InjectRtc(_rtc);
                caller_1.Initialize(_context);
                caller_1.Identity :=  _context.CreateIdentity();
                IdentifierCaller_1 := '1';
                _dataExchange.Operation.IsInitialized := true; //simulate intit from .net side

                // needs to simulate + 2 cycles
                THIS.RunContextMultipleltipleTimes(3);
                
                 //------------------------ INVOKE READ BLOCKED ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); 
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = '');
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();

               
                //------------------------ INVOKE READ ENABLED ------------------------

                _dataExchange.SetFirstReadDone(); // firs read done simulation

                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); // kicking
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();

                //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); // BUSY => INVOKED
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,TRUE);
  
                _context.Close();

            END_METHOD
            
            {Test}
            METHOD PUBLIC InvokeRead_NotInvoked_CallerHasNoIdentity
                VAR
                    IdentifierCaller_1 : STRING[254];

                    ResultCaller_1 :BOOL;

                    startTime : LDATE_AND_TIME;
                END_VAR    
                // initializtion
                startTime := LDATE_AND_TIME#2023-11-11-11:11:11.111;
                _rtc.SetNowUTC(startTime);
                _context.InjectRtc(_rtc);
                caller_1.Initialize(_context);
                caller_1.Identity := ulint#0;
                IdentifierCaller_1 := '1';
                _dataExchange.Operation.IsInitialized := true; //simulate intit from .net side
                _dataExchange.SetFirstReadDone(); 

                // needs to simulate + 2 cycles
                THIS.RunContextMultipleltipleTimes(3);
                
                 //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); 
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = '');
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();

                //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); 
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = '');
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();

                //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); 
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = '');
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();
            END_METHOD

            {Test}
            METHOD PUBLIC InvokeRead_Invoked_CallerHasIdentity
                VAR
                    IdentifierCaller_1 : STRING[254];

                    ResultCaller_1 :BOOL;

                    startTime : LDATE_AND_TIME;
                END_VAR    
                // initializtion
                startTime := LDATE_AND_TIME#2023-11-11-11:11:11.111;
                _rtc.SetNowUTC(startTime);
                _context.InjectRtc(_rtc);
                caller_1.Initialize(_context);
                caller_1.Identity :=  _context.CreateIdentity();
                IdentifierCaller_1 := '1';
                _dataExchange.Operation.IsInitialized := true; //simulate intit from .net side
                _dataExchange.SetFirstReadDone(); 

                // needs to simulate + 2 cycles
                THIS.RunContextMultipleltipleTimes(3);
                
                 //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); // kicking
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);

                _context.Close();

                //------------------------ INVOKE READ  ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsReady());
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); // BUSY => INVOKED
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,TRUE);

                _context.Close();

            END_METHOD

            {Test}
            METHOD PUBLIC ConcurentCall_Update_test
                VAR
                    IdentifierCaller_1 : STRING[254];
                    IdentifierCaller_2 : STRING[254];

                    ResultCaller_1 :BOOL;
                    ResultCaller_2 :BOOL;

                    startTime : LDATE_AND_TIME;
                END_VAR    
                // initializtion
                startTime := LDATE_AND_TIME#2023-11-11-11:11:11.111;
                _rtc.SetNowUTC(startTime);
                _context.InjectRtc(_rtc);
                caller_1.Initialize(_context);
                caller_2.Initialize(_context);
                caller_1.Identity := _context.CreateIdentity();
                caller_2.Identity := _context.CreateIdentity();
                IdentifierCaller_1 := '1';
                IdentifierCaller_2 := '2';
                _dataExchange.Operation.IsInitialized := true; //simulate intit from .net side
                _dataExchange.SetFirstReadDone(); 

                // needs to simulate + 2 cycles
                THIS.RunContextMultipleltipleTimes(3);
                
                 //------------------------ INVOKE READ CONCURRENT ------------------------
                _context.Open();
                _dataExchange.Run(_context);
                
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsBusy());
                
                ResultCaller_1 := _dataExchange.InvokeUpdate(caller_1, IdentifierCaller_1); // KICKING
                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsReady());
                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsBusy());

                ResultCaller_2 := _dataExchange.InvokeUpdate(caller_2, IdentifierCaller_2); // WAITING

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);
                AxUnit.Assert.Equal(ResultCaller_2,FALSE);

                _context.Close();
                //------------------------ INVOKE SUCCESEED - caller 1. ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsReady());
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsBusy());

                ResultCaller_1 := _dataExchange.InvokeUpdate(caller_1, IdentifierCaller_1); // BUSY - OK
                ResultCaller_2 := _dataExchange.InvokeUpdate(caller_2, IdentifierCaller_2); // WAITING

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,TRUE);
                AxUnit.Assert.Equal(ResultCaller_2,FALSE);

                _dataExchange.Operation.DoneSignature := _dataExchange.Operation.StartSignature; // remote task done

                _context.Close();
                //------------------------ DONE - caller 1. ------------------------
                _context.Open();
                _dataExchange.Run(_context); // SET DONE STATUS

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsDone());
                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsReady());

                ResultCaller_1 := _dataExchange.IsUpdateDone(caller_1); // is DONE
                ResultCaller_2 := _dataExchange.InvokeUpdate(caller_2, IdentifierCaller_2); // still WAITING

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,TRUE);
                AxUnit.Assert.Equal(ResultCaller_2,FALSE);
                _context.Close();
                //------------------------ +1 cycle gap between calls ------------------------
                _context.Open();
                _dataExchange.Run(_context); 
                //caller 1 finished not colled any more...
                ResultCaller_2 := _dataExchange.InvokeUpdate(caller_2, IdentifierCaller_2); // still WAITING
                AxUnit.Assert.Equal(FALSE, ResultCaller_2);
                _context.Close();
                //------------------------ +2 cycle gap between calls -----------------------
                _context.Open();
                _dataExchange.Run(_context); 
                ResultCaller_2 := _dataExchange.InvokeUpdate(caller_2, IdentifierCaller_2); // still WAITING
                AxUnit.Assert.Equal(FALSE, ResultCaller_2);
                _context.Close();
                //------------------------ Kicking  for caller 2 ------------------------
                _context.Open();
                _dataExchange.Run(_context); 
                ResultCaller_2 := _dataExchange.InvokeUpdate(caller_2, IdentifierCaller_2); // Kicking for caller 2
                AxUnit.Assert.Equal(FALSE, ResultCaller_2);

                _context.Close();
                //------------------------ INVOKE SUCCESEED -  caller 2. ------------------------
                _context.Open();
                _dataExchange.Run(_context); 
                ResultCaller_1 := _dataExchange.InvokeUpdate(caller_1, IdentifierCaller_1); // will wait 
                ResultCaller_2 := _dataExchange.InvokeUpdate(caller_2, IdentifierCaller_2); // invoke success

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_2);
                AxUnit.Assert.Equal(FALSE, ResultCaller_1);
                AxUnit.Assert.Equal(TRUE, ResultCaller_2);

                _dataExchange.Operation.DoneSignature := _dataExchange.Operation.StartSignature; // remote task done
                _context.Close();
                //------------------------ DONE - caller 2. ------------------------
                _context.Open();
                _dataExchange.Run(_context); 
                ResultCaller_1 := _dataExchange.InvokeUpdate(caller_1, IdentifierCaller_1); // will wait 
                ResultCaller_2 := _dataExchange.IsUpdateDone(caller_2); 

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_2);
                AxUnit.Assert.Equal(FALSE, ResultCaller_1);
                AxUnit.Assert.Equal(TRUE, ResultCaller_2);

                _context.Close();

            END_METHOD

            {Test}
            METHOD PUBLIC ConcurentCall_Read_test
                VAR
                    IdentifierCaller_1 : STRING[254];
                    IdentifierCaller_2 : STRING[254];

                    ResultCaller_1 :BOOL;
                    ResultCaller_2 :BOOL;

                    startTime : LDATE_AND_TIME;
                END_VAR    
                // initializtion
                startTime := LDATE_AND_TIME#2023-11-11-11:11:11.111;
                _rtc.SetNowUTC(startTime);
                _context.InjectRtc(_rtc);
                caller_1.Initialize(_context);
                caller_2.Initialize(_context);
                caller_1.Identity := _context.CreateIdentity();
                caller_2.Identity := _context.CreateIdentity();
                IdentifierCaller_1 := '1';
                IdentifierCaller_2 := '2';
                _dataExchange.Operation.IsInitialized := true; //simulate intit from .net side
                _dataExchange.SetFirstReadDone(); 

                // needs to simulate + 2 cycles
                THIS.RunContextMultipleltipleTimes(3);
                
                 //------------------------ INVOKE  CONCURRENT ------------------------
                _context.Open();
                _dataExchange.Run(_context);
                
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsReady());
                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsBusy());
                
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); // KICKING
                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsReady());
                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsBusy());

                ResultCaller_2 := _dataExchange.InvokeRead(caller_2, IdentifierCaller_2); // WAITING

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,FALSE);
                AxUnit.Assert.Equal(ResultCaller_2,FALSE);

                _context.Close();
                //------------------------ INVOKE SUCCESEED - caller 1. ------------------------
                _context.Open();
                _dataExchange.Run(_context);

                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsReady());
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsBusy());

                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); // BUSY - OK
                ResultCaller_2 := _dataExchange.InvokeRead(caller_2, IdentifierCaller_2); // WAITING

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,TRUE);
                AxUnit.Assert.Equal(ResultCaller_2,FALSE);

                _dataExchange.Operation.DoneSignature := _dataExchange.Operation.StartSignature; // remote task done

                _context.Close();
                //------------------------ DONE - caller 1. ------------------------
                _context.Open();
                _dataExchange.Run(_context); // SET DONE STATUS

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.IsDone());
                AxUnit.Assert.Equal(FALSE, _dataExchange.Operation.IsReady());

                ResultCaller_1 := _dataExchange.IsReadDone(caller_1); // is DONE
                ResultCaller_2 := _dataExchange.InvokeRead(caller_2, IdentifierCaller_2); // still WAITING

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_1);
                AxUnit.Assert.Equal(ResultCaller_1,TRUE);
                AxUnit.Assert.Equal(ResultCaller_2,FALSE);
                _context.Close();
                //------------------------ +1 cycle gap between calls ------------------------
                _context.Open();
                _dataExchange.Run(_context); 
                //caller 1 finished not colled any more...
                ResultCaller_2 := _dataExchange.InvokeRead(caller_2, IdentifierCaller_2); // still WAITING
                AxUnit.Assert.Equal(FALSE, ResultCaller_2);
                _context.Close();
                //------------------------ +2 cycle gap between calls -----------------------
                _context.Open();
                _dataExchange.Run(_context); 
                ResultCaller_2 := _dataExchange.InvokeRead(caller_2, IdentifierCaller_2); // still WAITING
                AxUnit.Assert.Equal(FALSE, ResultCaller_2);
                _context.Close();
                //------------------------ Kicking read for caller 2 ------------------------
                _context.Open();
                _dataExchange.Run(_context); 
                ResultCaller_2 := _dataExchange.InvokeRead(caller_2, IdentifierCaller_2); // Kicking for caller 2
                AxUnit.Assert.Equal(FALSE, ResultCaller_2);

                _context.Close();
                //------------------------ INVOKE SUCCESEED -  caller 2. ------------------------
                _context.Open();
                _dataExchange.Run(_context); 
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); // will wait 
                ResultCaller_2 := _dataExchange.InvokeRead(caller_2, IdentifierCaller_2); // invoke success

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_2);
                AxUnit.Assert.Equal(FALSE, ResultCaller_1);
                AxUnit.Assert.Equal(TRUE, ResultCaller_2);

                _dataExchange.Operation.DoneSignature := _dataExchange.Operation.StartSignature; // remote task done
                _context.Close();
                //------------------------ DONE - caller 2. ------------------------
                _context.Open();
                _dataExchange.Run(_context); 
                ResultCaller_1 := _dataExchange.InvokeRead(caller_1, IdentifierCaller_1); // will wait 
                ResultCaller_2 := _dataExchange.IsReadDone(caller_2); 

                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.DataEntityIdentifier = IdentifierCaller_2);
                AxUnit.Assert.Equal(FALSE, ResultCaller_1);
                AxUnit.Assert.Equal(TRUE, ResultCaller_2);

                _context.Close();

            END_METHOD


        END_CLASS
    END_NAMESPACE    
END_NAMESPACE

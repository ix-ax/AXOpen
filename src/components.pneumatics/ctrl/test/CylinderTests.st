USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Pneumatics;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE Cylinder.Tests
    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AXOpen.Core.Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD               
    END_CLASS   

    {S7.extern=ReadWrite}
    CLASS AxoRtcMock IMPLEMENTS IAxoRtc
        VAR PRIVATE 
            _NowUTC : LDATE_AND_TIME;
        END_VAR

        METHOD INTERNAL SetNowUTC : LDATE_AND_TIME
            VAR_INPUT
                Set :  LDATE_AND_TIME;
            END_VAR;
            _NowUTC := Set;
        END_METHOD

        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            NowUTC := _NowUTC;
        END_METHOD        
    END_CLASS

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS CylinderTests 
        VAR 
            context : TestContext;
            cylinder : AxoCylinder;
            cylinderParent : AXOpen.Core.AxoObject;
            _rtc             :   AXOpen.Core.Dummies.MockAxoRtc;
            _rtm             :   AXOpen.Core.Dummies.MockAxoRtm;
            _homeSensor : BOOL;
            _workSensor : BOOL;
            _moveHomeSignal : BOOL;
            _moveWorkSignal : BOOL;
            _done : BOOL;
        END_VAR    
        
        VAR
            contextBlank : TestContext;
            cylinderBlank : AxoCylinder;
            cylinderParentBlank : AXOpen.Core.AxoObject;            
        END_VAR    

        {TestSetup}
        METHOD PUBLIC TestSetup
            context := contextBlank;
            _rtm.SetElapsed(LTIME#2s);
            context.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            context.InjectRtc(_rtc);
            cylinder := cylinderBlank;
            cylinderParent := cylinderParentBlank;
            context.InitializeRootObject(cylinderParent);
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

        METHOD PRIVATE Init
            VAR_INPUT
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2012-01-12-15:58:12.123;
            END_VAR
            _rtc.SetNowUTC(dt);
            context.InjectRtc(_rtc);
            context.Open();   
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
        END_METHOD

        METHOD AreEqual : BOOL
            VAR_INPUT
                 expected:  LDATE_AND_TIME;
                 actual:  LDATE_AND_TIME;
            END_VAR
            AreEqual := expected = actual;
        END_METHOD 

        {Test}
        METHOD PUBLIC MoveHome    
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveIn();
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOut().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
        END_METHOD
        
        {Test}
        METHOD PUBLIC MoveWork       
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveOut();
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOut().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveIn().IsBusy());   
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeStop   
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveIn();
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            context.Open();                                                              
            cylinder._StopTask.Invoke();
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          

            AxUnit.Assert.Equal(FALSE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOut().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveIn().IsBusy());   
        END_METHOD
        
        {Test}
        METHOD PUBLIC MoveWorkStop         
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveOut();
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            context.Open();                                                              
            cylinder._StopTask.Invoke();
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOut().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveIn().IsBusy());   
        END_METHOD  
        
        {Test}
        METHOD PUBLIC MoveWorkSuspendBeforeRun   
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2023-01-12-15:49:12.123;
            END_VAR
            THIS.Init(dt);  

            context.Open();                                                              
            cylinder.MoveOut();
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessageCode = ULINT#4 && cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();                                                                          
            context.InitializeRootObject(cylinderParent);
            cylinder.SuspendMoveToOutWhile(TRUE);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveOutTask.IsBusy());  
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkSuspendAfterRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-15:49:12.123;
            END_VAR
            THIS.Init(dt);    

            context.Open();                                                              
            cylinder.MoveOut();
            context.InitializeRootObject(cylinderParent);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessageCode = ULINT#4 && cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();            
            _homeSensor := FALSE;                                                  
            _workSensor := FALSE;
            context.InitializeRootObject(cylinderParent);
            cylinder.SuspendMoveToOutWhile(TRUE);
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);              
            context.Close();                          
            
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeSuspendBeforeRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-13:49:12.123;
            END_VAR
            THIS.Init(dt);   

            context.Open();                                                              
            cylinder.MoveIn();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessageCode = ULINT#5 && cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();                                                              
            cylinder.SuspendMoveToInWhile(TRUE);
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeSuspendAfterRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:49:12.123;
            END_VAR
            THIS.Init(dt); 

            context.Open();                                                              
            cylinder.MoveIn();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessageCode = ULINT#5 && cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            context.Open();                                                              
            context.InitializeRootObject(cylinderParent);   
            cylinder.SuspendMoveToInWhile(TRUE);                                                     
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);              
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkWhileSuspended        
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:49:12.123;
            END_VAR
            THIS.Init(dt); 
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open(); 
            context.InitializeRootObject(cylinderParent);                                                              
            cylinder.Stop();
            cylinder.Restore();                                         
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();

            context.Open();                                                             
           
            cylinder.MoveOut();    
            cylinder.SuspendMoveToOutWhile(TRUE);       
          
            cylinder.Run(inParent := cylinderParent, 
                        inInSensor := _homeSensor, 
                        inOutSensor := _workSensor,
                        outMoveInSignal => _moveHomeSignal, 
                        outMoveOutSignal => _moveWorkSignal);

            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder.IsMoveToOutSuspended());  
            AxUnit.Assert.Equal(FALSE, _workSensor);   
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeWhileSuspended        
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:41:12.123;
            END_VAR
            THIS.Init(dt); 
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            
            context.Open(); 
            context.InitializeRootObject(cylinderParent);                                                              
            cylinder.Stop();
            cylinder.Restore();                                         
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();

            context.Open();                                                              
            cylinder.SuspendMoveToInWhile(TRUE);
            cylinder.MoveIn();                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            // AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkAbortBeforeRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2023-01-12-15:49:12.123;
            END_VAR
            THIS.Init(dt);  
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            
            context.Open();                                                              
            cylinder.MoveOut();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOut().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessageCode = ULINT#6 && cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();                                                              
            cylinder.AbortMoveToWorkWhen(TRUE);
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveOutTask.IsBusy());  
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(cylinder._Messenger.MessageCode, ULINT#6);            
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkAbortAfterRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-15:49:12.123;
            END_VAR
            THIS.Init(dt);    

            context.Open();                                                              
            cylinder.MoveOut();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
             AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessageCode = ULINT#6 && cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();                                                              
            context.InitializeRootObject(cylinderParent);     
            cylinder.AbortMoveToWorkWhen(TRUE);                                                   
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);              
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(cylinder._Messenger.MessageCode, ULINT#6);  
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeAbortBeforeRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-13:49:12.123;
            END_VAR
            THIS.Init(dt);   

            context.Open();                                                              
            cylinder.MoveIn();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessageCode = ULINT#7 &&  cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();                                                              
            cylinder.AbortMoveToHomeWhen(TRUE);
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(cylinder._Messenger.MessageCode, ULINT#7);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeAbortAfterRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:49:12.123;
            END_VAR
            THIS.Init(dt); 

            context.Open();                                                              
            cylinder.MoveIn();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE,  cylinder._Messenger.MessageCode = ULINT#7 &&  cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();                                                              
            context.InitializeRootObject(cylinderParent);  
            cylinder.AbortMoveToHomeWhen(TRUE);                                                      
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);             
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOutSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveInSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(cylinder._Messenger.MessageCode, ULINT#7);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkWhileAborted        
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:49:12.123;
            END_VAR

            THIS.Init(dt); 
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();                                                              
            cylinder.AbortMoveToWorkWhen(TRUE);
            cylinder.MoveOut();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveOutTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveOut().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeWhileAborted        
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:41:12.123;
            END_VAR

            THIS.Init(dt); 
            // AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);

            context.Open();                                                              
            cylinder.AbortMoveToHomeWhen(TRUE);
            cylinder.MoveIn();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  



        {Test}
        METHOD PUBLIC Messaging     
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:41:12.123;
            END_VAR 
            THIS.Init(dt); 
            context.Open();                                                              
            cylinder.SuspendMoveToInWhile(TRUE);
            cylinder.MoveIn();
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            context.Open();                                                              
            cylinder.SuspendMoveToInWhile(TRUE);
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            context.InitializeRootObject(cylinderParent);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          

            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveInTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveIn().IsBusy());   
            // AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.MessengerState = eAxoMessengerState#ActiveAcknowledgeNotRequired);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
            AxUnit.Assert.Equal(ULINT#5, cylinder._Messenger.MessageCode);
            
        END_METHOD  
    END_CLASS    

END_NAMESPACE

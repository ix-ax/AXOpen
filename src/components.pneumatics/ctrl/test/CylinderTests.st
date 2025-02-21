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
            _rtc : AxoRtcMock;
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
            cylinder := cylinderBlank;
            cylinderParent := cylinderParentBlank;
            cylinderParent.InitializeWithContext(context);
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
            cylinderParent.InitializeWithContext(context);                                                        
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
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
        END_METHOD
        
        {Test}
        METHOD PUBLIC MoveWork       
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO  
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToHome().IsBusy());   
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeStop   
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            context.Open();                                                              
            cylinder._StopTask.Invoke();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          

            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToHome().IsBusy());   
        END_METHOD
        
        {Test}
        METHOD PUBLIC MoveWorkStop         
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            context.Open();                                                              
            cylinder._StopTask.Invoke();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToHome().IsBusy());   
        END_METHOD  
        
        {Test}
        METHOD PUBLIC MoveWorkSuspendBeforeRun   
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2023-01-12-15:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt);  

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.SuspendMoveToWorkWhile(TRUE);
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());  
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkSuspendAfterRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-15:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt);    

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            cylinder.SuspendMoveToWorkWhile(TRUE);
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeSuspendBeforeRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-13:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt);   

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.SuspendMoveToHomeWhile(TRUE);
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeSuspendAfterRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt); 

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            cylinder.SuspendMoveToHomeWhile(TRUE);
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkWhileSuspended        
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt); 
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.SuspendMoveToWorkWhile(TRUE);
            cylinder.MoveToWork();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeWhileSuspended        
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:41:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt); 
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.SuspendMoveToHomeWhile(TRUE);
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkAbortBeforeRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2023-01-12-15:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt);  
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   

            context.Open();                                                              
            cylinder.AbortMoveToWorkWhen(TRUE);
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToWorkTask.IsBusy());  
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkAbortAfterRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-15:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt);    

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            cylinder.AbortMoveToWorkWhen(TRUE);
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeAbortBeforeRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-13:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt);   

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.AbortMoveToHomeWhen(TRUE);
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeAbortAfterRun         
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:49:12.123;
            END_VAR
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO
            THIS.Init(dt); 

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            cylinder.AbortMoveToHomeWhen(TRUE);
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveWorkWhileAborted        
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:49:12.123;
            END_VAR

            THIS.Init(dt); 
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.AbortMoveToWorkWhen(TRUE);
            cylinder.MoveToWork();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  

        {Test}
        METHOD PUBLIC MoveHomeWhileAborted        
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:41:12.123;
            END_VAR

            THIS.Init(dt); 
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.AbortMoveToHomeWhen(TRUE);
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
        END_METHOD  



        {Test}
        METHOD PUBLIC Messaging     
            VAR
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2021-01-11-05:41:12.123;
            END_VAR 
            AxUnit.Assert.Equal(TRUE,TRUE);
            return; //TODO  
            THIS.Init(dt); 
            context.Open();                                                              
            cylinder.SuspendMoveToHomeWhile(TRUE);
            cylinder.MoveToHome();
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          
                
            context.Open();                                                              
            cylinder.SuspendMoveToHomeWhile(TRUE);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            cylinderParent.InitializeWithContext(context);                                                        
            cylinder.Run(cylinderParent, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);  
            context.Close();                          

            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            AxUnit.Assert.Equal(TRUE,THIS.AreEqual(dt, cylinder._Messenger.Risen));
            AxUnit.Assert.Equal(ULINT#5, cylinder._Messenger.MessageCode);
            
        END_METHOD  
    END_CLASS    

END_NAMESPACE

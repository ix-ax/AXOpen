USING AXOpen.Components.Pneumatics;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE Cylinder.Tests
    CLASS TestContext IMPLEMENTS AXOpen.Core.IAxoContext
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
        END_VAR       
        VAR PRIVATE            
            NULL_RTC : _NULL_RTC;
           
            _rtc : IAxoRtc;
         END_VAR
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;
        END_METHOD
                
        METHOD PUBLIC ClosedCycleCount : ULINT
            ClosedCycleCount := _closeCounter;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT            
            _identityCounter := _identityCounter + ULINT#1;
            CreateIdentity := _identityCounter;
        END_METHOD         
        
        METHOD PUBLIC GetRtc : IAxoRtc
            IF(_rtc <> NULL) THEN
                GetRtc := _rtc;
            ELSE
                GetRtc := NULL_RTC;    
            END_IF;    
        END_METHOD

        METHOD PUBLIC InjectRtc
            VAR_INPUT
                Rtc : IAxoRtc;
            END_VAR
            _rtc := Rtc;
        END_METHOD
        VAR PRIVATE
           NULL_LOGGER : _NULL_LOGGER;
        END_VAR    
        METHOD PUBLIC GetLogger : AXOpen.Logging.IAxoLogger GetLogger := NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : AXOpen.Logging.IAxoLogger; END_VAR ; END_METHOD        
    END_CLASS
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
    CLASS CylinderTests 
        VAR 
            context : TestContext;
            cylinder : AxoCylinder;
            _rtc : AxoRtcMock;
            _homeSensor : BOOL;
            _workSensor : BOOL;
            _moveHomeSignal : BOOL;
            _moveWorkSignal : BOOL;
            _done : BOOL;
        END_VAR    
        
        METHOD PRIVATE Init
            VAR_INPUT
                dt : LDATE_AND_TIME := LDATE_AND_TIME#2012-01-12-15:58:12.123;
            END_VAR
            _rtc.SetNowUTC(dt);
            context.InjectRtc(_rtc);
            context.Open();                                                              
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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
            cylinder.MoveToHome();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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
            THIS.Init();  

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            context.Open();                                                              
            cylinder._StopTask.Invoke();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            context.Open();                                                              
            cylinder._StopTask.Invoke();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt);  

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.SuspendMoveToWorkWhile(TRUE);
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt);    

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt);   

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.SuspendMoveToHomeWhile(TRUE);
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt); 

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt); 
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.SuspendMoveToWorkWhile(TRUE);
            cylinder.MoveToWork();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt); 
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.SuspendMoveToHomeWhile(TRUE);
            cylinder.MoveToHome();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt);  
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, cylinder._MoveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, cylinder._MoveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   

            context.Open();                                                              
            cylinder.AbortMoveToWorkWhen(TRUE);
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt);    

            context.Open();                                                              
            cylinder.MoveToWork();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            AxUnit.Assert.Equal(TRUE, _moveWorkSignal);   
            AxUnit.Assert.Equal(FALSE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToWorkTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToWork().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt);   

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.AbortMoveToHomeWhen(TRUE);
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

            THIS.Init(dt); 

            context.Open();                                                              
            cylinder.MoveToHome();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            AxUnit.Assert.Equal(FALSE, _moveWorkSignal);   
            AxUnit.Assert.Equal(TRUE, _moveHomeSignal);   
            AxUnit.Assert.Equal(TRUE, cylinder._MoveToHomeTask.IsBusy());   
            AxUnit.Assert.Equal(TRUE, cylinder.MoveToHome().IsBusy());   
            AxUnit.Assert.Equal(FALSE, cylinder._Messenger.IsActive);

            context.Open();                                                              
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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
            THIS.Init(dt); 
            context.Open();                                                              
            cylinder.SuspendMoveToHomeWhile(TRUE);
            cylinder.MoveToHome();
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
            context.Close();                          
                
            context.Open();                                                              
            cylinder.SuspendMoveToHomeWhile(TRUE);
            AxUnit.Assert.Equal(TRUE, cylinder._Messenger.IsActive);
            cylinder.Run(context, _homeSensor, _workSensor, _moveHomeSignal, _moveWorkSignal);                
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

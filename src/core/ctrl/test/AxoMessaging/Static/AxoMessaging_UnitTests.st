USING AXOpen.Core.Dummies;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging.Static;
USING AXOpen.Core;
USING AXOpen.Core.Dummies;
USING AxUnit;
USING AXOpen.Rtc;
USING AXOpen.Rtm;
USING AXOpen.Core;
USING AXOpen.Logging;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

NAMESPACE AXOpen.AxoMessagingStatic_UnitTests
    {S7.extern=ReadWrite}
    CLASS TestContextI EXTENDS MockAxoContext
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;           
        END_VAR       
        VAR PUBLIC       
            _object : TestObject;     
            _nested : NestedObject_L1;            
        END_VAR      

        VAR PRIVATE            
            NULL_RTC : _NULL_RTC;
            _rtc : IAxoRtc;
            _NowUTC : LDATE_AND_TIME;
        END_VAR       

        // ///<summary>
        // /// Gets whether this context is valid.
        // ///</summary>
        // METHOD PUBLIC IsValid : BOOL
        //     IsValid := TRUE;            
        // END_METHOD

        // METHOD PUBLIC Open : ULINT
        //     _openCounter := _openCounter + ULINT#1;
        // END_METHOD    

        // METHOD PUBLIC Close : ULINT
        //     _closeCounter := _closeCounter + ULINT#1;
        // END_METHOD

        // METHOD PUBLIC OpenCycleCount : ULINT
        //     OpenCycleCount := _openCounter;
        // END_METHOD
                
        // METHOD PUBLIC ClosedCycleCount : ULINT
        //     ClosedCycleCount := _closeCounter;
        // END_METHOD

        // METHOD PUBLIC CreateIdentity : ULINT            
        //     _identityCounter := _identityCounter + ULINT#1;
        //     CreateIdentity := _identityCounter;
        // END_METHOD        

        // METHOD PUBLIC GetRtc : IAxoRtc
        //     IF(_rtc <> NULL) THEN
        //         GetRtc := _rtc;
        //     ELSE
        //         GetRtc := NULL_RTC;    
        //     END_IF;    
        // END_METHOD

        // METHOD PUBLIC InjectRtc
        //     VAR_INPUT
        //         Rtc : IAxoRtc;
        //     END_VAR
        //     _rtc := Rtc;
        // END_METHOD
        
        // METHOD INTERNAL SetNowUTC : LDATE_AND_TIME
        //     VAR_INPUT
        //         Set :  LDATE_AND_TIME;
        //     END_VAR;
        //     _NowUTC := Set;
        // END_METHOD

        // METHOD PUBLIC NowUTC : LDATE_AND_TIME    
        //     NowUTC := _NowUTC;
        // END_METHOD       

        // VAR PRIVATE
        //     NULL_LOGGER : _NULL_LOGGER;
        // END_VAR    
        
        // METHOD PUBLIC GetLogger : IAxoLogger 
        //     GetLogger := NULL_LOGGER; 
        // END_METHOD
        
        // METHOD PUBLIC InjectLogger 
        //     VAR_INPUT 
        //         _logger : IAxoLogger; 
        //     END_VAR 
        //     ; 
        // END_METHOD     

        // VAR PRIVATE
        //     NULL_RTM : _NULL_RTM;
        //     _rtm : IAxoRtm;
        //     _elapsed : LTIME;
        // END_VAR    

        // METHOD PUBLIC GetRtm : AXOpen.Rtm.IAxoRtm 
        //     IF(_rtm <> NULL) THEN
        //         GetRtm := _rtm;
        //     ELSE
        //         GetRtm := NULL_RTM;    
        //     END_IF;   
        // END_METHOD

        // METHOD PUBLIC InjectRtm 
        //     VAR_INPUT 
        //         inRtm : AXOpen.Rtm.IAxoRtm; 
        //     END_VAR 
        //     _rtm := inRtm;
        // END_METHOD  

        // METHOD INTERNAL Elapsed : LTIME
        //     Elapsed := _elapsed;
        // END_METHOD

        // METHOD PUBLIC SetElapsed : LTIME    
        //     VAR_INPUT
        //         Set :  LTIME;
        //     END_VAR;
        //     _elapsed := Set;
        // END_METHOD       
    
        // METHOD PUBLIC InitializeRootObject
        //     VAR_IN_OUT
        //         inoRootObject : AXOpen.Core.Dummies.MockAxoObject;
        //     END_VAR
        //     inoRootObject.InitializeWithContext_Test(THIS);
        //     ;
        // END_METHOD
    
        // METHOD PUBLIC InitializeRootObject
        //     VAR_IN_OUT
        //         inoRootObject : AxoObject;
        //     END_VAR

        //     ;
        // END_METHOD
    END_CLASS  
   
    {S7.extern=ReadWrite}
    CLASS TestContextE EXTENDS Dummies.MockAxoContext
  
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS AxoMessengerTest EXTENDS AxoMessenger
        METHOD INTERNAL IsActive : BOOL
            IsActive := THIS.MessengerState=eAxoMessengerState#ActiveAcknowledgeNotRequired OR 
                        THIS.MessengerState=eAxoMessengerState#ActiveAcknowledgeRequired OR 
                        THIS.MessengerState=eAxoMessengerState#ActiveAlreadyAcknowledged;
                        
        END_METHOD
        METHOD INTERNAL WaitingForAcknowledge : BOOL
            WaitingForAcknowledge := THIS.MessengerState=eAxoMessengerState#InactiveWaitingForAcknowledge;
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS TestObject EXTENDS MockAxoObject
        VAR PUBLIC 
            _messenger : AxoMessengerTest;
        END_VAR
 
    END_CLASS

    CLASS NestedObject_L1 EXTENDS MockAxoObject
        VAR PUBLIC 
            _nestedObject_L2 : NestedObject_L2;
            _messenger : AxoMessengerTest;
        END_VAR
    END_CLASS    

    CLASS NestedObject_L2 EXTENDS MockAxoObject
        VAR PUBLIC 
            _nestedObject_L3 : NestedObject_L3;
            _messenger : AxoMessengerTest;
        END_VAR
    END_CLASS    

    CLASS NestedObject_L3 EXTENDS MockAxoObject
        VAR PUBLIC 
            _messenger : AxoMessengerTest;
        END_VAR
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

    {S7.extern=ReadWrite}
    CLASS MessengerServiceSpy IMPLEMENTS IAxoMessagingServices
        VAR PUBLIC
            QueueCount : DINT;
            LastQueued : REF_TO AxoMessengerTest;
        END_VAR

        METHOD PUBLIC QueueMessage : BOOL
            VAR_INPUT
                inMessage : IAxoMessenger;
            END_VAR
            VAR
                typedMessage : REF_TO AxoMessengerTest;
            END_VAR

            typedMessage ?= inMessage;
            LastQueued := typedMessage;
            QueueCount := QueueCount + DINT#1;
            QueueMessage := TRUE;
        END_METHOD

        METHOD PUBLIC SuspendMessaging
            ;
        END_METHOD

        METHOD PUBLIC ResumeMessaging
            ;
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS MessengerServiceMessageSpy EXTENDS AxoMessengerTest
        VAR PUBLIC
            ServeCount : DINT;
            LastServedSender : IAxoObject;
        END_VAR

        METHOD PUBLIC OVERRIDE Serve
            VAR_INPUT
                inObject : IAxoObject;
            END_VAR

            ServeCount := ServeCount + DINT#1;
            LastServedSender := inObject;
        END_METHOD
    END_CLASS

    TYPE
        TestMessage : STRUCT
            IsActive : BOOL;
            Category : eAxoMessageCategory;           
            MessageCode : ULINT;
            Risen : LDATE_AND_TIME;
            Fallen : LDATE_AND_TIME;
            WaitingForAcknowledge : BOOL;
            AcknowledgementRequired : BOOL;
            AcknowledgeRequest : BOOL;
            AcknowledgedBeforeFallen : BOOL;
            Acknowledged : LDATE_AND_TIME;        
        END_STRUCT;
    END_TYPE

    {TestFixture}
    CLASS AxoMessenger_UnitTests
        VAR PRIVATE
            _suti : TestContextI;
            _sute : TestContextE;
            _rtc : AXOpen.Core.Dummies.MockAxoRtc;
            // _rtc : AxoRtcMock;
            _rtm : AXOpen.Core.Dummies.MockAxoRtm;
            _serviceSpy : MessengerServiceSpy;
            _messengerService : AXOpen.Messaging.AxoMessengerService;
            _serviceMessenger1 : MessengerServiceMessageSpy;
            _serviceMessenger2 : MessengerServiceMessageSpy;
            _serviceMessageSlots : ARRAY[0..3] OF REF_TO AxoMessenger;
        END_VAR

        VAR
            _sutiClean : TestContextI;
            _suteClean : TestContextE;      
            _rootIObject : TestObject;
            _rootEObject : TestObject;
    
        END_VAR    
    
        {TestSetup}
        METHOD PUBLIC TestSetup
            VAR
                i : DINT;
            END_VAR
            _suti := _sutiClean;
            _rtm.SetElapsed(LTIME#2s);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            _suti.InjectRtc(_rtc);
            _suti.InjectRtm(_rtm);
            _suti.InitializeRootObject(_rootIObject);
            _serviceSpy.QueueCount := DINT#0;
            _serviceSpy.LastQueued := NULL;
            _serviceMessenger1.ServeCount := DINT#0;
            _serviceMessenger1.LastServedSender := NULL;
            _serviceMessenger1.Sender := NULL;
            _serviceMessenger2.ServeCount := DINT#0;
            _serviceMessenger2.LastServedSender := NULL;
            _serviceMessenger2.Sender := NULL;
            FOR i := DINT#0 TO DINT#3 DO
                _serviceMessageSlots[i] := NULL;
            END_FOR;

            _sute := _suteClean;     
            _sute.InjectRtc(_rtc);
            _sute.InjectRtm(_rtm);
            _sute.InitializeRootObject(_rootEObject);
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

        METHOD AreEqual : BOOL
            VAR_INPUT
                 expected:  LDATE_AND_TIME;
                 actual:  LDATE_AND_TIME;
            END_VAR
            AreEqual := expected = actual;
        END_METHOD    

        METHOD AreEqual : BOOL
            VAR_INPUT
                 expected:  eAxoMessageCategory;
                 actual:  eAxoMessageCategory;
            END_VAR
            AreEqual := expected = actual;
        END_METHOD   

        {Test}
        METHOD PUBLIC rtc_should_pass_through_context
            VAR 
                expected : LDATE_AND_TIME;
                actual : LDATE_AND_TIME;
            END_VAR
            //Arrange
            actual := _sute.GetRtc().NowUTC();
            expected := LDATE_AND_TIME#2014-01-12-15:58:12.123;
            _rtc.SetNowUTC(expected);
            Assert.Equal(FALSE, THIS.AreEqual(expected,actual));
            //Act
            _sute.InjectRtc(_rtc);
            //Assert
            actual := _sute.GetRtc().NowUTC();
            Assert.Equal(TRUE, THIS.AreEqual(expected,actual));
        END_METHOD

        {Test}
        METHOD PUBLIC isactive_should_be_true_after_activate_call
            //--Act
            _suti.Open();
            _suti.InitializeRootObject(_suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1);
            _suti.Close();

            //--Assert            
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
                           
        END_METHOD


        {Test}
        METHOD PUBLIC post_should_enqueue_message_with_sender_and_text
            VAR
                messageText : STRING[254];
                resultProperties : AXOpen.Messaging.Static.IAxoMessageProperties;
                typedMessenger : REF_TO AxoMessengerTest;
            END_VAR

            messageText := 'Posted message text';
            _serviceSpy.QueueCount := DINT#0;
            _serviceSpy.LastQueued := NULL;
            _suti.InjectMessengerService(_serviceSpy);

            _suti.Open();
            _suti.InitializeRootObject(_suti._object);

            resultProperties := _suti._object._messenger.Post(_suti._object, messageText, eAxoMessageCategory#Warning);

            Assert.Equal(TRUE, _serviceSpy.QueueCount = DINT#1);
            Assert.Equal(TRUE, _serviceSpy.LastQueued <> NULL);
            Assert.Equal(TRUE, _serviceSpy.LastQueued = REF(_suti._object._messenger));

            typedMessenger ?= resultProperties;
            Assert.Equal(TRUE, typedMessenger = REF(_suti._object._messenger));

            Assert.Equal(TRUE, _suti._object._messenger.Message = messageText);
            Assert.Equal(TRUE, _suti._object._messenger.Sender <> NULL);
            Assert.Equal(TRUE, _suti._object._messenger.Sender.GetIdentity() = _suti._object.GetIdentity());
            _suti.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC queue_message_should_fail_when_service_not_initialized
            VAR
                result : BOOL;
            END_VAR

            result := _messengerService.QueueMessage(_serviceMessenger1);

            Assert.Equal(FALSE, result);
        END_METHOD

        {Test}
        METHOD PUBLIC queue_message_should_store_reference_after_run
            VAR
                slotsRef : REF_TO ARRAY[0..3] OF REF_TO AxoMessenger;
                expectedRef : REF_TO AxoMessenger;
                result : BOOL;
            END_VAR

            slotsRef := REF(_serviceMessageSlots);
            expectedRef := REF(_serviceMessenger1);

            _suti.Open();
            _suti.InitializeRootObject(_suti._object);

            _messengerService.Run(_suti._object, slotsRef);

            _serviceMessenger1.Sender := _suti._object;

            result := _messengerService.QueueMessage(_serviceMessenger1);

            Assert.Equal(TRUE, result);
            Assert.Equal(TRUE, _serviceMessageSlots[DINT#0] = expectedRef);
            Assert.Equal(TRUE, _serviceMessageSlots[DINT#1] = NULL);

            _suti.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC run_should_serve_enqueued_message
            VAR
                slotsRef : REF_TO ARRAY[0..3] OF REF_TO AxoMessenger;
            END_VAR

            slotsRef := REF(_serviceMessageSlots);

            _suti.Open();
            _suti.InitializeRootObject(_suti._object);

            _messengerService.Run(_suti._object, slotsRef);

            _serviceMessenger1.Sender := _suti._object;
            _serviceMessenger1.ServeCount := DINT#0;
            _serviceMessenger1.LastServedSender := NULL;

            _messengerService.QueueMessage(_serviceMessenger1);

            _messengerService.Run(_suti._object, slotsRef);

            Assert.Equal(TRUE, _serviceMessenger1.ServeCount = DINT#1);
            Assert.Equal(TRUE, _serviceMessenger1.LastServedSender <> NULL);
            Assert.Equal(TRUE, _serviceMessenger1.LastServedSender.GetIdentity() = _suti._object.GetIdentity());

            _suti.Close();
        END_METHOD


      
        
        {Test}
        METHOD PUBLIC isactive_nested_should_count_messages
            VAR
                i : INT;
            END_VAR    
            //--Act
            FOR i := 0 TO 2 DO
                _suti.Open();
                _suti.InitializeRootObject( _suti._nested);
                // _suti._nested._nestedObject_L2.Initialize(_suti._nested);
                // _suti._nested._nestedObject_L2._nestedObject_L3.Initialize(_suti._nested._nestedObject_L2);            
                _suti._nested._nestedObject_L2.Run(_suti._nested);
                _suti._nested._nestedObject_L2._nestedObject_L3.Run(_suti._nested._nestedObject_L2);            
    
                _suti._nested._messenger.Serve(_suti._nested);
                _suti._nested._messenger.Activate(UINT#1,eAxoMessageCategory#Error);
                                       
                _suti._nested._nestedObject_L2._messenger.Serve(_suti._nested._nestedObject_L2);
                _suti._nested._nestedObject_L2._messenger.Activate(UINT#1,eAxoMessageCategory#Error);
                
                _suti._nested._nestedObject_L2._nestedObject_L3._messenger.Serve(_suti._nested._nestedObject_L2._nestedObject_L3);
                _suti._nested._nestedObject_L2._nestedObject_L3._messenger.Activate(UINT#1,eAxoMessageCategory#Error);
                
    
                // _suti._nested._messenger.Serve(_suti._nested);
                // _suti._nested._nestedObject_L2._messenger.Serve(_suti._nested._nestedObject_L2);
                // _suti._nested._nestedObject_L2._nestedObject_L3._messenger.Serve(_suti._nested._nestedObject_L2._nestedObject_L3);
               
                _suti.Close();    
            END_FOR;
            

            //--Assert            
           
                                         
            Assert.Equal(_suti._nested._nestedObject_L2._nestedObject_L3.MsgCnt, LINT#1);       
            Assert.Equal(_suti._nested._nestedObject_L2.MsgCnt, LINT#2);       
            Assert.Equal(_suti._nested.MsgCnt, LINT#3);
        END_METHOD


        {Test}
        METHOD PUBLIC MessengerState_should_be_InvalidImplementation_in_case_of_activate_method_is_called_before_serve_method
            //--Act
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Activate(UINT#1);
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            Assert.Equal(TRUE, _suti._object._messenger.MessengerState = eAxoMessengerState#InvalidImplementation);
        END_METHOD

        {Test}
        METHOD PUBLIC isactive_should_be_false_after_ActivateOnCondition_false_call
            //--Act
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
        END_METHOD

        {Test}
        METHOD PUBLIC isactive_should_be_true_after_ActivateOnCondition_true_call
            //--Act
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
        END_METHOD

        {Test}
        METHOD PUBLIC MessengerState_should_be_InvalidImplementation_in_case_of_activateoncondition_method_is_called_before_serve_method
            //--Act
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE);
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            Assert.Equal(TRUE, _suti._object._messenger.MessengerState = eAxoMessengerState#InvalidImplementation);
        END_METHOD

        {Test}
        METHOD PUBLIC message_should_be_fallen_immediatelly_on_falling_condition_of_the_ActivateOnCondition
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Debug;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:58:12.123;
            expMessage.Fallen := LDATE_AND_TIME#2023-01-12-18:00:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Fallen));
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _rtc.SetNowUTC(expMessage.Risen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Fallen,_suti._object._messenger.Fallen));

        END_METHOD
        
        {Test}
        METHOD PUBLIC message_should_be_fallen_after_one_PLC_cycle_with_no_call_of_the_activate_method
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Debug;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:58:12.123;
            expMessage.Fallen := LDATE_AND_TIME#2023-01-12-18:00:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Fallen));
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _rtc.SetNowUTC(expMessage.Risen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Stop calling of the Activate method
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            //_suti._object._messenger.Activate(UINT#1,expMessage.Category);   --- No Active method call in this PLC cycle
            _suti.Close();
            //3rd-PLC cycle: Falling of the message detection
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            //_suti._object._messenger.Activate(UINT#1,expMessage.Category);   --- No Active method call in this PLC cycle
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Fallen,_suti._object._messenger.Fallen));

        END_METHOD
        
        {Test}
        METHOD PUBLIC message_of_debug_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Debug;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:58:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_trace_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Trace;
            expMessage.Risen := LDATE_AND_TIME#2023-06-12-17:58:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_notify_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Notification;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-19:58:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD
 
        {Test}
        METHOD PUBLIC message_of_warning_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Warning;
            expMessage.Risen := LDATE_AND_TIME#2023-01-09-17:58:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_error_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Error;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:12:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_info_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Info;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-20:12:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD
        
        {Test}
        METHOD PUBLIC message_of_programming_error_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#ProgrammingError;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:45:12.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_critical_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Critical;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:12:12.942;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_catastrophic_category_should_be_risen
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Catastrophic;
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:12:57.123;
            
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Risen));
            _rtc.SetNowUTC(expMessage.Risen);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(UINT#1,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_trace_category_should_not_require_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Trace;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_trace_category_should_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Trace;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD
    
        {Test}
        METHOD PUBLIC message_of_debug_category_should_not_require_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Debug;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_debug_category_should_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Debug;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_info_category_should_not_require_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Info;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_info_category_should_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Info;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_timedout_category_should_not_require_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#TimedOut;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_timedout_category_should_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#TimedOut;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_notification_category_should_not_require_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Notification;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_notification_category_should_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Notification;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_warning_category_should_not_require_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Warning;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_warning_category_should_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Warning;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_error_category_shouldrequire_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Error;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_error_category_should_not_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Error;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_programming_error_category_shouldrequire_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#ProgrammingError;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_programming_error_category_should_not_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#ProgrammingError;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_critical_category_shouldrequire_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Critical;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_critical_category_should_not_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Critical;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_fatal_category_shouldrequire_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Fatal;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_fatal_category_should_not_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Fatal;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_catastrophic_category_shouldrequire_acknowledgement_by_default
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Catastrophic;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_catastrophic_category_should_not_require_acknowledgement_when_overriden
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Category := eAxoMessageCategory#Catastrophic;
 
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD
                
        
        {Test}
        METHOD PUBLIC WaitingForAcknowledge_should_be_true_after_falling_of_the_message_that_require_acknowledgement
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.WaitingForAcknowledge());
 
        END_METHOD

        {Test}
        METHOD PUBLIC repeatively_rised_unacknowledged_message_should_overwrite_the_time_stamps_and_resets_the_WaitingForAcknowledge
            VAR
                expMessage : TestMessage;
                Risen2 : LDATE_AND_TIME;
            END_VAR
            //--Arrange
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:58:12.123;
            expMessage.Fallen := LDATE_AND_TIME#2023-01-12-18:00:12.123;
            Risen2 := LDATE_AND_TIME#2023-01-12-18:02:12.123;
            
            //--Act
            //1st-PLC cycle: Rising of the message
            _rtc.SetNowUTC(expMessage.Risen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();
            //3rd-PLC cycle: Rising of the message again
            _rtc.SetNowUTC(Risen2);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(Risen2,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Fallen));
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge());
 
        END_METHOD
         
        {Test}
        METHOD PUBLIC acknowledged_message_should_resets_the_WaitingForAcknowledge_but_keep_the_timestamps
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:58:12.123;
            expMessage.Fallen := LDATE_AND_TIME#2023-01-12-18:00:12.123;
            expMessage.Acknowledged := LDATE_AND_TIME#2023-01-12-18:02:12.123;
            
            //--Act
            //1st-PLC cycle: Rising of the message
            _rtc.SetNowUTC(expMessage.Risen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();
            //3rd-PLC cycle: Acknowledge of the message
            _rtc.SetNowUTC(expMessage.Acknowledged);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.AcknowledgeRequest := TRUE;
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgeRequest);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Fallen,_suti._object._messenger.Fallen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Acknowledged,_suti._object._messenger.Acknowledged));
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge());
 
        END_METHOD

        {Test}
        METHOD PUBLIC message_acknowledged_before_the_falling_should_save_the_time_stamp_of_the_acknowledgement_exactly_at_the_time_of_the_acknowledgement
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:58:12.123;
            expMessage.Acknowledged := LDATE_AND_TIME#2023-01-12-18:00:12.123;
            expMessage.Fallen := LDATE_AND_TIME#2023-01-12-18:02:12.123;
            
            //--Act
            //1st-PLC cycle: Rising of the message
            _rtc.SetNowUTC(expMessage.Risen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Acknowledge of the message 
            _rtc.SetNowUTC(expMessage.Acknowledged);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.AcknowledgeRequest := TRUE;
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgeRequest);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual( LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Fallen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Acknowledged,_suti._object._messenger.Acknowledged));
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge());
 
        END_METHOD

        {Test}
        METHOD PUBLIC message_acknowledged_before_the_falling_should_save_the_time_stamp_of_the_falling_exactly_at_the_time_of_the_falling
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Risen := LDATE_AND_TIME#2023-01-12-17:58:12.123;
            expMessage.Acknowledged := LDATE_AND_TIME#2023-01-12-18:00:12.123;
            expMessage.Fallen := LDATE_AND_TIME#2023-01-12-18:02:12.123;
            
            //--Act
            //1st-PLC cycle: Rising of the message
            _rtc.SetNowUTC(expMessage.Risen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Acknowledge of the message 
            _rtc.SetNowUTC(expMessage.Acknowledged);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.AcknowledgeRequest := TRUE;
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            //3rd-PLC cycle: Falling of the message
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category);
            _suti.Close();
            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge());
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgeRequest);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual( expMessage.Fallen,_suti._object._messenger.Fallen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Acknowledged,_suti._object._messenger.Acknowledged));
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge());
 
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_cause_null_reference
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            _suti.Open();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category).RequireAcknowledgement();
            _suti.InitializeRootObject( _suti._object);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(UINT#1,FALSE,expMessage.Category).RequireAcknowledgement();
            _suti.Close(); 
        END_METHOD
    END_CLASS
END_NAMESPACE


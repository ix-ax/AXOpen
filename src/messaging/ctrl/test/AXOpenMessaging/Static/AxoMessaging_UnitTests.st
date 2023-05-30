USING AXOpen.Core;
USING AxUnit;
USING AXOpen.Rtc;
USING AXOpen.Core;
USING AXOpen.Utils;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING System.Strings;
USING System.DateTime;

NAMESPACE AXOpen.AxoMessagingStatic_UnitTests
    CLASS TestContextI IMPLEMENTS IAxoContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
            _environment : IAxoContextEnvironment;	
        END_VAR       
        VAR PUBLIC       
            _object : TestObject;                 
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
    
        METHOD PUBLIC Environment : IAxoContextEnvironment
            Environment := _environment;
        END_METHOD
    END_CLASS  

    CLASS TestContextE EXTENDS MockAxoContext
  
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
    END_CLASS

    CLASS TestObject EXTENDS MockAxoObject
        VAR PUBLIC 
            _messenger : AxoMessenger;
        END_VAR
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
            _rtc : AxoRtcMock;
        END_VAR

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
            expected := LDATE_AND_TIME#2012-01-12-15:58:12.123;
            _rtc.SetNowUTC(expected);
            actual := _sute.GetRtc().NowUTC();
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate();
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
        END_METHOD

        {Test}
        METHOD PUBLIC isactive_should_be_true_in_the_next_PLC_cycle_in_case_of_activate_method_is_called_before_serve_method
            //--Act
            //1st PLC cycle
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Activate();
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);

            //--Assert
            //2nd
            _suti.Open();
            _suti._object._messenger.Activate();
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
        END_METHOD

        {Test}
        METHOD PUBLIC isactive_should_be_false_after_ActivateOnCondition_false_call
            //--Act
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
        END_METHOD

        {Test}
        METHOD PUBLIC isactive_should_be_true_after_ActivateOnCondition_true_call
            //--Act
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
        END_METHOD

        {Test}
        METHOD PUBLIC isactive_should_be_true_in_the_next_PLC_cycle_in_case_of_activateoncondition_method_is_called_before_serve_method
            //--Act
            //1st PLC cycle
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.ActivateOnCondition(TRUE);
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);

            //--Assert
            //2nd
            _suti.Open();
            _suti._object._messenger.ActivateOnCondition(TRUE);
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Stop calling of the Activate method
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            //_suti._object._messenger.Activate(expMessage.Category);   --- No Active method call in this PLC cycle
            _suti.Close();
            //3rd-PLC cycle: Falling of the message detection
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            //_suti._object._messenger.Activate(expMessage.Category);   --- No Active method call in this PLC cycle
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.Activate(expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category);
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).DoNotRequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgementRequired);

        END_METHOD
                
        
        {Test}
        METHOD PUBLIC WaitingForAcknowledge_should_be_true_after_falling_of_the_message_that_require_acknowledgement
            //--Act
            //1st-PLC cycle: Rising of the message
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE);
            _suti.Close();

            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
            Assert.Equal(TRUE, _suti._object._messenger.WaitingForAcknowledge);
 
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();
            //3rd-PLC cycle: Rising of the message again
            _rtc.SetNowUTC(Risen2);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(Risen2,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Fallen));
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge);
 
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Falling of the message
            _rtc.SetNowUTC(expMessage.Fallen);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();
            //3rd-PLC cycle: Acknowledge of the message
            _rtc.SetNowUTC(expMessage.Acknowledged);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.AcknowledgeRequest := TRUE;
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge);
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgeRequest);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Fallen,_suti._object._messenger.Fallen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Acknowledged,_suti._object._messenger.Acknowledged));
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge);
 
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
            _suti.Close();
            //2nd-PLC cycle: Acknowledge of the message 
            _rtc.SetNowUTC(expMessage.Acknowledged);
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object._messenger.AcknowledgeRequest := TRUE;
            _suti._object._messenger.Serve(_suti._object);
            _suti.Close();
            //--Assert
            Assert.Equal(TRUE, _suti._object._messenger.IsActive);
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge);
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgeRequest);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual( LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.Fallen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Acknowledged,_suti._object._messenger.Acknowledged));
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge);
 
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
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(TRUE,expMessage.Category).RequireAcknowledgement();
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
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category);
            _suti.Close();
            //--Assert
            Assert.Equal(FALSE, _suti._object._messenger.IsActive);
            Assert.Equal(TRUE, _suti._object._messenger.AcknowledgementRequired);
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge);
            Assert.Equal(FALSE, _suti._object._messenger.AcknowledgeRequest);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Risen,_suti._object._messenger.Risen));
            Assert.Equal(TRUE,THIS.AreEqual( expMessage.Fallen,_suti._object._messenger.Fallen));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.Acknowledged,_suti._object._messenger.Acknowledged));
            Assert.Equal(FALSE, _suti._object._messenger.WaitingForAcknowledge);
 
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_cause_null_reference
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category).RequireAcknowledgement();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Serve(_suti._object);
            _suti._object._messenger.ActivateOnCondition(FALSE,expMessage.Category).RequireAcknowledgement();
            _suti.Close(); 
        END_METHOD
    END_CLASS
END_NAMESPACE


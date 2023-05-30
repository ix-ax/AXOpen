USING AxUnit;
USING AXOpen.Rtc;
USING AXOpen.Core;
USING AXOpen.Utils;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Dynamic;
USING System.Strings;
USING System.DateTime;

NAMESPACE AXOpen.AxoMessagingDynamic_UnitTests
    CLASS TestContextI IMPLEMENTS IAxoContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
            _environment : MockAxoContextEnvironment;	
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
            Text : STRING;
            Category   : eAxoMessageCategory;
            TimeStamp : LDATE_AND_TIME;
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
        METHOD PUBLIC message_of_debug_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is a debug message';
            expMessage.Category := eAxoMessageCategory#Debug;
            expMessage.TimeStamp := LDATE_AND_TIME#2023-01-12-17:58:12.123;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Debug(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_trace_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is a trace message';
            expMessage.Category := eAxoMessageCategory#Trace;
            expMessage.TimeStamp := LDATE_AND_TIME#2019-01-12-17:58:12.123;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Trace(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_notify_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is a notification message';
            expMessage.Category := eAxoMessageCategory#Notification;
            expMessage.TimeStamp := LDATE_AND_TIME#2023-01-10-17:58:12.123;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Notify(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_warning_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is a warning message';
            expMessage.Category := eAxoMessageCategory#Warning;
            expMessage.TimeStamp := LDATE_AND_TIME#2023-01-09-17:58:12.123;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Warning(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_error_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is an error message';
            expMessage.Category := eAxoMessageCategory#Error;
            expMessage.TimeStamp := LDATE_AND_TIME#2023-01-12-17:12:12.123;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Error(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
        END_METHOD

        {Test}
        METHOD PUBLIC message_of_info_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is an info message';
            expMessage.Category := eAxoMessageCategory#Info;
            expMessage.TimeStamp := LDATE_AND_TIME#2023-01-12-17:58:04.123;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Info(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_programming_error_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is a programming error message';
            expMessage.Category := eAxoMessageCategory#ProgrammingError;
            expMessage.TimeStamp := LDATE_AND_TIME#2023-01-12-17:58:12.321;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Programming(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_critical_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is a critical message';
            expMessage.Category := eAxoMessageCategory#Critical;
            expMessage.TimeStamp := LDATE_AND_TIME#2000-01-12-17:58:12.123;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Critical(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC message_of_catastrophic_category_should_be_placed_inside_mime
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is a catastrophic message';
            expMessage.Category := eAxoMessageCategory#Catastrophic;
            expMessage.TimeStamp := LDATE_AND_TIME#1980-01-12-17:58:12.123;
            
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Catastrophic(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC clear
            VAR
                expMessage : TestMessage;
            END_VAR
            //--Arrange
            expMessage.Text := 'this is a catastrophic message';
            expMessage.Category := eAxoMessageCategory#Catastrophic;
            expMessage.TimeStamp := LDATE_AND_TIME#1980-01-12-17:58:12.123;
            Assert.Equal(FALSE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));
            _rtc.SetNowUTC(expMessage.TimeStamp);

            //--Act
            _suti.InjectRtc(_rtc);
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti._object._messenger.Catastrophic(expMessage.Text);
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessage.Category));
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

            //--Arrange
            expMessage.Text := '';
            expMessage.TimeStamp := LDATE_AND_TIME#1970-01-01-00:00:00.000;

            //--Act
            _suti._object._messenger.Clear();

            //--Assert
            Assert.Equal(expMessage.Text, _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eAxoMessageCategory#All));
            Assert.Equal(ULINT#0, _suti._object._messenger.GetMime().Cycle);
            Assert.Equal(ULINT#0, _suti._object._messenger.GetMime().Identity);
            Assert.Equal(USINT#0, _suti._object._messenger.GetMime().PerCycleCount);
            Assert.Equal(TRUE,THIS.AreEqual(expMessage.TimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC PostLevelUpSeverity
            VAR
                Index : INT;
                expMessages : ARRAY [0..9] OF TestMessage := [
                    (Text :='trace',                Category := eAxoMessageCategory#Trace,               TimeStamp := LDATE_AND_TIME#2000-01-02-03:04:05.006),
                    (Text :='debug',                Category := eAxoMessageCategory#Debug,               TimeStamp := LDATE_AND_TIME#2001-02-03-04:05:06.007),
                    (Text :='info',                 Category := eAxoMessageCategory#Info,                TimeStamp := LDATE_AND_TIME#2002-03-04-05:06:07.008),
                    (Text :='timedOut',             Category := eAxoMessageCategory#TimedOut,            TimeStamp := LDATE_AND_TIME#2003-04-05-06:07:08.009),
                    (Text :='notification',         Category := eAxoMessageCategory#Notification,        TimeStamp := LDATE_AND_TIME#2004-05-06-07:08:09.010),
                    (Text :='warning',              Category := eAxoMessageCategory#Warning,             TimeStamp := LDATE_AND_TIME#2005-06-07-08:09:10.011),
                    (Text :='error',                Category := eAxoMessageCategory#Error,               TimeStamp := LDATE_AND_TIME#2006-07-08-09:10:11.012),
                    (Text :='programming error',    Category := eAxoMessageCategory#ProgrammingError,    TimeStamp := LDATE_AND_TIME#2007-08-09-10:11:12.013),
                    (Text :='critical',             Category := eAxoMessageCategory#Critical,            TimeStamp := LDATE_AND_TIME#2008-09-10-11:12:13.014),
                    (Text :='catastrophic',         Category := eAxoMessageCategory#Catastrophic,        TimeStamp := LDATE_AND_TIME#2009-10-11-12:13:14.015)
                ];
            END_VAR

            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            FOR Index := 0 TO 9 DO
                //--Arrange/Act
                _rtc.SetNowUTC(expMessages[Index].Timestamp);
                _suti.InjectRtc(_rtc);
                _suti._object._messenger.Post(expMessages[Index].Text,expMessages[Index].Category);
            
                //--Assert
                Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
                Assert.Equal(expMessages[Index].Text, _suti._object._messenger.GetMime().Text);
                Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessages[Index].Category));
                Assert.Equal(TRUE,THIS.AreEqual(expMessages[Index].Timestamp,_suti._object._messenger.GetMime().TimeStamp ));
            END_FOR;

        END_METHOD

        {Test}
        METHOD PUBLIC SuspendResumeTest
            VAR
                expected : LDATE_AND_TIME;
                messageText : STRING;
            END_VAR

            //--Arrange
            messageText := 'this is a message';
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Close();
            
            //--Act
            
            // Suspend
            _suti.Open();
            _suti.Environment().Messaging().Suspend();
            _suti.Close();

            _suti.Open();
            _suti._object._messenger.Post(messageText,eAxoMessageCategory#Catastrophic);
            _suti.Close();
            
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            
            // Resume
            _suti.Open();
            _suti.Environment().Messaging().Resume();
            _suti.Close();

            _suti.Open();
            _suti._object._messenger.Post(messageText,eAxoMessageCategory#Catastrophic);
            _suti.Close();
            
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            
        END_METHOD

        {Test}
        METHOD PUBLIC SetMinMessageCategoryTest
            VAR
                expected : LDATE_AND_TIME;
                messageText : STRING;
            END_VAR

            //--Arrange
            messageText := 'this is a message';
            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Close();
            
            //--Act
            
            // Set min level to info
            _suti.Open();
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#Info);
            _suti.Close();

            _suti.Open();
            _suti._object._messenger.Post(messageText,eAxoMessageCategory#Info);
            _suti.Close();
            
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            
            // Set min level to catastrophic
            _suti.Open();
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#Catastrophic);
            _suti.Close();

            _suti.Open();
            _suti._object._messenger.Post(messageText,eAxoMessageCategory#Info);
            _suti.Close();
            
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            
        END_METHOD

        {Test}
        METHOD PUBLIC OnConditionMessageTest_true
            VAR
                Index : INT;
                expMessages : ARRAY [0..9] OF TestMessage := [
                    (Text :='This is the trace message',                Category := eAxoMessageCategory#Trace,               TimeStamp := LDATE_AND_TIME#2000-01-02-03:04:05.006),
                    (Text :='This is the debug message',                Category := eAxoMessageCategory#Debug,               TimeStamp := LDATE_AND_TIME#2001-02-03-04:05:06.007),
                    (Text :='This is the info message',                 Category := eAxoMessageCategory#Info,                TimeStamp := LDATE_AND_TIME#2002-03-04-05:06:07.008),
                    (Text :='This is the timedOut message',             Category := eAxoMessageCategory#TimedOut,            TimeStamp := LDATE_AND_TIME#2003-04-05-06:07:08.009),
                    (Text :='This is the notification message',         Category := eAxoMessageCategory#Notification,        TimeStamp := LDATE_AND_TIME#2004-05-06-07:08:09.010),
                    (Text :='This is the warning message',              Category := eAxoMessageCategory#Warning,             TimeStamp := LDATE_AND_TIME#2005-06-07-08:09:10.011),
                    (Text :='This is the error message',                Category := eAxoMessageCategory#Error,               TimeStamp := LDATE_AND_TIME#2006-07-08-09:10:11.012),
                    (Text :='This is the programming error message',    Category := eAxoMessageCategory#ProgrammingError,    TimeStamp := LDATE_AND_TIME#2007-08-09-10:11:12.013),
                    (Text :='This is the critical message',             Category := eAxoMessageCategory#Critical,            TimeStamp := LDATE_AND_TIME#2008-09-10-11:12:13.014),
                    (Text :='This is the catastrophic message',         Category := eAxoMessageCategory#Catastrophic,        TimeStamp := LDATE_AND_TIME#2009-10-11-12:13:14.015)
                ];
            END_VAR

            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            FOR Index := 0 TO 9 DO
                //--Arrange/Act
                _suti.Open();
                _rtc.SetNowUTC(expMessages[Index].Timestamp);
                _suti.InjectRtc(_rtc);
                _suti._object._messenger.Clear();
                _suti._object._messenger.OnCondition(TRUE).Post(expMessages[Index].Text,expMessages[Index].Category); 
                _suti.Close();
            
                //--Assert
                Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
                Assert.Equal(expMessages[Index].Text, _suti._object._messenger.GetMime().Text);
                Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessages[Index].Category));
                Assert.Equal(TRUE,THIS.AreEqual(expMessages[Index].Timestamp,_suti._object._messenger.GetMime().TimeStamp ));
            END_FOR;
            
        END_METHOD


        {Test}
        METHOD PUBLIC OnConditionMessageTest_false
            VAR
                Index : INT;
                expMessages : ARRAY [0..9] OF TestMessage := [
                    (Text :='This is the trace message',                Category := eAxoMessageCategory#Trace,               TimeStamp := LDATE_AND_TIME#2000-01-02-03:04:05.006),
                    (Text :='This is the debug message',                Category := eAxoMessageCategory#Debug,               TimeStamp := LDATE_AND_TIME#2001-02-03-04:05:06.007),
                    (Text :='This is the info message',                 Category := eAxoMessageCategory#Info,                TimeStamp := LDATE_AND_TIME#2002-03-04-05:06:07.008),
                    (Text :='This is the timedOut message',             Category := eAxoMessageCategory#TimedOut,            TimeStamp := LDATE_AND_TIME#2003-04-05-06:07:08.009),
                    (Text :='This is the notification message',         Category := eAxoMessageCategory#Notification,        TimeStamp := LDATE_AND_TIME#2004-05-06-07:08:09.010),
                    (Text :='This is the warning message',              Category := eAxoMessageCategory#Warning,             TimeStamp := LDATE_AND_TIME#2005-06-07-08:09:10.011),
                    (Text :='This is the error message',                Category := eAxoMessageCategory#Error,               TimeStamp := LDATE_AND_TIME#2006-07-08-09:10:11.012),
                    (Text :='This is the programming error message',    Category := eAxoMessageCategory#ProgrammingError,    TimeStamp := LDATE_AND_TIME#2007-08-09-10:11:12.013),
                    (Text :='This is the critical message',             Category := eAxoMessageCategory#Critical,            TimeStamp := LDATE_AND_TIME#2008-09-10-11:12:13.014),
                    (Text :='This is the catastrophic message',         Category := eAxoMessageCategory#Catastrophic,        TimeStamp := LDATE_AND_TIME#2009-10-11-12:13:14.015)
                ];
            END_VAR

            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            FOR Index := 0 TO 9 DO
                //--Arrange/Act
                _suti.Open();
                _rtc.SetNowUTC(expMessages[Index].Timestamp);
                _suti.InjectRtc(_rtc);
                _suti._object._messenger.Clear();
                _suti._object._messenger.OnCondition(FALSE).Post(expMessages[Index].Text,expMessages[Index].Category); 
                _suti.Close();

                //--Assert
                Assert.Equal(ULINT#0, _suti._object._messenger.GetMime().Cycle);
                Assert.Equal('', _suti._object._messenger.GetMime().Text);
                Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eAxoMessageCategory#All));
                Assert.Equal(TRUE,THIS.AreEqual(LDATE_AND_TIME#1970-01-01-00:00:00.000,_suti._object._messenger.GetMime().TimeStamp ));
            END_FOR;
            
        END_METHOD

        {Test}
        METHOD PUBLIC PersistMessageTest
            VAR
                Index : INT;
                expMessages : ARRAY [0..9] OF TestMessage := [
                    (Text :='This is the trace message',                Category := eAxoMessageCategory#Trace,               TimeStamp := LDATE_AND_TIME#2000-01-02-03:04:05.006),
                    (Text :='This is the debug message',                Category := eAxoMessageCategory#Debug,               TimeStamp := LDATE_AND_TIME#2001-02-03-04:05:06.007),
                    (Text :='This is the info message',                 Category := eAxoMessageCategory#Info,                TimeStamp := LDATE_AND_TIME#2002-03-04-05:06:07.008),
                    (Text :='This is the timedOut message',             Category := eAxoMessageCategory#TimedOut,            TimeStamp := LDATE_AND_TIME#2003-04-05-06:07:08.009),
                    (Text :='This is the notification message',         Category := eAxoMessageCategory#Notification,        TimeStamp := LDATE_AND_TIME#2004-05-06-07:08:09.010),
                    (Text :='This is the warning message',              Category := eAxoMessageCategory#Warning,             TimeStamp := LDATE_AND_TIME#2005-06-07-08:09:10.011),
                    (Text :='This is the error message',                Category := eAxoMessageCategory#Error,               TimeStamp := LDATE_AND_TIME#2006-07-08-09:10:11.012),
                    (Text :='This is the programming error message',    Category := eAxoMessageCategory#ProgrammingError,    TimeStamp := LDATE_AND_TIME#2007-08-09-10:11:12.013),
                    (Text :='This is the critical message',             Category := eAxoMessageCategory#Critical,            TimeStamp := LDATE_AND_TIME#2008-09-10-11:12:13.014),
                    (Text :='This is the catastrophic message',         Category := eAxoMessageCategory#Catastrophic,        TimeStamp := LDATE_AND_TIME#2009-10-11-12:13:14.015)
                ];
            END_VAR

            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            FOR Index := 0 TO 9 DO
                //--Arrange/Act
                _suti.Open();
                _rtc.SetNowUTC(expMessages[Index].Timestamp);
                _suti.InjectRtc(_rtc);
                _suti._object._messenger.Clear();
                _suti._object._messenger.Post(expMessages[Index].Text,expMessages[Index].Category).Pin(); 
                _suti.Close();
            
                //--Assert
                Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
                Assert.Equal(expMessages[Index].Text, _suti._object._messenger.GetMime().Text);
                Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessages[Index].Category));
                Assert.Equal(TRUE,THIS.AreEqual(expMessages[Index].Timestamp,_suti._object._messenger.GetMime().TimeStamp ));
                Assert.Equal(TRUE,_suti._object._messenger.IsPinned());
            END_FOR;
            
        END_METHOD

        {Test}
        METHOD PUBLIC DontPersistMessageTest
            VAR
                Index : INT;
                expMessages : ARRAY [0..9] OF TestMessage := [
                    (Text :='This is the trace message',                Category := eAxoMessageCategory#Trace,               TimeStamp := LDATE_AND_TIME#2000-01-02-03:04:05.006),
                    (Text :='This is the debug message',                Category := eAxoMessageCategory#Debug,               TimeStamp := LDATE_AND_TIME#2001-02-03-04:05:06.007),
                    (Text :='This is the info message',                 Category := eAxoMessageCategory#Info,                TimeStamp := LDATE_AND_TIME#2002-03-04-05:06:07.008),
                    (Text :='This is the timedOut message',             Category := eAxoMessageCategory#TimedOut,            TimeStamp := LDATE_AND_TIME#2003-04-05-06:07:08.009),
                    (Text :='This is the notification message',         Category := eAxoMessageCategory#Notification,        TimeStamp := LDATE_AND_TIME#2004-05-06-07:08:09.010),
                    (Text :='This is the warning message',              Category := eAxoMessageCategory#Warning,             TimeStamp := LDATE_AND_TIME#2005-06-07-08:09:10.011),
                    (Text :='This is the error message',                Category := eAxoMessageCategory#Error,               TimeStamp := LDATE_AND_TIME#2006-07-08-09:10:11.012),
                    (Text :='This is the programming error message',    Category := eAxoMessageCategory#ProgrammingError,    TimeStamp := LDATE_AND_TIME#2007-08-09-10:11:12.013),
                    (Text :='This is the critical message',             Category := eAxoMessageCategory#Critical,            TimeStamp := LDATE_AND_TIME#2008-09-10-11:12:13.014),
                    (Text :='This is the catastrophic message',         Category := eAxoMessageCategory#Catastrophic,        TimeStamp := LDATE_AND_TIME#2009-10-11-12:13:14.015)
                ];
            END_VAR

            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            FOR Index := 0 TO 9 DO
                //--Arrange/Act
                _suti.Open();
                _rtc.SetNowUTC(expMessages[Index].Timestamp);
                _suti.InjectRtc(_rtc);
                _suti._object._messenger.Clear();
                _suti._object._messenger.Post(expMessages[Index].Text,expMessages[Index].Category); 
                _suti.Close();
            
                //--Assert
                Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
                Assert.Equal(expMessages[Index].Text, _suti._object._messenger.GetMime().Text);
                Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,expMessages[Index].Category));
                Assert.Equal(TRUE,THIS.AreEqual(expMessages[Index].Timestamp,_suti._object._messenger.GetMime().TimeStamp ));
                Assert.Equal(FALSE,_suti._object._messenger.IsPinned());
            END_FOR;
            
        END_METHOD

        {Test}
        METHOD PUBLIC PersistentMessageUnpinTest
            VAR
                Index : INT;
                expMessages : ARRAY [0..9] OF TestMessage := [
                    (Text :='This is the trace message',                Category := eAxoMessageCategory#Trace,               TimeStamp := LDATE_AND_TIME#2000-01-02-03:04:05.006),
                    (Text :='This is the debug message',                Category := eAxoMessageCategory#Debug,               TimeStamp := LDATE_AND_TIME#2001-02-03-04:05:06.007),
                    (Text :='This is the info message',                 Category := eAxoMessageCategory#Info,                TimeStamp := LDATE_AND_TIME#2002-03-04-05:06:07.008),
                    (Text :='This is the timedOut message',             Category := eAxoMessageCategory#TimedOut,            TimeStamp := LDATE_AND_TIME#2003-04-05-06:07:08.009),
                    (Text :='This is the notification message',         Category := eAxoMessageCategory#Notification,        TimeStamp := LDATE_AND_TIME#2004-05-06-07:08:09.010),
                    (Text :='This is the warning message',              Category := eAxoMessageCategory#Warning,             TimeStamp := LDATE_AND_TIME#2005-06-07-08:09:10.011),
                    (Text :='This is the error message',                Category := eAxoMessageCategory#Error,               TimeStamp := LDATE_AND_TIME#2006-07-08-09:10:11.012),
                    (Text :='This is the programming error message',    Category := eAxoMessageCategory#ProgrammingError,    TimeStamp := LDATE_AND_TIME#2007-08-09-10:11:12.013),
                    (Text :='This is the critical message',             Category := eAxoMessageCategory#Critical,            TimeStamp := LDATE_AND_TIME#2008-09-10-11:12:13.014),
                    (Text :='This is the catastrophic message',         Category := eAxoMessageCategory#Catastrophic,        TimeStamp := LDATE_AND_TIME#2009-10-11-12:13:14.015)
                ];
            END_VAR

            _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            FOR Index := 0 TO 9 DO
                //--Arrange/Act
                _suti.Open();
                _suti._object._messenger.Clear();
                _suti._object._messenger.Post(expMessages[Index].Text,expMessages[Index].Category).Pin(); 
                _suti.Close();

                _suti.Open();
                _suti.Close();

                _suti.Open();
                _suti._object._messenger.Post(expMessages[Index].Text,expMessages[Index].Category); 
                _suti.Close();
        
                //--Assert
                Assert.Equal(TRUE,_suti._object._messenger.IsPinned());

                //--Act
                _suti.Open();
                _suti._object._messenger.UnPin();
                _suti.Close();

                _suti.Open();
                _suti.Close();

                _suti.Open();
                _suti._object._messenger.Post(expMessages[Index].Text,expMessages[Index].Category); 
                _suti.Close();

                //--Assert
                Assert.Equal(FALSE,_suti._object._messenger.IsPinned());
            END_FOR;
            
        END_METHOD

        {Test}
        METHOD PUBLIC AsTrace
            VAR 
                expTimeStamp : LDATE_AND_TIME:= LDATE_AND_TIME#2023-01-09-17:58:12.123;
            END_VAR
             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _rtc.SetNowUTC(expTimeStamp);
            _suti.InjectRtc(_rtc);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append('Text 1').Append('Text 2').Append(REAL#10.5).As().AsTrace();
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal('Text 1Text 210.500000000', _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eAxoMessageCategory#Trace));
            Assert.Equal(TRUE,THIS.AreEqual(expTimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC AsDebug
            VAR 
                expTimeStamp : LDATE_AND_TIME:= LDATE_AND_TIME#2020-01-09-17:58:12.123;
            END_VAR
             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _rtc.SetNowUTC(expTimeStamp);
            _suti.InjectRtc(_rtc);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append('Text 1').Append('Text 2').Append(UINT#23).As().AsDebug();
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal('Text 1Text 223', _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eAxoMessageCategory#Debug));
            Assert.Equal(TRUE,THIS.AreEqual(expTimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC AsInfo
            VAR 
                expTimeStamp : LDATE_AND_TIME:= LDATE_AND_TIME#2020-01-09-17:58:12.123;
            END_VAR
             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _rtc.SetNowUTC(expTimeStamp);
            _suti.InjectRtc(_rtc);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append('Text 1').Append('Text 2').Append(LREAL#43.123).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal('Text 1Text 243.123000000', _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eAxoMessageCategory#Info));
            Assert.Equal(TRUE,THIS.AreEqual(expTimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC AsWarning
            VAR 
                expTimeStamp : LDATE_AND_TIME:= LDATE_AND_TIME#2020-01-09-17:58:12.123;
            END_VAR
             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _rtc.SetNowUTC(expTimeStamp);
            _suti.InjectRtc(_rtc);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append('Text 1').Append('Text 2').Append(UDINT#123456).As().AsWarning();
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal('Text 1Text 2123456', _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eAxoMessageCategory#Warning));
            Assert.Equal(TRUE,THIS.AreEqual(expTimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC AsError
            VAR 
                expTimeStamp : LDATE_AND_TIME:= LDATE_AND_TIME#2020-01-09-17:58:12.123;
            END_VAR
             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _rtc.SetNowUTC(expTimeStamp);
            _suti.InjectRtc(_rtc);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append('Text 1').Append('Text 2').Append(ULINT#123456789).As().AsError();
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal('Text 1Text 2123456789', _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eAxoMessageCategory#Error));
            Assert.Equal(TRUE,THIS.AreEqual(expTimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC AsFatal
            VAR 
                expTimeStamp : LDATE_AND_TIME:= LDATE_AND_TIME#2020-01-09-17:58:12.123;
            END_VAR
             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _rtc.SetNowUTC(expTimeStamp);
            _suti.InjectRtc(_rtc);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append('Text 1').Append('Text 2').Append(BYTE#16#AB).As().AsFatal();
            _suti.Close();

            //--Assert
            Assert.Equal(_suti.OpenCycleCount(), _suti._object._messenger.GetMime().Cycle);
            Assert.Equal('Text 1Text 20xAB', _suti._object._messenger.GetMime().Text);
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eAxoMessageCategory#Fatal));
            Assert.Equal(TRUE,THIS.AreEqual(expTimeStamp,_suti._object._messenger.GetMime().TimeStamp ));

        END_METHOD

        {Test}
        METHOD PUBLIC AppendBool

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(TRUE).Append(FALSE).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('truefalse', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendByte

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(BYTE#12).Append(BYTE#56).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('0x0C0x38', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendWord

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(WORD#60000).Append(WORD#16#1234).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('0xEA600x1234', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendDWord

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(DWORD#50000).Append(DWORD#16#ABCD_EF01).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('0x0000C3500xABCDEF01', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendLWord

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(LWORD#1234567891234567890).Append(LWORD#16#65FE561A6FE28512).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('0x112210F4C023B6D20x65FE561A6FE28512', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendSint

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(SINT#-12).Append(SINT#-56).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('-12-56', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendInt

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(INT#32767).Append(INT#-32768).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('32767-32768', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendDint

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(DINT#-536862720).Append(DINT#1073725440).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('-5368627201073725440', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendLint

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(LINT#-18494920704025).Append(LINT#-92474603520125).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('-18494920704025-92474603520125', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendUsint

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(USINT#56).Append(USINT#12).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('5612', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendUint

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(UINT#32767).Append(UINT#65535).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('3276765535', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendUdint

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(UDINT#536862720).Append(DINT#1073725440).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('5368627201073725440', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendUlint

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(ULINT#18494920704025).Append(ULINT#92474603520125).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('1849492070402592474603520125', _suti._object._messenger.GetMime().Text);
        END_METHOD

        {Test}
        METHOD PUBLIC AppendReal

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(REAL#50123.0).Append(REAL#50123.123456).As().AsInfo();
            _suti.Close();

            //--Assert
            // Assert.Equal('5012350123.123456000', _suti._object._messenger.GetMime().Text); //TODO ask Siemens guys why it returns 5012350123.125000000
        END_METHOD

        {Test}
        METHOD PUBLIC AppendLreal

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(LREAL#123456.0).Append(REAL#123456.123456789123456789).As().AsInfo();
            _suti.Close();

            //--Assert
            //Assert.Equal('123456123456.123456789123456789', _suti._object._messenger.GetMime().Text); //TODO ask Siemens guys why it returns 123456123456.125000000
        END_METHOD

        {Test}
        METHOD PUBLIC AppendTime

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(TIME#1d2h4m8s16ms).Append(TIME#2d6h23m11s01ms).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('1D_2H_4M_8S_16MS2D_6H_23M_11S_1MS', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendLtime

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(LTIME#65536d2h4m8s16ms).Append(TIME#106751d6h23m11s01ms).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('65536D_2H_4M_8S_16MS106751D_6H_23M_11S_1MS', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendDate

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(DATE#1980-01-23).Append(DATE#2040-12-25).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('1980-01-232040-12-25', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendLdate

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(LDATE#2023-04-15).Append(DATE#1970-11-23).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('2023-04-151970-11-23', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendTimeOfDay

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(TOD#13:14:33.123).Append(TOD#23:59:48.123).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('13:14:33.12300000023:59:48.123000000', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendLtimeOfDay

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(LTOD#13:14:33.123456).Append(LTOD#23:59:48.123456).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('13:14:33.12345600023:59:48.123456000', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendDateAndTime

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(DT#1980-01-23-13:14:33.123).Append(DT#2040-01-23-13:14:33.123).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('1980-01-23T13:14:33.1230000002040-01-23T13:14:33.123000000', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendLdateAndTime

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(LDT#1980-01-23-13:14:33.123456789).Append(LDT#2040-01-23-13:14:33.123456789).As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('1980-01-23T13:14:33.1234567892040-01-23T13:14:33.123456789', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendChar

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append(CHAR#'A').Append(CHAR#'X').As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('AX', _suti._object._messenger.GetMime().Text); 
        END_METHOD

        {Test}
        METHOD PUBLIC AppendString

             //--Arrange
             _suti.Open();
            _suti._object.Initialize(_suti);
            _suti._object._messenger.Initialize(_suti._object);
            _suti.Environment().Messaging().SetMinLevel(eAxoMessageCategory#All);
            _suti.Environment().Messaging().SetMessageDigestMethod(eAxoMessageDigestMethod#CRC32);
            _suti.Close();

            //--Act
            _suti.Open();
            _suti._object._messenger.Build().Append('AX# ').Append('is an incredibly powerful platform!').As().AsInfo();
            _suti.Close();

            //--Assert
            Assert.Equal('AX# is an incredibly powerful platform!', _suti._object._messenger.GetMime().Text); 
        END_METHOD




    END_CLASS
END_NAMESPACE


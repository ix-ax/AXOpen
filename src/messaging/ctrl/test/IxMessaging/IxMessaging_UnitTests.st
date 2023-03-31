USING ix.framework.core;
USING ix.framework.messaging;
USING AxUnit;
USING ix.framework.rtc;
USING ix.framework.core;
USING ix.framework.utils;
USING System.Strings;
USING System.DateTime;

NAMESPACE ix.core.IxMessaging_Tests
    CLASS TestContextI IMPLEMENTS ix.framework.core.IIxContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
            _environment : IxContextEnvironment;	
        END_VAR       
        VAR PUBLIC       
            _object : TestObject;                 
        END_VAR      
        VAR PRIVATE            
            NULL_RTC : _NULL_RTC;
            _rtc : IRtc;
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

        METHOD PUBLIC GetRtc : IRtc
            IF(_rtc <> NULL) THEN
                GetRtc := _rtc;
            ELSE
                GetRtc := NULL_RTC;    
            END_IF;    
        END_METHOD

        METHOD PUBLIC InjectRtc
            VAR_INPUT
                Rtc : IRtc;
            END_VAR
            _rtc := Rtc;
        END_METHOD
    
        METHOD PUBLIC Environment : IIxContextEnvironment
            Environment := _environment;
        END_METHOD
    END_CLASS  

    CLASS TestContextE EXTENDS IxContext
  
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
    END_CLASS

    CLASS TestObject EXTENDS IxObject
        VAR PUBLIC 
            _messenger : IxMessenger;
        END_VAR
    END_CLASS

    CLASS IxRtcMock IMPLEMENTS IRtc
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
            Category   : eIxMessageCategory;
            TimeStamp : LDATE_AND_TIME;
        END_STRUCT;
    END_TYPE

    {TestFixture}
    CLASS IxMessenger_UnitTests
        VAR PRIVATE
            _suti : TestContextI;
            _sute : TestContextE;
            _rtc : IxRtcMock;
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
                 expected:  eIxMessageCategory;
                 actual:  eIxMessageCategory;
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
            expMessage.Category := eIxMessageCategory#Debug;
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
            expMessage.Category := eIxMessageCategory#Trace;
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
            expMessage.Category := eIxMessageCategory#Notification;
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
            expMessage.Category := eIxMessageCategory#Warning;
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
            expMessage.Category := eIxMessageCategory#Error;
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
            expMessage.Category := eIxMessageCategory#Info;
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
            expMessage.Category := eIxMessageCategory#ProgrammingError;
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
            expMessage.Category := eIxMessageCategory#Critical;
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
            expMessage.Category := eIxMessageCategory#Catastrophic;
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
            expMessage.Category := eIxMessageCategory#Catastrophic;
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
            Assert.Equal(TRUE,THIS.AreEqual(_suti._object._messenger.GetMime().Category,eIxMessageCategory#All));
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
                    (Text :='trace',                Category := eIxMessageCategory#Trace,               TimeStamp := LDATE_AND_TIME#2000-01-02-03:04:05.006),
                    (Text :='debug',                Category := eIxMessageCategory#Debug,               TimeStamp := LDATE_AND_TIME#2001-02-03-04:05:06.007),
                    (Text :='info',                 Category := eIxMessageCategory#Info,                TimeStamp := LDATE_AND_TIME#2002-03-04-05:06:07.008),
                    (Text :='timedOut',             Category := eIxMessageCategory#TimedOut,            TimeStamp := LDATE_AND_TIME#2003-04-05-06:07:08.009),
                    (Text :='notification',         Category := eIxMessageCategory#Notification,        TimeStamp := LDATE_AND_TIME#2004-05-06-07:08:09.010),
                    (Text :='warning',              Category := eIxMessageCategory#Warning,             TimeStamp := LDATE_AND_TIME#2005-06-07-08:09:10.011),
                    (Text :='error',                Category := eIxMessageCategory#Error,               TimeStamp := LDATE_AND_TIME#2006-07-08-09:10:11.012),
                    (Text :='programming error',    Category := eIxMessageCategory#ProgrammingError,    TimeStamp := LDATE_AND_TIME#2007-08-09-10:11:12.013),
                    (Text :='critical',             Category := eIxMessageCategory#Critical,            TimeStamp := LDATE_AND_TIME#2008-09-10-11:12:13.014),
                    (Text :='catastrophic',         Category := eIxMessageCategory#Catastrophic,        TimeStamp := LDATE_AND_TIME#2009-10-11-12:13:14.015)
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
            _suti._object._messenger.Post(messageText,eIxMessageCategory#Catastrophic);
            _suti.Close();
            
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            
            // Resume
            _suti.Open();
            _suti.Environment().Messaging().Resume();
            _suti.Close();

            _suti.Open();
            _suti._object._messenger.Post(messageText,eIxMessageCategory#Catastrophic);
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
            _suti.Environment().Messaging().SetMinLevel(eIxMessageCategory#Info);
            _suti.Close();

            _suti.Open();
            _suti._object._messenger.Post(messageText,eIxMessageCategory#Info);
            _suti.Close();
            
            Assert.Equal(TRUE, _suti._object._messenger.IsActive());
            
            // Set min level to catastrophic
            _suti.Open();
            _suti.Environment().Messaging().SetMinLevel(eIxMessageCategory#Catastrophic);
            _suti.Close();

            _suti.Open();
            _suti._object._messenger.Post(messageText,eIxMessageCategory#Info);
            _suti.Close();
            
            Assert.Equal(FALSE, _suti._object._messenger.IsActive());
            
        END_METHOD

    END_CLASS
END_NAMESPACE


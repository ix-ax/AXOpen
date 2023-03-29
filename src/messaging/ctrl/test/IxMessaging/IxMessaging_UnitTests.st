USING ix.framework.messaging;
USING AxUnit;
USING ix.framework.rtc;
USING ix.framework.core;
USING ix.framework.utils;

NAMESPACE ix.core.IxMessaging_Tests
    CLASS TestContextI IMPLEMENTS ix.framework.core.IIxContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
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

        VAR PRIVATE            
            NULL_RTC : _NULL_RTC;
            _rtc : IRtc;
        END_VAR
    
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
    END_CLASS  

    CLASS TestContextE EXTENDS IxContext
  
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
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

    {TestFixture}
    CLASS IxMessenger_UnitTests
        VAR PRIVATE
            _suci : TestContextI;
            _suce : TestContextE;
            _rtc : IxRtcMock;
        END_VAR

        METHOD Equal : BOOL
            VAR_INPUT
                 expected:  LDATE_AND_TIME;
                 actual:  LDATE_AND_TIME;
            END_VAR
            Equal := expected = actual;
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
            actual := _suce.GetRtc().NowUTC();
            Assert.Equal(FALSE, THIS.Equal(expected,actual));
            //Act
            _suce.InjectRtc(_rtc);
            //Assert
            actual := _suce.GetRtc().NowUTC();
            Assert.Equal(TRUE, THIS.Equal(expected,actual));
        END_METHOD
    END_CLASS



END_NAMESPACE


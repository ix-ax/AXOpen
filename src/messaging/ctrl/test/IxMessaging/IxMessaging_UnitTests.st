USING ix.framework.messaging;
USING AxUnit;
USING ix.framework.rtc;
USING ix.framework.core;
USING ix.framework.utils;

NAMESPACE ix.core.IxMessaging_Tests
    CLASS MessengerTestContext IMPLEMENTS ix.framework.core.IIxContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
            _sut : IxMessenger;
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
    END_CLASS  


    CLASS IxRtcMock IMPLEMENTS IRtc
        VAR PRIVATE 
            _NowUTC : LDATE_AND_TIME;
        END_VAR

        METHOD PUBLIC SetNowUTC : LDATE_AND_TIME
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

        {Test}
        METHOD PUBLIC MyTestMethod
            ; // AxUnit.Assert.Equal(y, x)
        END_METHOD
    END_CLASS



END_NAMESPACE


USING AXOpen.Core;
USING AXOpen.Rtc;
USING AxUnit;

NAMESPACE AXOpen.Data 
    NAMESPACE AxoDataPersistentExchangeTaskTests
        CLASS TestContext IMPLEMENTS IAxoContext        
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
        
            METHOD PUBLIC GetRtc : IAxoRtc ; END_METHOD

            METHOD PUBLIC InjectRtc VAR_INPUT Rtc : IAxoRtc; END_VAR ; END_METHOD
            
            VAR PRIVATE
                NULL_LOGGER : _NULL_LOGGER;
            END_VAR    
            METHOD PUBLIC GetLogger : AXOpen.Logging.IAxoLogger GetLogger := NULL_LOGGER; END_METHOD
            METHOD PUBLIC InjectLogger VAR_INPUT _logger : AXOpen.Logging.IAxoLogger; END_VAR ; END_METHOD 
        END_CLASS      

        {TestFixture}
        CLASS AxoDataPersistentExchangeTask_Tests
            VAR PROTECTED
                _context : TestContext;
                _dataExchangeTask : AxoDataPersistentCurdTask;
            END_VAR    

            {Test}
            METHOD PUBLIC InvokeWithIdentifier_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchangeTask.Initialize(_context);
                _context.Open();
                expected := 'UpdateIdentifier';
                _dataExchangeTask.Invoke(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchangeTask.DataEntityIdentifier, expected);
            END_METHOD
                     
        END_CLASS
    END_NAMESPACE    
END_NAMESPACE

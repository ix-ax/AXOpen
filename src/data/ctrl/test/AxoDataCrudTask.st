USING AXOpen.Core;
USING AXOpen.Rtc;
USING AxUnit;

NAMESPACE AXOpen.Data 
    NAMESPACE AxoDataExchangeTests
        {S7.extern=ReadWrite}
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
        {S7.extern=ReadWrite}
        CLASS AxoDataExchange_Tests
            VAR PROTECTED
                _context : TestContext;
                _dataExchange : AxoDataExchange;
            END_VAR    

            {Test}
            METHOD PUBLIC Create_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'CreateRecordIdentifier';
                _dataExchange.Create(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.Operation.DataEntityIdentifier, expected);
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.CrudOperation = eCrudOperation#Create);
            END_METHOD

            
            {Test}
            METHOD PUBLIC Read_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'ReadRecordIdentifier';
                _dataExchange.Read(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.Operation.DataEntityIdentifier, expected);
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.CrudOperation = eCrudOperation#Read);
            END_METHOD

            {Test}
            METHOD PUBLIC Update_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'UpdateRecordIdentifier';
                _dataExchange.Update(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.Operation.DataEntityIdentifier, expected);
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.CrudOperation = eCrudOperation#Update);
            END_METHOD

            {Test}
            METHOD PUBLIC Delete_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'DeleteRecordIdentifier';
                _dataExchange.Delete(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.Operation.DataEntityIdentifier, expected);
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.CrudOperation = eCrudOperation#Delete);
            END_METHOD

            {Test}
            METHOD PUBLIC EntityExist_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'EntityExistRecordIdentifier';
                _dataExchange.EntityExist(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.Operation.DataEntityIdentifier, expected);
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.CrudOperation = eCrudOperation#EntityExist);
            END_METHOD

            {Test}
            METHOD PUBLIC CreateOrUpdate_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'CreateOrUpdateRecordIdentifier';
                _dataExchange.CreateOrUpdate(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.Operation.DataEntityIdentifier, expected);
                AxUnit.Assert.Equal(TRUE, _dataExchange.Operation.CrudOperation = eCrudOperation#CreateOrUpdate);
            END_METHOD
        END_CLASS
    END_NAMESPACE    
END_NAMESPACE

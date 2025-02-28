USING AXOpen.Core;
USING AXOpen.Rtc;
USING AxUnit;

NAMESPACE AXOpen.Data 
    NAMESPACE AxoDataExchangeTaskTests
        {S7.extern=ReadWrite}
        CLASS TestContext EXTENDS Dummies.MockAxoContext                    
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD
        END_CLASS      

        {TestFixture}
        {S7.extern=ReadWrite}
        CLASS AxoDataExchangeTask_Tests
            VAR PROTECTED
                _context : TestContext;
                _rootObject : AxoObject;
                _dataExchangeTask : AxoDataCrudTask;
            END_VAR    

            {Test}
            METHOD PUBLIC InvokeWithIdentifier_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _rootObject.InitializeWithContext(_context);
                _dataExchangeTask.Initialize(_rootObject);
                _context.Open();
                expected := 'CreateRecordIdentifier';
                _dataExchangeTask.Invoke(expected);
                _context.Close();
                AxUnit.Assert.Equal(TRUE, _dataExchangeTask.DataEntityIdentifier = expected);
            END_METHOD
                     
        END_CLASS
    END_NAMESPACE    
END_NAMESPACE

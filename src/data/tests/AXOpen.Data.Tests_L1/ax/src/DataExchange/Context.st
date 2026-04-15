USING AXOpen.Core;
using AXOpen.Data;

NAMESPACE Tests_L1.DataExchange
    
    {S7.extern=ReadWrite}
    CLASS PUBLIC DataExchangeContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _rootObject :   AxoObject;
            SharedHeaderManager : Tests_L1.SharedEntityHeaderManager; 
        END_VAR
        
        METHOD OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            SharedHeaderManager.Run(_rootObject);
        END_METHOD
    END_CLASS
    
END_NAMESPACE

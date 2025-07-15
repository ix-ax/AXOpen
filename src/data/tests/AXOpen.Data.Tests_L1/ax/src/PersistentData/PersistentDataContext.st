USING AXOpen.Core;
using AXOpen.Data;

NAMESPACE Tests_L1.PersistentData
    
    {S7.extern=ReadWrite}
    CLASS PUBLIC PersistentDataContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _rootObject :   AxoObject;

            DataManager : AXOpen.Data.AxoDataPersistentExchange;
    
            PersistentRootObject : Tests_L1.PersistentData.PersistentRootObject; 
            
        END_VAR
        
        METHOD OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            DataManager.Run(_rootObject);
        END_METHOD
    END_CLASS
    
END_NAMESPACE

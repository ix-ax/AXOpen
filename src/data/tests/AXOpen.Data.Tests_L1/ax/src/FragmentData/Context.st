USING AXOpen.Core;
using AXOpen.Data;

NAMESPACE Tests_L1.FragmentData
    
    {S7.extern=ReadWrite}
    CLASS PUBLIC FragmentDataContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _rootObject :   AxoObject;

            DataManager : Tests_L1.FragmentData.FragmentProcessDataManager;
        END_VAR
        
        METHOD OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            DataManager.Run(_rootObject);
        END_METHOD
    END_CLASS
    
END_NAMESPACE

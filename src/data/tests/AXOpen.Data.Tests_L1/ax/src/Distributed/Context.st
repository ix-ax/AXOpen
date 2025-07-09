USING AXOpen.Core;
using AXOpen.Data;

NAMESPACE Tests_L1.Distributed
    
    {S7.extern=ReadWrite}
    CLASS PUBLIC DistributedDataContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _rootObject :   AxoObject;

            {#ix-attr:[AXOpen.Data.DistributedDataAttribute("Group_1")]}
            HeaderManager_1 : Tests_L1.SharedEntityHeaderManager; 
            
            {#ix-attr:[AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2")]}
            HeaderManager_2 : Tests_L1.SharedEntityHeaderManager; 
            
            {#ix-attr:[AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2", "Group_3")]}
            StationManager_1 : Tests_L1.StationDataManager;
            
            {#ix-attr:[AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2", "Group_3", "Group_4")]}
            StationManager_2 : Tests_L1.StationDataManager;

            {#ix-attr:[AXOpen.Data.DistributedDataAttribute("AxoDataFragmentExchange")]}
            Fragment : Tests_L1.FragmentData.FragmentProcessDataManager;

            {#ix-attr:[AXOpen.Data.DistributedDataAttribute("AxoObjectWrap")]}
            AxoProcess : Tests_L1.Distributed.ExchangesWrappedInAxoObject;

        END_VAR
        
        METHOD OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            HeaderManager_1.Run(_rootObject);
            HeaderManager_2.Run(_rootObject);
            StationManager_1.Run(_rootObject);
            StationManager_2.Run(_rootObject);
            Fragment.Run(_rootObject);
            AxoProcess.Run(_rootObject);
        END_METHOD
    END_CLASS
    
END_NAMESPACE

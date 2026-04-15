USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE Tests_L1.FragmentData  

    {S7.extern=ReadWrite}
    CLASS PUBLIC FragmentProcessDataManager EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC        

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            EntityHeader : Tests_L1.SharedEntityHeaderManager;  

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Station :  Tests_L1.StationdataManager;

        END_VAR
    END_CLASS

END_NAMESPACE

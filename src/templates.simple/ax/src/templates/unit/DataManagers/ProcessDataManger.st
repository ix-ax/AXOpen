NAMESPACE axosimple.UnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
    
    CLASS ProcessDataManager
        EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Shared : EntityHeaderDataManager;
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            DataManger : FragmentProcessDataManger;
        END_VAR        
    END_CLASS
END_NAMESPACE    
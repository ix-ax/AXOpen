NAMESPACE axosimple.UnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
    
    {S7.extern=ReadWrite}
    CLASS ProcessDataManager
        EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Shared : axosimple.EntityHeaderDataManager;
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            DataManger : axosimple.UnitTemplate.FragmentProcessDataManger;
        END_VAR        
    END_CLASS
END_NAMESPACE    

NAMESPACE axosimple.StarterUnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
    
    {S7.extern=ReadWrite}
    CLASS TechnologyDataManager
        EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Shared : axosimple.TechnologyCommonDataManager;
            
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            DataManger : axosimple.StarterUnitTemplate.FragmentTechnologyDataManger;
        END_VAR        
    END_CLASS
END_NAMESPACE    

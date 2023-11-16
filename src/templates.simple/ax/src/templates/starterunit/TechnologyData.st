NAMESPACE axosimple.StarterUnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
 
    CLASS TechnologyData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC

            Header : axosimple.TechnologyUnitHeader;

            HeatingTemperature   : REAL;
            
        END_VAR
    END_CLASS
END_NAMESPACE    
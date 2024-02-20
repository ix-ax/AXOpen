NAMESPACE axosimple.StarterUnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;
 
    {S7.extern=ReadWrite}
    CLASS ProcessData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            CounterDelay : ULINT;  

            PartPresence        : AXOpen.Inspectors.AxoDigitalInspector;
            JigDataMatrixCode   : AXOpen.Inspectors.AxoDataInspector;
            LoadPosition        : AXOpen.Inspectors.AxoAnalogueInspector;          
        END_VAR
    END_CLASS
END_NAMESPACE    

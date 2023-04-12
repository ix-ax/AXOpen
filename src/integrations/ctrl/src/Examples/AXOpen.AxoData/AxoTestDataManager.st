using AXOpen.Data;

NAMESPACE AxoDataExamples

    CLASS AxoTestDataManager EXTENDS AXOpen.Data.DataExchange 
        VAR PUBLIC   
            _identifier : STRING;
            _create     : BOOL;                     
            _read       : BOOL;
            _update     : BOOL;
            _delete     : BOOL;
            {#ix-attr:[DataEntityAttribute]}
            _data       : AxoTestData;
        END_VAR  
    END_CLASS       
END_NAMESPACE
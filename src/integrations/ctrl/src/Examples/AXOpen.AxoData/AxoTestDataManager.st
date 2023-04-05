using ix.framework.data;

NAMESPACE AxoDataExamples

    CLASS AxoTestDataManager EXTENDS ix.framework.data.DataExchange 
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
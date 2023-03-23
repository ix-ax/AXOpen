using ix.framework.data;

NAMESPACE ixDataExamples

    CLASS IxTestDataManager EXTENDS ix.framework.data.DataExchange 
        VAR PUBLIC   
            _identifier : STRING;
            _create     : BOOL;                     
            _read       : BOOL;
            _update     : BOOL;
            _delete     : BOOL;
            _data       : IxTestData;
        END_VAR  
    END_CLASS       
END_NAMESPACE
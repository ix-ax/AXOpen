using AXOpen.Data;

NAMESPACE AxoDataExamples

    CLASS AxoTestDataManager EXTENDS AXOpen.Data.AxoDataExchange 
        VAR PUBLIC   
            _identifier : STRING;
            _create     : BOOL;                     
            _read       : BOOL;
            _update     : BOOL;
            _delete     : BOOL;
            {#ix-generic:TOnline}              
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AxoDataEntityAttribute]}
            _data       : AxoTestData;
        END_VAR  
    END_CLASS       
END_NAMESPACE
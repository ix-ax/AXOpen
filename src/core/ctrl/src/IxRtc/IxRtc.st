USING Siemens.Simatic.S71500.Clocks;

NAMESPACE ix.framework.core   
    CLASS IxRtc IMPLEMENTS IIxRtc       
        VAR PRIVATE            
            _NowUTC : LDATE_AND_TIME;
         END_VAR 
       
         METHOD PUBLIC NowUTC : LDATE_AND_TIME 
            NowUTC := _NowUTC;
        END_METHOD
		METHOD PROTECTED Update  
            //GetSystemDateTime(value => _NowUTC);
            ;
        END_METHOD

        METHOD INTERNAL UpdateInternal  
            THIS.Update();
        END_METHOD
    END_CLASS    
END_NAMESPACE



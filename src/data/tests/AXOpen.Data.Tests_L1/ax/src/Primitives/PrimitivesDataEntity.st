USING AXOpen.Core;
USING AXOpen;
using AXOpen.Data;

NAMESPACE Tests_L1.Primitives
 
    {S7.extern=ReadWrite}
    CLASS PUBLIC PrimitivesDataEntity EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            v_BOOL          :       BOOL	      ;
            v_BYTE          :       BYTE	      ;
            v_WORD          :       WORD	      ;
            v_DWORD         :       DWORD	      ;
            v_LWORD	        :       LWORD	      ;
            v_SINTMin       :       SINT	      ;
            v_SINTMax       :       SINT	      ;
            v_INT	        :       INT           ;
            v_DINT	        :       DINT	      ;
            v_LINT	        :       LINT	      ;
            v_USINT	        :       USINT	      ;
            v_UINT	        :       UINT	      ;
            v_UDINT	        :       UDINT	      ;
            v_ULINT	        :       ULINT	      ;
            v_REAL	        :       REAL	      ;
            v_LREAL	        :       LREAL	      ;
            v_TIME	        :       TIME	      ;
            v_LTIME	        :       LTIME	      ;
            v_DATE	        :       DATE	      ;
            v_LDATE	        :       LDATE	      ;
            v_TIME_OF_DAY	:       TIME_OF_DAY   ;
            v_LTIME_OF_DAY	:       LTIME_OF_DAY  ;
            v_DATE_AND_TIME :      DATE_AND_TIME  ;
            v_LDATE_AND_TIME :      LDATE_AND_TIME;
            v_CHAR	        :       CHAR	      ;
            v_WCHAR	        :       WCHAR	      ;
            v_STRING        :       STRING	      ;
            v_WSTRING       :       WSTRING	      ;
        END_VAR    
    END_CLASS
    
END_NAMESPACE

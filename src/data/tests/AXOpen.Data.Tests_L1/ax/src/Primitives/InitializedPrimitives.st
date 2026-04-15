USING AXOpen.Core;
USING AXOpen;
using AXOpen.Data;

NAMESPACE Tests_L1.Primitives
 
    {S7.extern=ReadWrite}
    CLASS PUBLIC InitializedPrimitives
        VAR PUBLIC
            v_BOOL          :       BOOL	      := true;
            v_BYTE          :       BYTE	      := BYTE#255;
            v_WORD          :       WORD	      := WORD#60000;
            v_DWORD         :       DWORD	      := DWORD#16#ABCD_EF01;
            v_LWORD	        :       LWORD	      := LWORD#18446744073709551615;
            v_SINTMin       :       SINT	      := SINT#-128;
            v_SINTMax       :       SINT	      := SINT#127;
            v_INT	        :       INT           := INT#32767;
            v_DINT	        :       DINT	      := DINT#2147483647;
            v_LINT	        :       LINT	      := LINT#9223372036854775807;
            v_USINT	        :       USINT	      := USINT#255;
            v_UINT	        :       UINT	      := UINT#65535;
            v_UDINT	        :       UDINT	      := UDINT#4294967295;
            v_ULINT	        :       ULINT	      := ULINT#18446744073709551615;
            v_REAL	        :       REAL	      := REAL#+3.402823e+38;
            v_LREAL	        :       LREAL	      := LREAL#1.79769313486231e+308;
            v_TIME	        :       TIME	      := TIME#2147483647ms;
            v_LTIME	        :       LTIME	      := LTIME#100000d2h4m8s16ms32ns;
            v_DATE	        :       DATE	      := DATE#2262-04-11;
            v_LDATE	        :       LDATE	      := LDATE#2262-04-11;
            v_TIME_OF_DAY	:       TIME_OF_DAY   := TIME_OF_DAY#23:59:59.999999999;
            v_LTIME_OF_DAY	:       LTIME_OF_DAY  := LTIME_OF_DAY#23:59:59.999999999;
            v_DATE_AND_TIME :      DATE_AND_TIME  := DATE_AND_TIME#2262-04-11-23:47:16.854775807;
            v_LDATE_AND_TIME :      LDATE_AND_TIME := LDATE_AND_TIME#2262-04-11-23:47:16.854775807;
            v_CHAR	        :       CHAR	      := CHAR#255;
            v_WCHAR	        :       WCHAR	      := WCHAR#65535;
            v_STRING        :       STRING	      := 'o\zxcvbnm,./asdfghjkl;\\qwertyuiop[]1234567890-~!@#^&*()_+';
            v_WSTRING       :       WSTRING	      := WSTRING#"o\zxcvbnm,./asdfghjkl;'\qwertyuiop[]1234567890-~!@#^&*()_+";
        END_VAR    
    END_CLASS
    
END_NAMESPACE

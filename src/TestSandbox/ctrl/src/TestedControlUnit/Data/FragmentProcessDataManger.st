NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;
    USING AXOpen.Cognex.Vision.v_6_0_0_0;
   

    CLASS FragmentProcessDataManger
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Cux"}
            Set : FragmentProcessData;  
        END_VAR
    END_CLASS

  
END_NAMESPACE

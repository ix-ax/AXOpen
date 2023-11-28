NAMESPACE AXOpen.Elements
    /// <summary>
    /// 	Class representing current status of analog output							
    /// </summary>
    {S7.extern=ReadWrite}
    CLASS AxoAoStatus
        VAR PUBLIC
        // <summary>
        // 	Absolute range of raw value.								
        // </summary>				
        {#ix-set:AttributeName = "<#Raw range#>"}
        RawRange : REAL;
		
        // <summary>
        // 	Absolute range of real value.								
        // </summary>				
        {#ix-set:AttributeName = "<#Real range#>"}
        RealRange : REAL;
        // <summary>
        // Current real value.								
        // </summary>				
        {#ix-set:AttributeName = "<#Unscaled value#>"}
        Unscaled : REAL;
        END_VAR
    END_CLASS
END_NAMESPACE

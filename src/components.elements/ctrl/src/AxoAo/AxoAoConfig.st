NAMESPACE AXOpen.Components.Elements
    // <AxoAoConfigDeclaration>
    /// <summary>
    /// Configuration class for analog output							
    /// </summary>	
    {S7.extern=ReadWrite}
    CLASS AxoAoConfig
        VAR PUBLIC

        // <summary>
        // Lowest possible value of the raw input.								
        // </summary>
        {#ix-set:AttributeName = "<#Raw low#>"}							
        RawLow : DINT;
		
        // <summary>
        // Highest possible value of the raw input.								
        // </summary>				
        {#ix-set:AttributeName = "<#Raw high#>"}
        RawHigh : DINT;
		
        // <summary>
        // Lowest threshold of scaled value.
        // `RealLow` and `RealHigh` should represent the real range of an continuous input. 								
        // </summary>				
        {#ix-set:AttributeName = "<#Real low#>"}			
        RealLow  : REAL;
		
        // <summary>
        // 	Highest threshold range of scaled value.
        // `RealLow` and `RealHigh` should represent the real range of an continuous input. 	 								
        // </summary>				
        {#ix-set:AttributeName = "<#Real high#>"}
        RealHigh : REAL;

		// <summary>
		// Allows simple adjustment of the calculated value multiplying the value by factor of `Gain`.								 	 								
		// </summary>				
        {#ix-set:AttributeName = "<#Gain#>"}
        Gain : REAL := REAL#1.0;

        // <summary>
        // Allows simple adjustment of the calculated value by adding `Offset` value.								 	 								
        // </summary>				
        {#ix-set:AttributeName = "<#Offset#>"}
        Offset : REAL := REAL#0.0;
        END_VAR
    END_CLASS
     // </AxoAoConfigDeclaration>
END_NAMESPACE

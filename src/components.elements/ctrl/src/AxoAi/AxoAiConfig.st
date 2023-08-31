NAMESPACE AXOpen.Elements
    // <AxoAiConfigDeclaration>
    // <summary>
    // Configuration class for analog input							
    // </summary>	
    CLASS AxoAiConfig
        VAR PUBLIC

        // <summary>
        // Lowest possible value of the raw input.								
        // </summary>				
        RawLow : DINT;
		
        // <summary>
        // Highest possible value of the raw input.								
        // </summary>				
        RawHigh : DINT;
		
        // <summary>
        // Lowest threshold of scaled value.
        // `RealLow` and `RealHigh` should represent the real range of an continuous input. 								
        // </summary>				
        RealLow  : REAL;
		
        // <summary>
        // Highest threshold range of scaled value.
        // `RealLow` and `RealHigh` should represent the real range of an continuous input. 	 								
        // </summary>				
        RealHigh : REAL;

		// <summary>
		// Allows simple adjustment of the calculated value multiplying the value by factor of `Gain`.								 	 								
		// </summary>				
        Gain : REAL := REAL#1.0;
        // <summary>
        // Allows simple adjustment of the calculated value by adding `Offset` value.								 	 								
        // </summary>				
        Offset : REAL := REAL#0.0;
        END_VAR
    END_CLASS
    // </AxoAiConfigDeclaration>
END_NAMESPACE
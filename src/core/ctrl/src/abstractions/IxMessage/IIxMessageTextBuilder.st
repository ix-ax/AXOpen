NAMESPACE ix.framework.core
    INTERFACE IIxMessageTextBuilder 
		/// <summary>			
		/// Appends string to the message text. 
		/// </summary>
		/// <remarks>
		/// 	<note type="warning">
		/// 		The size of the resulting string should not be more than '160' characters. The characters exceeding this size will be truncated.
		/// 	</note>
		/// </remarks>
        METHOD Append : IIxMessageTextBuilder
            VAR_INPUT
                Text : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD
    
		/// <summary>			
		/// Gets categorization methods for fluent message builder.
		/// </summary>		
        METHOD As : IIxMessageCategorize END_METHOD

		/// <summary>			
		/// Initiates new message text building for this messenger in fluent-like fashion.
		/// </summary>		
        METHOD Build : IIxMessageTextBuilder END_METHOD
    END_INTERFACE
END_NAMESPACE

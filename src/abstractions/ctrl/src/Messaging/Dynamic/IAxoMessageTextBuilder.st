NAMESPACE AXOpen.Messaging.Dynamic
    INTERFACE IAxoMessageTextBuilder 
		/// <summary>			
		/// Appends string to the message text. 
		/// </summary>
		/// <remarks>
		/// 	<note type="warning">
		/// 		The size of the resulting string should not be more than '160' characters. The characters exceeding this size will be truncated.
		/// 	</note>
		/// </remarks>
 		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : BOOL; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : BYTE; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : WORD; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : DWORD; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : LWORD; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : SINT; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : INT; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : DINT; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : LINT; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : USINT; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : UINT; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : UDINT; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : ULINT; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : REAL; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : LREAL; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : TIME; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : LTIME; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : DATE; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : LDATE; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : TIME_OF_DAY; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : LTIME_OF_DAY; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : DATE_AND_TIME; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : LDATE_AND_TIME; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : CHAR; END_VAR END_METHOD
		// METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : WCHAR; END_VAR END_METHOD
		METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT]; END_VAR END_METHOD
		// METHOD Append : IAxoMessageTextBuilder VAR_INPUT Data : WSTRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT]; END_VAR END_METHOD
		/// <summary>			
		/// Gets categorization methods for fluent message builder.
		/// </summary>		
        METHOD As : IAxoMessageCategorize END_METHOD

		/// <summary>			
		/// Initiates new message text building for this messenger in fluent-like fashion.
		/// </summary>		
        METHOD Build : IAxoMessageTextBuilder END_METHOD
    END_INTERFACE
END_NAMESPACE

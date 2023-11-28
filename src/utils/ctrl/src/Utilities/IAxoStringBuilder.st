NAMESPACE AXOpen.Utils
	/// <summary>
	/// Allows to concat strings using fluent interface. It's similar to C# StringBuilder class
	/// Usage as follows :
	/// <code>
	/// 	ErrorString := _stringBuilder
	/// 		.Clear()
	/// 		.Append('Error number: ')
	/// 		.Append(ErrorNumber)
	/// 		.Append('. Message: ')
	/// 		.Append(ErrorMessage)
	/// 		.Append('.')
	/// 		.AsString();
	/// </code>
	/// Inspired by Gerhard Barteling blogpost at https://www.plccoder.com/fluent-code/
	/// </summary>			
    INTERFACE IAxoStringBuilder 
		METHOD Clear  : IAxoStringBuilder END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : BOOL; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : BYTE; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : WORD; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : DWORD; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : LWORD; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : SINT; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : INT; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : DINT; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : LINT; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : USINT; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : UINT; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : UDINT; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : ULINT; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : REAL; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : LREAL; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : TIME; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : LTIME; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : DATE; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : LDATE; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : TIME_OF_DAY; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : LTIME_OF_DAY; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : DATE_AND_TIME; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : LDATE_AND_TIME; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : CHAR; END_VAR END_METHOD
		// METHOD Append : IAxoStringBuilder VAR_INPUT Data : WCHAR; END_VAR END_METHOD
		METHOD Append : IAxoStringBuilder VAR_INPUT Data : STRING[254]; END_VAR END_METHOD
		// METHOD Append : IAxoStringBuilder VAR_INPUT Data : WSTRING[254]; END_VAR END_METHOD
    END_INTERFACE
END_NAMESPACE

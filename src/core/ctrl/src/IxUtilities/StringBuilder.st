USING System.Strings;

NAMESPACE ix.framework.core
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
    CLASS PUBLIC StringBuilder
		VAR
            _workString: STRING[254];
        END_VAR

		METHOD PUBLIC Clear : REF_TO StringBuilder
			_workString := '';
			Clear ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : BOOL; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : BYTE; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : WORD; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : DWORD; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : LWORD; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : SINT; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : INT; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : DINT; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : LINT; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : USINT; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : UINT; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : UDINT; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : ULINT; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : REAL; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : LREAL; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : TIME; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : LTIME; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : DATE; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : LDATE; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : TIME_OF_DAY; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : LTIME_OF_DAY; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : DATE_AND_TIME; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : LDATE_AND_TIME; 
			END_VAR
			_workString := Concat(_workString,ToString(Data));
			Append ?= REF(THIS);
		END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data : CHAR; 
			END_VAR
			_workString := Concat(_workString,Data);
			Append ?= REF(THIS);
		END_METHOD

		// METHOD PUBLIC Append : REF_TO StringBuilder
		// 	VAR_INPUT
		// 		Data : WCHAR; 
		// 	END_VAR
		// 	_workString := Concat(_workString,ToString(Data));
		// 	Append ?= REF(THIS);
		// END_METHOD

		METHOD PUBLIC Append : REF_TO StringBuilder
			VAR_INPUT
				Data :STRING[254]; 
			END_VAR
			_workString := Concat(_workString,Data);
			Append ?= REF(THIS);
		END_METHOD

		// METHOD PUBLIC  Append : REF_TO StringBuilder
		// 	VAR_INPUT
		// 		Data :WSTRING[254]; 
		// 	END_VAR
		// 	_workString := Concat(_workString,ToString(Data));
		// 	Append ?= REF(THIS);
		// END_METHOD

		METHOD PUBLIC AsString : STRING[254]
			AsString := _workString;
		END_METHOD
    END_CLASS
END_NAMESPACE
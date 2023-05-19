USING AXOpen.Core;
USING System.Strings;
USING System.DateTime;
USING AXOpen.Utils;
// USING AXOpen.Messaging;

NAMESPACE AXOpen.Messaging.Dynamic
	/// <summary>
	/// Provides mechanism for delivering static messages to the supervising applications (SCADA/HMI).	
	/// 	<remarks>			
	/// 		<note type="important">
	/// 			Each messenger has a single placeholder for the message; it stores the most important message from the last context cycle. 
	/// 			If there are more messages in a single cycle for the same messenger then less important messages are discarded and replaced by 
	/// 			the message with the category of higher severity.							
	/// 		</note>
	/// 		<note type="important">
	/// 			Messenger can send the data to context logger. There is a maximum limit of 10 different messages per messenger in 2 consecutive context cycles.
	/// 			The messages that exceed this limit won't be logged when `OnEventRisen` logging is set. 
	/// 		    Take this behaviour into account when designing your system.				
	/// 		</note>					
	/// 	</remarks>			 
	/// </summary>			
    CLASS AxoMessenger (*EXTENDS AxoObject*) IMPLEMENTS IAxoMessenger, AXOpen.Messaging.Dynamic.IAxoMessageProperties, IAxoMessageTextBuilder, IAxoMessageCategorize, IAxoMessages
		VAR
			/// <summary>
			/// 	Most important message of this instance of messenger; stores the most important message from the last context cycle. 
			/// 	If there are more messages in a single cycle for the same
			/// 	messenger then less important messages are discarded and replaced by the message with the category of higher severity.			 
			/// </summary>			
			_mime : AxoMessage;
			_Parent : IAxoObject;
            {#ix-attr:[ReadOnly()]}
			_contextIdentity : ULINT;	
			{#ix-attr:[CompilerOmits()]} 
			_mds : ARRAY[0..AxoIntConstants#MDS_MAX_INDEX] OF AxoMessageDigest;	
			{#ix-attr:[CompilerOmits()]} 
			_condition : eAxoMessageCondition;
			{#ix-attr:[CompilerOmits()]} 
			_pinnable : BOOL;		
		END_VAR
		
		VAR 
			{#ix-attr:[CompilerOmits()]} 
			tmpMessageText : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			{#ix-attr:[CompilerOmits()]} 
			refStringBuilder : REF_TO AxoStringBuilder;	
		END_VAR
		VAR
			{#ix-attr:[CompilerOmits()]} 
			_conflictingStringBuilder : AxoStringBuilder;
		END_VAR

		/// <summary>
		/// Gets the Most Important Message of this messenger.
		/// </summary>		
		METHOD PUBLIC GetMime : AxoMessage			
			GetMime := THIS._mime;
		END_METHOD

		/// <summary>
		/// Categorizes and creates the message as 'debug'.								 
		/// </summary>		
		METHOD PUBLIC AsDebug : AXOpen.Messaging.Dynamic.IAxoMessageProperties				
			AsDebug := THIS.Post(THIS.StringBuilder()^.AsString(), eAxoMessageCategory#Debug);			
		END_METHOD
		
		/// <summary>
		/// Categorizes and creates the message as 'error'.								 
		/// </summary>		
		METHOD PUBLIC AsError : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			AsError := THIS.Post(THIS.StringBuilder()^.AsString(), eAxoMessageCategory#Error);
		END_METHOD
		
		/// <summary>
		/// Categorizes and creates the message as 'fatal'.								 
		/// </summary>		
		METHOD PUBLIC AsFatal : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			AsFatal := THIS.Post(THIS.StringBuilder()^.AsString(), eAxoMessageCategory#Fatal);
		END_METHOD
		
		/// <summary>
		/// Categorizes and creates the message as 'information'.								 
		/// </summary>		
		METHOD PUBLIC AsInfo : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			AsInfo := THIS.Post(THIS.StringBuilder()^.AsString(), eAxoMessageCategory#Info);
		END_METHOD
		
		/// <summary>
		/// Categorizes and creates the message as 'trace'.								 
		/// </summary>		
		METHOD PUBLIC AsTrace : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			AsTrace := THIS.Post(THIS.StringBuilder()^.AsString(), eAxoMessageCategory#Trace);
		END_METHOD
		
		/// <summary>
		/// Categorizes and creates the message as 'warning'.								 
		/// </summary>		
		METHOD PUBLIC AsWarning : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			AsWarning := THIS.Post(THIS.StringBuilder()^.AsString(), eAxoMessageCategory#Warning);
		END_METHOD
		
		/// <summary>
		/// Adds message of 'catastrophic' category to the message queue.
		/// Use this category when there is a situation when the device cannot continue operations due to irrecoverable failure.				 
		/// </summary>		
		METHOD PUBLIC Catastrophic : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Catastrophic := THIS.Post(Message, eAxoMessageCategory#Catastrophic);
		END_METHOD
		
		/// <summary>
		/// Adds message of 'critical' category to the message queue.
		/// Use this category when a critical error occured, that is not recoverable by the means of software (reset/restore) and a detailed inspection is required.				 
		/// </summary>		
		METHOD PUBLIC Critical : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Critical := THIS.Post(Message, eAxoMessageCategory#Critical);
		END_METHOD

		/// <summary>
		/// Adds message of 'debug' category to the message queue.	
		/// Use when you need to report debug information for you as programmer. 			 
		/// </summary>		
		METHOD PUBLIC Debug : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Debug := THIS.Post(Message, eAxoMessageCategory#Debug);
		END_METHOD

		/// <summary>
		/// Adds message of 'error' category to the message queue.
		/// Use this categoty when there is a failure that cannot be immediately recovered and an intervention is needed. This is typically a situation when a device fails
		/// to deliver expected result. 
		/// Do not use this category to report information about failed process like measurement or detection.				 
		/// </summary>		
		METHOD PUBLIC Error : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Error := THIS.Post(Message, eAxoMessageCategory#Error);
		END_METHOD

		/// <summary>
		/// Adds message of 'information' category to the message queue.	
		/// Use when you want to deliver information to the user, that has only informative character and does not adversely affect a process.			 
		/// </summary>		
		METHOD PUBLIC Info : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Info := THIS.Post(Message, eAxoMessageCategory#Info);
		END_METHOD

		/// <summary>
		/// Adds message of 'notification' category to the message queue.
		/// Use this category when you want to report a notification that may be of interest to the user, but does not adveresly affect a process.			 
		/// </summary>		
		METHOD PUBLIC Notify : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Notify := THIS.Post(Message, eAxoMessageCategory#Notification);
		END_METHOD

		/// <summary>
		/// Adds message of 'programming error' category to the message queue.	
		/// Use this category to inform about a possible programming error, defect in settings or missing information at a level of programming or system or process settings.			 
		/// </summary>		
		METHOD PUBLIC Programming : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Programming := THIS.Post(Message, eAxoMessageCategory#ProgrammingError);
		END_METHOD

		/// <summary>
		/// Adds message of 'trace' category to the message queue.	
		/// Use when you need to track detailed information about internal states of the program for detailed visibility. 
		/// This is lowest level of category that can be used in production, for detailed observation of PLC program.			 
		/// </summary>		
		METHOD PUBLIC Trace : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Trace := THIS.Post(Message, eAxoMessageCategory#Trace);
		END_METHOD

		/// <summary>
		/// Adds message of 'warning' category to the message queue.
		/// Use this category when you want to report to the user an information about a possible problem, that may adversly affect a process.
		/// Information in this cateogory aims to help the user to identify a problem, the cause of such problem does not necessarily stops the process.				 
		/// </summary>		
		METHOD PUBLIC Warning : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
			END_VAR
			Warning := THIS.Post(Message, eAxoMessageCategory#Warning);
		END_METHOD

		/// <summary>			
		/// Appends string to the message text. 
		/// </summary>
		/// <remarks>
		/// <note type="warning">
		/// The size of the resulting string should not be more than '160' characters. The characters exceeding this size will be truncated.
		/// </note>
		/// </remarks>
		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : BOOL; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : BYTE; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : WORD; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : DWORD; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : LWORD; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : SINT; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : INT; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : DINT;
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : LINT; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : USINT; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : UINT; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : UDINT; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

	
		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : ULINT; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : REAL; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : LREAL; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : TIME; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : LTIME; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : DATE; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : LDATE; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : TIME_OF_DAY; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : LTIME_OF_DAY; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : DATE_AND_TIME; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD
		
		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : LDATE_AND_TIME; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : CHAR; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		// METHOD PUBLIC Append : IAxoMessageTextBuilder 
		// 	VAR_INPUT 
		// 		Data : WCHAR; 
		// 	END_VAR 
		// 	THIS.StringBuilder()^.Append(Data);
		// 	Append := THIS;
		// END_METHOD

		METHOD PUBLIC Append : IAxoMessageTextBuilder 
			VAR_INPUT 
				Data : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT]; 
			END_VAR 
			THIS.StringBuilder()^.Append(Data);
			Append := THIS;
		END_METHOD

		// METHOD PUBLIC Append : IAxoMessageTextBuilder 
		// 	VAR_INPUT 
		// 		Data : WSTRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT]; 
		// 	END_VAR 
		// 	THIS.StringBuilder()^.Append(Data);
		// 	Append := THIS;
		// END_METHOD

		/// <summary>			
		/// Gets categorization methods for fluent message builder.
		/// </summary>	
		METHOD PUBLIC As : IAxoMessageCategorize 
			As := THIS;
		END_METHOD

		/// <summary>			
		/// Initiates new message text building for this messenger in fluent-like fashion.
		/// </summary>		
		METHOD PUBLIC Build : IAxoMessageTextBuilder
			THIS.StringBuilder()^.Clear();
			Build := THIS;
		END_METHOD
		
		/// <summary>
		/// Clears the message content.
		/// </summary>
		METHOD PUBLIC Clear 
			NewDateAndTime(1970, 1, 1, 0, 0, 0, 0, 0, 0, _mime.TimeStamp);
			_mime.Text := '';
			_mime.Identity := ULINT#0;
			_mime.Category := eAxoMessageCategory#All;
			_mime.Cycle := ULINT#0;	
			_mime.PerCycleCount := USINT#0;
			_mime.Pinned := FALSE;	
		END_METHOD

		METHOD PROTECTED Compose : AxoMessage
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
				/// <summary>
				/// Message category.			 
				/// </summary>			
				Category : eAxoMessageCategory;	
			END_VAR
					Compose.TimeStamp :=  _Parent.GetContext().GetRtc().NowUTC();
					Compose.Text := Message;
					Compose.Identity := _Parent.GetIdentity();
					Compose.Category := Category;
					Compose.Cycle := _Parent.GetContext().OpenCycleCount();
					// Compose.MessageDigest := THIS.Digest(Message, _Parent.GetContext().Environment().Messaging().GetMessageDigestMethod());
					Compose.MessageDigest := THIS.Digest(Message,eAxoMessageDigestMethod#CRC32);
		END_METHOD

		METHOD PRIVATE Digest: DWORD
			VAR_INPUT
				Message : STRING[254];
				inDigestType : eAxoMessageDigestMethod;
			END_VAR

			CASE inDigestType OF
				eAxoMessageDigestMethod#CRC8 :
					Digest := AxoCRC_8(Message);
					eAxoMessageDigestMethod#CRC16 :
					Digest := AxoCRC_16(Message);
					eAxoMessageDigestMethod#CRC32 :
					Digest := AxoCRC_32(Message);
				ELSE
					Digest := DWORD#0;
			END_CASE;
		END_METHOD

		METHOD PUBLIC Initialize
			VAR_INPUT 
				ParentObject : IAxoObject; 
			END_VAR
			_Parent := ParentObject;
			_contextIdentity := ParentObject.GetIdentity();
		END_METHOD

		METHOD PUBLIC OnCondition : IAxoMessages 
			VAR_INPUT 
				inCondition : BOOL; 
			END_VAR 
			IF (inCondition) THEN
				_condition := eAxoMessageCondition#Active;
			ELSE
				_condition := eAxoMessageCondition#Inactive;
			END_IF;

			OnCondition := THIS;
		END_METHOD

		/// <summary>
		/// 	Pins this message that no other message will override it. 
		/// 	The messenger won't accept new messages until acknowledged in diagnostics view by user, unipenned by `Unpin()` methods or cleared by `Clear()` method
		/// 	of this messenger.						
		/// </summary>
		/// <note type="important">
		/// 	Pinned messages do no accept incomming messages on the same messenger. The incomming messages will be though the context logger when active.
		/// </note>
		METHOD PUBLIC Pin: AXOpen.Messaging.Dynamic.IAxoMessageProperties 
			IF NOT(_Parent = NULL) THEN
				IF NOT(_Parent.GetContext()= NULL) THEN
					IF(_pinnable) THEN
						IF(_mime.Cycle = _Parent.GetContext().OpenCycleCount())THEN
							_mime.Pinned := TRUE;
						END_IF;
					END_IF;
				END_IF;
			END_IF;
			Pin := THIS;
		END_METHOD

		/// <summary>
		/// Gets `true` when this messenger is pinned (awaiting acknowledgement in diagnostics view).
		/// </summary>
		METHOD PUBLIC IsPinned: BOOL 
			IsPinned := FALSE;
			IF _mime.Pinned THEN
				IsPinned :=  tmpMessageText = _mime.Text;
			END_IF;
		END_METHOD

		/// <summary>
		/// Gets `true` when this messenger is active.
		/// </summary>
		METHOD PUBLIC IsActive: BOOL 
			IsActive := _mime.Cycle = _Parent.GetContext().OpenCycleCount() OR _mime.Pinned ;		
		END_METHOD

		/// <summary>
		/// Creates message of given category for this messenger.						 
		/// </summary>		
		METHOD PUBLIC Post : AXOpen.Messaging.Dynamic.IAxoMessageProperties
			VAR_INPUT
				/// <summary>
				/// Arbitrary message string.			 
				/// </summary>			
				Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
				/// <summary>
				/// Message category.			 
				/// </summary>			
				Category : eAxoMessageCategory;	
			END_VAR

			VAR
				_wouldBeMime : AxoMessage;
			END_VAR

			Post := THIS;

			tmpMessageText := Message;

			_pinnable := FALSE;
			
			IF(_condition = eAxoMessageCondition#Inactive) THEN
				_condition := eAxoMessageCondition#Unconditional;	
				RETURN;
			END_IF;
			
			_condition := eAxoMessageCondition#Unconditional;

		
							IF(Category < _Parent.GetContext().Environment().Messaging().GetMinLevel()
								OR _Parent.GetContext().Environment().Messaging().IsSuspended()) THEN
									RETURN;
							END_IF; 	
								
							IF (NOT _mime.Pinned) THEN 
								_mime.PerCycleCount := _mime.PerCycleCount + USINT#1;
								_wouldBeMime := THIS.Compose(Message, Category);		
								_wouldBeMime.PerCycleCount := _mime.PerCycleCount;		
							ELSIF _mime.Pinned THEN
								IF(_mime.Text <>  Message OR _mime.Category <> Category) THEN		
									IF(	_mime.PerCycleCount < 255) THEN	
										_mime.PerCycleCount := _mime.PerCycleCount + USINT#1;	
									END_IF;
								END_IF;		
							END_IF;		
							
							// Same cycle filter for most important messge.
							IF(_mime.Cycle = _Parent.GetContext().OpenCycleCount()) THEN		 	
								IF(_wouldBeMime.Category > _mime.Category) 
								AND (NOT _mime.Pinned) THEN	 
									_mime := _wouldBeMime;
								END_IF;
							ELSE
							// Different cycle					  	    		
								IF (NOT _mime.Pinned) THEN
									_wouldBeMime.PerCycleCount := USINT#1;  													
									_mime := _wouldBeMime;										
								END_IF;
							END_IF;	
						
							_pinnable := TRUE;						
		END_METHOD
    
		METHOD PUBLIC StringBuilder : REF_TO AxoStringBuilder
			IF(NOT(refStringBuilder = NULL)) THEN
				StringBuilder := refStringBuilder;
			ELSE
				StringBuilder := REF(_conflictingStringBuilder);
			END_IF;
		END_METHOD
	
		METHOD PUBLIC UnPin 
			_mime.Pinned := FALSE;
		END_METHOD
	END_CLASS
END_NAMESPACE
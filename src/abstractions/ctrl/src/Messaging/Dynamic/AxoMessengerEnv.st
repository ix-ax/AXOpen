USING AXOpen.Utils;

NAMESPACE AXOpen.Messaging.Dynamic
    CLASS PUBLIC AxoMessengerEnv IMPLEMENTS IAxoMessengerEnv
		VAR
			_minLevel : eAxoMessageCategory;
			_isMessagingSuspended : BOOL;	
			_messageDigestMethod : eAxoMessageDigestMethod := eAxoMessageDigestMethod#CRC16;
			//_messengerLoggingMethod : eIxMessengerLogMethod := eIxMessengerLogMethod#OnEventRisen;
			_sb : REF_TO AxoStringBuilder;
		END_VAR
		
		/// <inheritdoc />		
		METHOD PUBLIC IsSuspended: BOOL 
			IsSuspended := _isMessagingSuspended;
		END_METHOD

		/// <inheritdoc />		
		METHOD PUBLIC GetMessageDigestMethod : eAxoMessageDigestMethod 
			GetMessageDigestMethod := _messageDigestMethod;
		END_METHOD

		/// <inheritdoc />		
		METHOD PUBLIC SetMessageDigestMethod 
			VAR_INPUT 
				inDigestMethod : eAxoMessageDigestMethod; 
			END_VAR 
			_messageDigestMethod := inDigestMethod;
		END_METHOD
					
		/// <inheritdoc />		
		METHOD PUBLIC GetMinLevel : eAxoMessageCategory 
			GetMinLevel := _minLevel;
		END_METHOD
					
		/// <inheritdoc />		
		METHOD PUBLIC SetMinLevel 
			VAR_INPUT 
				inMessageCategory : eAxoMessageCategory; 
			END_VAR 
			_minLevel := inMessageCategory;
		END_METHOD

		/// <inheritdoc />		
		METHOD PUBLIC Resume
			_isMessagingSuspended := FALSE;
		END_METHOD

		/// <inheritdoc />		
		METHOD PUBLIC Suspend 
			_isMessagingSuspended := TRUE;
		END_METHOD
		
		/// <inheritdoc />		
		METHOD PUBLIC GetStringBuilder : REF_TO AxoStringBuilder 
			GetStringBuilder ?= _sb;
		END_METHOD
	END_CLASS
END_NAMESPACE
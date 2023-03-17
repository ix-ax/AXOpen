NAMESPACE ix.framework.core
    CLASS PUBLIC IxMessengerEnv IMPLEMENTS IIxMessengerEnv
		VAR
			_minLevel : eIxMessageCategory;
			_isMessagingSuspended : BOOL;	
			_messageDigestMethod : eIxMessageDigestMethod := eIxMessageDigestMethod#CRC16;
			//_messengerLoggingMethod : eIxMessengerLogMethod := eIxMessengerLogMethod#OnEventRisen;
			_sb : REF_TO StringBuilder;
		END_VAR
		
		/// <inheritdoc />		
		METHOD PUBLIC IsSuspended: BOOL 
			IsSuspended := _isMessagingSuspended;
		END_METHOD

		/// <inheritdoc />		
		METHOD PUBLIC GetMessageDigestMethod : eIxMessageDigestMethod 
			GetMessageDigestMethod := _messageDigestMethod;
		END_METHOD

		/// <inheritdoc />		
		METHOD PUBLIC SetMessageDigestMethod 
			VAR_INPUT 
				inDigestMethod : eIxMessageDigestMethod; 
			END_VAR 
			_messageDigestMethod := inDigestMethod;
		END_METHOD
					
		/// <inheritdoc />		
		METHOD PUBLIC GetMinLevel : eIxMessageCategory 
			GetMinLevel := _minLevel;
		END_METHOD
					
		/// <inheritdoc />		
		METHOD PUBLIC SetMinLevel 
			VAR_INPUT 
				inMessageCategory : eIxMessageCategory; 
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
		METHOD PUBLIC GetStringBuilder : REF_TO StringBuilder 
			GetStringBuilder ?= _sb;
		END_METHOD
	END_CLASS
END_NAMESPACE
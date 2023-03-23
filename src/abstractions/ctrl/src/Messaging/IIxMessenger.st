NAMESPACE ix.framework.messaging
    INTERFACE IIxMessenger 
		/// <summary>
		/// Clears the message content.
		/// <remarks>			
		/// 	<note type="important">
		/// 		This method is exposed for Rpc calls, for testing purposes. Rpc calls of this method must not be used in production code
		///		</note>
		/// </remarks>								 
		/// </summary>		
		METHOD Clear END_METHOD


		METHOD OnCondition : IIxMessages
			VAR_INPUT
				inCondition : BOOL;
			END_VAR
		END_METHOD
    END_INTERFACE
END_NAMESPACE

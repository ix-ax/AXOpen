NAMESPACE ix.framework.messaging
    ///<summary>
    /// Complete message details including time stamp, message text, message category, identity of the message provider, context cycle in which the message was posted.
    ///</summary>
    TYPE IxMessage:
        STRUCT            
            /// <summary>
            /// Time when the message was posted.
            /// </summary>				
            {#ix-attr:[ReadOnly()]}
            TimeStamp : LDATE_AND_TIME;

            /// <summary>
            /// Text of the message.
            /// </summary>				
            {#ix-attr:[ReadOnly()]}
            Text : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];

            /// <summary>
            /// Identity of the TcoObject that posted this message. 
            /// </summary>				
            {#ix-attr:[ReadOnly()]}
            Identity : ULINT;	

            /// <summary>
            /// Message category of this message. See <see cref="TcoCore.eMessageCategory"/> for detailed informations. 
            /// </summary>				
            Category : eIxMessageCategory;
            
            /// <summary>
            /// Context cycle in which the message was posted.
            /// </summary>				
            {#ix-attr:[ReadOnly()]}
            Cycle : ULINT;

            /// <summary>
            /// Count of messages of the object in the current cycle.
            /// </summary>				
            {#ix-attr:[ReadOnly()]}
            PerCycleCount : USINT;

            /// <summary>			
            /// Indicates that the message is expected to be dequeed from the buffer.
            /// </summary>				
            ExpectDequeing : BOOL;

            /// <summary>			
            /// Indicates that the message must be persisted in the alarm view until acknowledged.
            /// </summary>				
            Pinned : BOOL;

            /// <summary>		
            /// Stores message digest of this message text.
            /// </summary>				
            MessageDigest : DWORD;
        END_STRUCT;
    END_TYPE
 END_NAMESPACE
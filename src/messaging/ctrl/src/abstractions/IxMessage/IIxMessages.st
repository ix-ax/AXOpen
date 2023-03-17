NAMESPACE ix.framework.core
    INTERFACE IIxMessages 
	    /// <summary>
		/// Adds message of 'debug' category to the message queue.				 
		/// </summary>		
        METHOD Debug : IIxMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD
                
	    /// <summary>
		/// Adds message of 'error' category to the message queue.				 
		/// </summary>		
        METHOD Error : IIxMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD
                
	    /// <summary>
		/// Adds message of 'information' category to the message queue.				 
		/// </summary>		
        METHOD Info : IIxMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD
                                
	    /// <summary>
		/// Adds message of 'notification' category to the message queue.				 
		/// </summary>		
        METHOD Notify : IIxMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD

                        
	    /// <summary>
		/// Adds message of 'programming error' category to the message queue.				 
		/// </summary>		
        METHOD Programming : IIxMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD

                        
	    /// <summary>
		/// Adds message of 'trace' category to the message queue.				 
		/// </summary>		
        METHOD Trace : IIxMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD

                        
	    /// <summary>
		/// Adds message of 'warning' category to the message queue.				 
		/// </summary>		
        METHOD Warning : IIxMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD

        METHOD Build: IIxMessageTextBuilder END_METHOD 

        /// <summary>
		/// Adds message of given category to the message queue.				 
		/// </summary>	
		/// <returns>Message index.</returns>		
        METHOD Post  : IIxMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[IxIntConstants#MAX_MESSAGE_TEXT_LENGHT];
                /// <summary>
                /// Message category.			 
                /// </summary>			
                Category : eIxMessageCategory;	
            END_VAR
        END_METHOD    
    
		/// <summary>
		/// Unpins this messenger.
		/// </summary>
        METHOD UnPin END_METHOD    
    
    END_INTERFACE
END_NAMESPACE








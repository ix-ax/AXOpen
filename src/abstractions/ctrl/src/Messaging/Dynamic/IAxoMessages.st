NAMESPACE AXOpen.Messaging.Dynamic
    INTERFACE IAxoMessages 
	    /// <summary>
		/// Adds message of 'debug' category to the message queue.				 
		/// </summary>		
        METHOD Debug : IAxoMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD
                
	    /// <summary>
		/// Adds message of 'error' category to the message queue.				 
		/// </summary>		
        METHOD Error : IAxoMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD
                
	    /// <summary>
		/// Adds message of 'information' category to the message queue.				 
		/// </summary>		
        METHOD Info : IAxoMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD
                                
	    /// <summary>
		/// Adds message of 'notification' category to the message queue.				 
		/// </summary>		
        METHOD Notify : IAxoMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD

                        
	    /// <summary>
		/// Adds message of 'programming error' category to the message queue.				 
		/// </summary>		
        METHOD Programming : IAxoMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD

                        
	    /// <summary>
		/// Adds message of 'trace' category to the message queue.				 
		/// </summary>		
        METHOD Trace : IAxoMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD

                        
	    /// <summary>
		/// Adds message of 'warning' category to the message queue.				 
		/// </summary>		
        METHOD Warning : IAxoMessageProperties
            VAR_INPUT
                /// <summary>
                /// Arbitrary message string.			 
                /// </summary>			
                Message : STRING[AxoIntConstants#MAX_MESSAGE_TEXT_LENGHT];
            END_VAR
        END_METHOD

        METHOD Build: IAxoMessageTextBuilder END_METHOD 

        /// <summary>
		/// Adds message of given category to the message queue.				 
		/// </summary>	
		/// <returns>Message index.</returns>		
        METHOD Post  : IAxoMessageProperties
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
        END_METHOD    
    
		/// <summary>
		/// Unpins this messenger.
		/// </summary>
        METHOD UnPin END_METHOD    
    
    END_INTERFACE
END_NAMESPACE








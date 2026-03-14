NAMESPACE AXOpen.Core
     INTERFACE PUBLIC IAxoMessagingServices 
        METHOD QueueMessage : BOOL
             VAR_INPUT
                inMessegenger : IAxoMessenger;
            END_VAR            
        END_METHOD
        /// <summary>
        /// Suspends the messaging system. When suspended, messages will not be sent to subscribers until the system is resumed.
        /// This is useful for scenarios where you want to temporarily prevent messages from being processed.
        /// </summary>
        METHOD SuspendMessaging END_METHOD    
       
        /// <summary>
        /// Resumes the messaging system. When resumed, messages that arose while the system was suspended will NOT be sent to subscribers.
        /// </summary>
        METHOD ResumeMessaging END_METHOD    

        /// <summary>
        /// Checks if the messaging system is currently suspended.
        /// Returns true if the messaging system is suspended, false otherwise.
        /// </summary>    
        METHOD IsSuspended : BOOL END_METHOD
            
        /// <summary>
        /// Requalifies the message category for downstream messages. 
        /// This is used to ensure that messages that are sent from a downstream component are categorized correctly, 
        /// even if the upstream component has a different message category.
        /// </summary>
        METHOD RequalifyDownstreamMessages
            VAR_INPUT
                inMessageCategory : AXOpen.Messaging.eAxoMessageCategory;
            END_VAR
        END_METHOD     

        /// <summary>
        /// Gets the requalified message category for downstream messages.
        /// </summary>
        METHOD GetRequalifiedMessageCategory : AXOpen.Messaging.eAxoMessageCategory END_METHOD            
    END_INTERFACE    
END_NAMESPACE

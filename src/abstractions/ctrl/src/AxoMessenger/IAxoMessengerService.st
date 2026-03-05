NAMESPACE AXOpen.Core
     INTERFACE PUBLIC IAxoMessagingServices 
        METHOD QueueMessage : BOOL
             VAR_INPUT
                inMessegenger : IAxoMessenger;
            END_VAR            
        END_METHOD
        METHOD SuspendMessaging END_METHOD    
        METHOD ResumeMessaging END_METHOD    
        METHOD IsSuspended : BOOL END_METHOD
    END_INTERFACE    
END_NAMESPACE

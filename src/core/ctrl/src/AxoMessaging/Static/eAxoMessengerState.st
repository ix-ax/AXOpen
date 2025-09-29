NAMESPACE AXOpen.Messaging
      TYPE                    
        eAxoMessengerState : (  Idle,                           // 0 - Not active
                                ActiveAlreadyAcknowledged,      // 1 - Is still active, but already acknowledged, after acknowledgement goes to 1                               
                                ActiveAcknowledgeRequired,      // 2 - Active and required acknowledgement. If acknowledged before deactivation, it goes to 0, if deactivated before acknowledgement, it goes to 4
                                ActiveAcknowledgeNotRequired,   // 3 - Active without acknowledgement required. After deactivation it goes to 1.
                                InactiveWaitingForAcknowledge,  // 4 - Not active waiting for acknowledgement. After acknowledgement it goes to 1.
                                InvalidImplementation           // 5 - Instance of the AxoMessenger has _NULL_CONTEXT or _NULL_RTM 
                                ) := Idle;
    END_TYPE
END_NAMESPACE
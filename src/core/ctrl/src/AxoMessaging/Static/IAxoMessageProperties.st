NAMESPACE AXOpen.Messaging.Static
    INTERFACE PUBLIC IAxoMessageProperties 
        METHOD RequireAcknowledgement : IAxoMessageProperties END_METHOD
        METHOD DoNotRequireAcknowledgement : IAxoMessageProperties END_METHOD
        METHOD IsAcknowledgementRequired : BOOL END_METHOD
    END_INTERFACE
END_NAMESPACE

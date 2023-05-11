NAMESPACE AXOpen.Messaging.Static
    INTERFACE IAxoMessageProperties 
        METHOD RequireAcknowledgement : IAxoMessageProperties END_METHOD
        METHOD DontRequireAcknowledgement : IAxoMessageProperties END_METHOD
        METHOD IsAcknowledgementRequired : BOOL END_METHOD
    END_INTERFACE
END_NAMESPACE

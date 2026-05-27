using System;

namespace AXOpen.Messaging.Static
{
    public interface IRankableMessage
    {
        string Symbol { get; }
        eAxoMessageCategory Category { get; }
        DateTime RisenUtc { get; }
        eAxoMessengerState State { get; }
        bool IsAcknowledged { get; }
        string DisplayMessage { get; }
        string SenderDisplayName { get; }
    }
}

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
        /// <summary>Human-readable hierarchical breadcrumb (AttributeName-based).</summary>
        string SenderDisplayName { get; }
        /// <summary>Full PLC symbol path of the sending messenger.</summary>
        string SenderSymbol { get; }
    }
}

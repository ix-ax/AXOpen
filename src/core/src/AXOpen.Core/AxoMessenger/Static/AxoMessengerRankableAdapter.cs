using System;

namespace AXOpen.Messaging.Static
{
    public sealed class AxoMessengerRankableAdapter : IRankableMessage
    {
        private readonly Func<string> _symbol;
        private readonly Func<eAxoMessageCategory> _category;
        private readonly Func<DateTime> _risenUtc;
        private readonly Func<eAxoMessengerState> _state;
        private readonly Func<bool> _isAcknowledged;
        private readonly Func<string> _displayMessage;
        private readonly Func<string> _senderDisplayName;

        public AxoMessengerRankableAdapter(
            Func<string> symbol,
            Func<eAxoMessageCategory> category,
            Func<DateTime> risenUtc,
            Func<eAxoMessengerState> state,
            Func<bool> isAcknowledged,
            Func<string> displayMessage,
            Func<string> senderDisplayName)
        {
            _symbol            = symbol            ?? throw new ArgumentNullException(nameof(symbol));
            _category          = category          ?? throw new ArgumentNullException(nameof(category));
            _risenUtc          = risenUtc          ?? throw new ArgumentNullException(nameof(risenUtc));
            _state             = state             ?? throw new ArgumentNullException(nameof(state));
            _isAcknowledged    = isAcknowledged    ?? throw new ArgumentNullException(nameof(isAcknowledged));
            _displayMessage    = displayMessage    ?? throw new ArgumentNullException(nameof(displayMessage));
            _senderDisplayName = senderDisplayName ?? throw new ArgumentNullException(nameof(senderDisplayName));
        }

        public string Symbol                       => _symbol();
        public eAxoMessageCategory Category        => _category();
        public DateTime RisenUtc                   => _risenUtc();
        public eAxoMessengerState State            => _state();
        public bool IsAcknowledged                 => _isAcknowledged();
        public string DisplayMessage               => _displayMessage();
        public string SenderDisplayName            => _senderDisplayName();
    }
}

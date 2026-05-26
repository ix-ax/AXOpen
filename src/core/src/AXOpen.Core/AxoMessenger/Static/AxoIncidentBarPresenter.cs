using System;
using System.Collections.Generic;
using System.Linq;

namespace AXOpen.Messaging.Static
{
    public enum IncidentBarSeverity
    {
        None,
        Info,
        Warning,
        Danger,
    }

    public sealed class AxoIncidentBarState
    {
        public bool IsVisible { get; init; }
        public bool Pulses { get; init; }
        public IncidentBarSeverity Severity { get; init; } = IncidentBarSeverity.None;
        public AxoProbableCause? TopCause { get; init; }
        public IReadOnlyList<AxoIncidentBarRow> Rows { get; init; } = Array.Empty<AxoIncidentBarRow>();
        public int AdditionalCount { get; init; }
    }

    public sealed record AxoIncidentBarRow(
        AxoProbableCause Cause,
        bool IsAckPending);

    public sealed class AxoIncidentBarPresenter
    {
        private readonly AxoCauseAnalyzer _analyzer;
        private readonly TimeSpan _idleHysteresis;
        private readonly Func<DateTime> _nowUtc;
        private readonly HashSet<string> _ackPending = new(StringComparer.Ordinal);
        private DateTime _lastNonEmptyAt = DateTime.MinValue;
        private bool _everHadTopCause;

        public AxoIncidentBarPresenter(
            AxoCauseAnalyzer analyzer,
            TimeSpan? idleHysteresis = null,
            Func<DateTime>? nowUtc = null)
        {
            _analyzer = analyzer ?? throw new ArgumentNullException(nameof(analyzer));
            _idleHysteresis = idleHysteresis ?? TimeSpan.FromSeconds(2);
            _nowUtc = nowUtc ?? (() => DateTime.UtcNow);
        }

        public event Action? StateChanged;

        public AxoIncidentBarState CurrentState => Compute();

        public void Refresh()
        {
            // Recompute pulls fresh analyzer values; the bar component triggers this after a poll tick.
            _ = Compute();
            StateChanged?.Invoke();
        }

        public void NotifyAckPending(IRankableMessage message)
        {
            if (message is null) return;
            _ackPending.Add(message.Symbol);
        }

        public void NotifyAckResolved(IRankableMessage message)
        {
            if (message is null) return;
            _ackPending.Remove(message.Symbol);
        }

        private AxoIncidentBarState Compute()
        {
            var now = _nowUtc();
            var top = _analyzer.TopCause;

            if (top != null)
            {
                _lastNonEmptyAt = now;
                _everHadTopCause = true;
                return new AxoIncidentBarState
                {
                    IsVisible = true,
                    Pulses = ShouldPulse(top.Message),
                    Severity = ToSeverityBucket(top.Message.Category),
                    TopCause = top,
                    Rows = _analyzer.ProbableCauses
                        .Select(c => new AxoIncidentBarRow(c, _ackPending.Contains(c.Message.Symbol)))
                        .ToArray(),
                    AdditionalCount = Math.Max(0, _analyzer.ProbableCauses.Count - 1),
                };
            }

            // Top cleared — apply idle hysteresis.
            if (_everHadTopCause && now - _lastNonEmptyAt < _idleHysteresis)
            {
                return new AxoIncidentBarState
                {
                    IsVisible = true,
                    Severity = IncidentBarSeverity.None,
                };
            }

            return new AxoIncidentBarState();
        }

        private static bool ShouldPulse(IRankableMessage m) =>
            !m.IsAcknowledged && (m.Category == eAxoMessageCategory.Critical || m.Category == eAxoMessageCategory.ProgrammingError);

        public static IncidentBarSeverity ToSeverityBucket(eAxoMessageCategory category) => category switch
        {
            eAxoMessageCategory.Critical         => IncidentBarSeverity.Danger,
            eAxoMessageCategory.ProgrammingError => IncidentBarSeverity.Danger,
            eAxoMessageCategory.Error            => IncidentBarSeverity.Danger,
            eAxoMessageCategory.Warning          => IncidentBarSeverity.Warning,
            eAxoMessageCategory.Potential        => IncidentBarSeverity.Info,
            eAxoMessageCategory.Info             => IncidentBarSeverity.Info,
            _                                    => IncidentBarSeverity.None,
        };

        // Tailwind tokens shared with AxoMessengerView's severity treatment.
        public static string GlowClass(IncidentBarSeverity sev) => sev switch
        {
            IncidentBarSeverity.Danger  => "shadow-glow-danger",
            IncidentBarSeverity.Warning => "shadow-glow-warning",
            IncidentBarSeverity.Info    => "shadow-glow-info",
            _                           => string.Empty,
        };

        public static string BadgeClass(IncidentBarSeverity sev) => sev switch
        {
            IncidentBarSeverity.Danger  => "badge badge-danger",
            IncidentBarSeverity.Warning => "badge badge-warning",
            IncidentBarSeverity.Info    => "badge badge-primary",
            _                           => string.Empty,
        };

        public static string BackgroundClass(IncidentBarSeverity sev) => sev switch
        {
            IncidentBarSeverity.Danger  => "bg-linear-to-br from-danger/20! from-0% to-background-light! to-50%",
            IncidentBarSeverity.Warning => "bg-linear-to-br from-warning/20! from-0% to-background-light! to-50%",
            IncidentBarSeverity.Info    => "bg-linear-to-br from-info/20! from-0% to-background-light! to-50%",
            _                           => string.Empty,
        };
    }
}

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
        Error,
        Critical,
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
            eAxoMessageCategory.Critical         => IncidentBarSeverity.Critical,
            eAxoMessageCategory.ProgrammingError => IncidentBarSeverity.Error,
            eAxoMessageCategory.Error            => IncidentBarSeverity.Error,
            eAxoMessageCategory.Warning          => IncidentBarSeverity.Warning,
            eAxoMessageCategory.Potential        => IncidentBarSeverity.Info,
            eAxoMessageCategory.Info             => IncidentBarSeverity.Info,
            _                                    => IncidentBarSeverity.None,
        };

        // Tailwind tokens shared with AxoMessengerView's severity treatment.
        public static string GlowClass(IncidentBarSeverity sev) => sev switch
        {
            IncidentBarSeverity.Critical => "shadow-glow-danger",
            IncidentBarSeverity.Error  => "shadow-glow-danger",
            IncidentBarSeverity.Warning => "shadow-glow-warning",
            IncidentBarSeverity.Info    => "shadow-glow-info",
            _                           => string.Empty,
        };

        public static string BadgeClass(IncidentBarSeverity sev) => sev switch
        {
            IncidentBarSeverity.Critical => "badge badge-danger",
            IncidentBarSeverity.Error  => "badge badge-danger",
            IncidentBarSeverity.Warning => "badge badge-warning",
            IncidentBarSeverity.Info    => "badge badge-primary",
            _                           => string.Empty,
        };

        // Flat tint with the same color token as the glow — no fade to neutral.
        // Uses /15 opacity step (precompiled in the template's momentum.css for danger/warning/info)
        // so the class actually renders without a Tailwind rebuild that scans this assembly's sources.
        public static string BackgroundClass(IncidentBarSeverity sev) => sev switch
        {
            IncidentBarSeverity.Critical => "bg-danger/15",
            IncidentBarSeverity.Error    => "bg-danger/15",
            IncidentBarSeverity.Warning  => "bg-warning/15",
            IncidentBarSeverity.Info     => "bg-info/15",
            _                            => string.Empty,
        };
    }
}

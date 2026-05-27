using System;
using System.Collections.Generic;
using System.Linq;

namespace AXOpen.Messaging.Static
{
    public sealed class AxoCauseAnalyzer
    {
        private const double W_SEV   = 0.40;
        private const double W_ROOT  = 0.30;
        private const double W_OWNER = 0.20;
        private const double W_UNACK = 0.10;
        private const double W_AGE   = 0.02;

        private readonly Func<IEnumerable<IRankableMessage>> _source;
        private readonly AxoCauseAnalyzerOptions _options;
        private readonly Func<DateTime> _nowUtc;
        private DateTime _lastPublishedUtc = DateTime.MinValue;

        public AxoCauseAnalyzer(
            Func<IEnumerable<IRankableMessage>> source,
            AxoCauseAnalyzerOptions? options = null,
            Func<DateTime>? nowUtc = null)
        {
            _source = source ?? throw new ArgumentNullException(nameof(source));
            _options = options ?? new AxoCauseAnalyzerOptions();
            _nowUtc = nowUtc ?? (() => DateTime.UtcNow);
        }

        public static AxoCauseAnalyzer Create(
            AxoMessageProvider provider,
            AxoCauseAnalyzerOptions? options = null,
            Func<DateTime>? nowUtc = null)
        {
            if (provider is null) throw new ArgumentNullException(nameof(provider));
            return new AxoCauseAnalyzer(
                () => (provider.Messengers ?? Array.Empty<AxoMessenger>()).Select(Adapt),
                options,
                nowUtc);
        }

        private static IRankableMessage Adapt(AxoMessenger m) =>
            new AxoMessengerRankableAdapter(
                symbol:            () => m.Symbol,
                category:          () => (eAxoMessageCategory)m.Category.LastValue,
                risenUtc:          () => m.Risen.LastValue,
                state:             () => m.State,
                isAcknowledged:    () => m.IsAcknowledged,
                displayMessage:    () => SafeMessageText(m),
                senderDisplayName: () => SenderName(m));

        private static string SafeMessageText(AxoMessenger m)
        {
            try { return m.GetMessageText(); }
            catch { return string.Empty; }
        }

        private static string SenderName(AxoMessenger m)
        {
            var comp = m.Component;
            return comp?.GetSymbolTail() ?? m.GetSymbolTail();
        }

        public AxoProbableCause? TopCause { get; private set; }
        public IReadOnlyList<AxoProbableCause> ProbableCauses { get; private set; } = Array.Empty<AxoProbableCause>();
        public int ActiveCount { get; private set; }
        public eAxoMessageCategory PeakSeverity { get; private set; } = eAxoMessageCategory.None;

        public event Action? Changed;

        public void Recompute()
        {
            var active = _source().Where(IsActive).ToList();
            var now = _nowUtc();
            var prevTopSymbol = TopCause?.Message.Symbol;

            // Always-accurate global stats — independent of the cause floor.
            ActiveCount = active.Count;
            PeakSeverity = active.Count == 0 ? eAxoMessageCategory.None : active.Max(m => m.Category);

            // Cause candidates are gated by the severity floor; below-floor active messages
            // still contribute to DownstreamCount of an above-floor parent, so the parent's
            // ownership reflects everything actually firing beneath it.
            var candidates = active.Where(m => m.Category >= _options.CauseSeverityFloor).ToList();

            if (candidates.Count == 0)
            {
                // Hold-cache: a momentary empty read inside HoldDuration of the last
                // non-empty publish is treated as PLC-cycle strobe and ignored.
                if (TopCause != null && now - _lastPublishedUtc < _options.HoldDuration)
                {
                    return;
                }
                TopCause = null;
                ProbableCauses = Array.Empty<AxoProbableCause>();
                RaiseChangedIfTopFlipped(prevTopSymbol);
                return;
            }

            var burstCutoff = candidates.Max(m => m.RisenUtc) - _options.BurstWindow;
            var earliestInBurst = candidates
                .Where(m => m.RisenUtc >= burstCutoff)
                .Min(m => m.RisenUtc);

            ProbableCauses = candidates
                .Select(m =>
                {
                    var isBurstRoot = m.RisenUtc == earliestInBurst && m.RisenUtc >= burstCutoff;
                    var downstream = active.Count(o => !ReferenceEquals(o, m) && IsDescendant(o.Symbol, m.Symbol));
                    var ageMinutes = Math.Max(0.0, (now - m.RisenUtc).TotalMinutes);
                    var score = W_SEV * SeverityWeight(m)
                              + (isBurstRoot ? W_ROOT : 0.0)
                              + W_OWNER * Math.Log10(1 + downstream)
                              + (m.IsAcknowledged ? 0.0 : W_UNACK)
                              - W_AGE * ageMinutes;
                    return new AxoProbableCause(m, score, isBurstRoot, downstream);
                })
                .OrderByDescending(c => c.Score)
                .Take(_options.TopN)
                .ToList();
            TopCause = ProbableCauses[0];
            _lastPublishedUtc = now;
            RaiseChangedIfTopFlipped(prevTopSymbol);
        }

        private void RaiseChangedIfTopFlipped(string? previousTopSymbol)
        {
            var current = TopCause?.Message.Symbol;
            if (!string.Equals(previousTopSymbol, current, StringComparison.Ordinal))
            {
                Changed?.Invoke();
            }
        }

        // Other is descendant of parent if its symbol starts with "parent.".
        private static bool IsDescendant(string otherSymbol, string parentSymbol) =>
            otherSymbol.Length > parentSymbol.Length + 1 &&
            otherSymbol.StartsWith(parentSymbol, StringComparison.Ordinal) &&
            otherSymbol[parentSymbol.Length] == '.';

        private static bool IsActive(IRankableMessage m) =>
            m.State == eAxoMessengerState.ActiveAcknowledgeRequired ||
            m.State == eAxoMessengerState.ActiveAcknowledgeNotRequired ||
            m.State == eAxoMessengerState.ActiveAlreadyAcknowledged;

        // Operator-actionability weights, not enum ordinals.
        // Error outranks ProgrammingError: a process Error needs operator action;
        // a ProgrammingError is an engineering bug surfaced for diagnostics.
        internal static double SeverityWeight(IRankableMessage m) => m.Category switch
        {
            eAxoMessageCategory.Critical         => 1.00,
            eAxoMessageCategory.Error            => 0.90,
            eAxoMessageCategory.ProgrammingError => 0.85,
            eAxoMessageCategory.Warning          => 0.60,
            eAxoMessageCategory.Potential        => 0.40,
            eAxoMessageCategory.Info             => 0.10,
            _                                    => 0.00,
        };
    }

    public sealed record AxoProbableCause(
        IRankableMessage Message,
        double Score,
        bool IsBurstRoot,
        int DownstreamCount);

    public sealed class AxoCauseAnalyzerOptions
    {
        public TimeSpan BurstWindow    { get; init; } = TimeSpan.FromSeconds(8);
        public TimeSpan HoldDuration   { get; init; } = TimeSpan.FromSeconds(2);
        public TimeSpan IdleHysteresis { get; init; } = TimeSpan.FromSeconds(2);
        public int      TopN           { get; init; } = 5;

        /// <summary>
        /// Minimum category for a message to enter the cause ranking.
        /// Messages below this threshold still count toward ActiveCount / PeakSeverity
        /// (so global indicators stay accurate) but never appear as probable causes.
        /// Default: Error.
        /// </summary>
        public eAxoMessageCategory CauseSeverityFloor { get; init; } = eAxoMessageCategory.Error;
    }
}

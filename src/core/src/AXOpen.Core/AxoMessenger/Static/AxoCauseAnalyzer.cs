using System;
using System.Collections.Generic;
using System.Linq;
using AXSharp.Connector;

namespace AXOpen.Messaging.Static
{
    public sealed class AxoCauseAnalyzer
    {
        private const double W_SEV   = 0.40;
        private const double W_ROOT  = 0.30;
        private const double W_OWNER = 0.20;
        private const double W_UNACK = 0.10;
        private const double W_AGE   = 0.02;
        private const double _maxAgeMinutes = 7 * 24 * 60; // 7 days

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
                senderDisplayName: () => SenderName(m),
                senderSymbol:      () => m.Symbol);

        private static string SafeMessageText(AxoMessenger m)
        {
            try { return m.GetMessageText(); }
            catch { return string.Empty; }
        }

        // Builds a top-down breadcrumb of AttributeName values from the messenger's
        // owning component up to (but excluding) the root. Falls back to GetSymbolTail
        // when no AttributeName chain is available.
        private static string SenderName(AxoMessenger m)
        {
            var origin = m.Component ?? (ITwinElement?)m.GetParent();
            if (origin is null) return m.GetSymbolTail();

            var path = new List<string>();
            ITwinElement? cur = origin;
            var guard = 0;
            while (cur is not null && guard++ < 32)
            {
                var name = SafeAttributeName(cur);
                if (string.IsNullOrEmpty(name)) break; // hit the unnamed root
                path.Insert(0, name);
                var parent = cur.GetParent();
                if (ReferenceEquals(parent, cur)) break;
                cur = parent;
            }
            return path.Count > 0
                ? string.Join(" › ", path)
                : (origin as ITwinObject)?.GetSymbolTail() ?? m.GetSymbolTail();
        }

        private static string SafeAttributeName(ITwinElement e)
        {
            try { return e.AttributeName ?? string.Empty; }
            catch { return string.Empty; }
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
            // Messengers with no message text (e.g. MessageCode == 0) are excluded —
            // there is nothing meaningful to show the operator.
            var candidates = active.Where(m =>
                    m.Category >= _options.CauseSeverityFloor &&
                    !string.IsNullOrWhiteSpace(m.DisplayMessage))
                .ToList();

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

            // Clamp to avoid DateTime underflow when RisenUtc is uninitialized
            // (DateTime.MinValue) — happens before ReadDetails has populated Risen.
            var maxRisen = candidates.Max(m => m.RisenUtc);
            var burstCutoff = maxRisen.Ticks > _options.BurstWindow.Ticks
                ? maxRisen - _options.BurstWindow
                : DateTime.MinValue;
            var earliestInBurst = candidates
                .Where(m => m.RisenUtc >= burstCutoff)
                .Min(m => m.RisenUtc);

            ProbableCauses = candidates
                .Select(m =>
                {
                    var isBurstRoot = m.RisenUtc == earliestInBurst && m.RisenUtc >= burstCutoff;
                    var downstream = active.Count(o => !ReferenceEquals(o, m) && IsDescendant(o.Symbol, m.Symbol));
                    // Cap age contribution: an uninitialized RisenUtc (DateTime.MinValue)
                    // would otherwise inject ~10^9 minutes and blow up the score.
                    // 7 days of accumulated penalty is more than enough to deprioritize
                    // a legitimately-old alarm without dominating the ranking.
                    var rawAgeMinutes = (now - m.RisenUtc).TotalMinutes;
                    var ageMinutes = Math.Min(_maxAgeMinutes, Math.Max(0.0, rawAgeMinutes));
                    var score = W_SEV * SeverityWeight(m)
                              + (isBurstRoot ? W_ROOT : 0.0)
                              + W_OWNER * Math.Log10(1 + downstream)
                              + (m.IsAcknowledged ? 0.0 : W_UNACK)
                              - W_AGE * ageMinutes;
                    return new AxoProbableCause(m, score, isBurstRoot, downstream);
                })
                // Severity-tier first so a higher severity (e.g. Critical) never ranks
                // below a lower one (e.g. Error) regardless of burst/ownership bonuses.
                // Uses SeverityWeight (the operator-actionability map) — not enum ordinal —
                // so Error (0.90) still outranks ProgrammingError (0.85) as documented.
                // Score is the within-tier tie-breaker.
                .OrderByDescending(c => SeverityWeight(c.Message))
                .ThenByDescending(c => c.Score)
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

        // Topology check: messengers are leaves under their CONTAINER component, so a
        // parent component's messenger and a child component's messenger are SIBLINGS in
        // the messenger flat list. We strip the last segment of each Symbol (the
        // messenger's own name) to recover the container path, then check if one
        // container is an ancestor of the other.
        private static string ContainerSymbol(string s)
        {
            var i = s.LastIndexOf('.');
            return i > 0 ? s.Substring(0, i) : string.Empty;
        }

        private static bool IsDescendant(string otherSymbol, string parentSymbol)
        {
            var pc = ContainerSymbol(parentSymbol);
            var oc = ContainerSymbol(otherSymbol);
            return oc.Length > pc.Length + 1 &&
                   oc.StartsWith(pc, StringComparison.Ordinal) &&
                   oc[pc.Length] == '.';
        }

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

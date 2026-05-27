using System;
using System.Collections.Generic;
using System.Linq;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using Xunit;

namespace axopen_core_tests.Messaging
{
    public class AxoCauseAnalyzerTests
    {
        private static FakeMsg Msg(
            string symbol,
            eAxoMessageCategory category = eAxoMessageCategory.Warning,
            DateTime? risen = null,
            eAxoMessengerState state = eAxoMessengerState.ActiveAcknowledgeRequired,
            bool acked = false)
            => new(
                Symbol: symbol,
                Category: category,
                RisenUtc: risen ?? new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc),
                State: state,
                IsAcknowledged: acked,
                DisplayMessage: symbol,
                SenderDisplayName: symbol);

        private sealed record FakeMsg(
            string Symbol,
            eAxoMessageCategory Category,
            DateTime RisenUtc,
            eAxoMessengerState State,
            bool IsAcknowledged,
            string DisplayMessage,
            string SenderDisplayName) : IRankableMessage;

        // Severity floor: only Error+ messages are considered probable causes by default.
        // Warning/Potential/Info still count in ActiveCount/PeakSeverity for the global indicator,
        // but the incident bar will not surface them as 'causes' (operator-noise reduction).
        [Fact]
        public void Default_cause_severity_floor_excludes_below_error()
        {
            var t = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var warning = Msg("Plc.A", eAxoMessageCategory.Warning, t);
            var info    = Msg("Plc.B", eAxoMessageCategory.Info,    t);
            var error   = Msg("Plc.C", eAxoMessageCategory.Error,   t);

            var analyzer = new AxoCauseAnalyzer(() => new[] { warning, info, error });
            analyzer.Recompute();

            Assert.Equal(3, analyzer.ActiveCount);
            Assert.Equal(eAxoMessageCategory.Error, analyzer.PeakSeverity);
            // Only the Error is a cause candidate
            Assert.Single(analyzer.ProbableCauses);
            Assert.Same(error, analyzer.TopCause!.Message);
        }

        [Fact]
        public void Warning_only_active_yields_no_top_cause()
        {
            var warning = Msg("Plc.A", eAxoMessageCategory.Warning);

            var analyzer = new AxoCauseAnalyzer(() => new[] { warning });
            analyzer.Recompute();

            Assert.Equal(1, analyzer.ActiveCount);
            Assert.Equal(eAxoMessageCategory.Warning, analyzer.PeakSeverity);
            Assert.Null(analyzer.TopCause);
            Assert.Empty(analyzer.ProbableCauses);
        }

        [Fact]
        public void Severity_floor_can_be_lowered_via_options()
        {
            var warning = Msg("Plc.A", eAxoMessageCategory.Warning);
            var analyzer = new AxoCauseAnalyzer(
                () => new[] { warning },
                options: new AxoCauseAnalyzerOptions { CauseSeverityFloor = eAxoMessageCategory.Info });
            analyzer.Recompute();

            Assert.Same(warning, analyzer.TopCause!.Message);
        }

        [Fact]
        public void Empty_set_yields_no_top_cause()
        {
            var analyzer = new AxoCauseAnalyzer(Array.Empty<IRankableMessage>);

            analyzer.Recompute();

            Assert.Null(analyzer.TopCause);
            Assert.Empty(analyzer.ProbableCauses);
            Assert.Equal(0, analyzer.ActiveCount);
            Assert.Equal(eAxoMessageCategory.None, analyzer.PeakSeverity);
        }

        [Fact]
        public void Single_active_critical_becomes_top()
        {
            var critical = Msg("Plc.Tank.Pressure", eAxoMessageCategory.Critical);
            var analyzer = new AxoCauseAnalyzer(() => new[] { critical });

            analyzer.Recompute();

            Assert.NotNull(analyzer.TopCause);
            Assert.Same(critical, analyzer.TopCause!.Message);
            Assert.Equal(1, analyzer.ActiveCount);
            Assert.Equal(eAxoMessageCategory.Critical, analyzer.PeakSeverity);
            Assert.Single(analyzer.ProbableCauses);
        }

        [Fact]
        public void Critical_outranks_error_when_burst_and_topology_tied()
        {
            var risen = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var error    = Msg("Plc.A", eAxoMessageCategory.Error,    risen);
            var critical = Msg("Plc.B", eAxoMessageCategory.Critical, risen);

            // Critical declared LAST in input order to prove ordering is by score, not insertion.
            var analyzer = new AxoCauseAnalyzer(() => new[] { error, critical });
            analyzer.Recompute();

            Assert.Same(critical, analyzer.TopCause!.Message);
            Assert.Equal(2, analyzer.ProbableCauses.Count);
            Assert.Same(critical, analyzer.ProbableCauses[0].Message);
            Assert.Same(error,    analyzer.ProbableCauses[1].Message);
        }

        // Operator-actionability map: Error (0.9) ranks ABOVE ProgrammingError (0.85),
        // even though enum ordinal 400 > 300. Encodes intent over enum.
        [Fact]
        public void Error_outranks_programming_error_per_explicit_severity_map()
        {
            var risen = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var error   = Msg("Plc.A", eAxoMessageCategory.Error,            risen);
            var progErr = Msg("Plc.B", eAxoMessageCategory.ProgrammingError, risen);

            var analyzer = new AxoCauseAnalyzer(() => new[] { progErr, error });
            analyzer.Recompute();

            Assert.Same(error, analyzer.TopCause!.Message);
        }

        [Fact]
        public void Earliest_in_burst_window_wins_burst_root_flag()
        {
            var t0 = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var earliest = Msg("Plc.A", eAxoMessageCategory.Error, t0);
            var later    = Msg("Plc.B", eAxoMessageCategory.Error, t0.AddSeconds(2));

            var analyzer = new AxoCauseAnalyzer(() => new[] { later, earliest });
            analyzer.Recompute();

            // earliest gets root flag and the W_root bonus, so it sorts to top
            Assert.Same(earliest, analyzer.TopCause!.Message);
            Assert.True(analyzer.TopCause.IsBurstRoot);
            Assert.False(analyzer.ProbableCauses[1].IsBurstRoot);
        }

        // Among non-burst-root messages of equal severity, age decay must order
        // the fresher alarm above the stale one. Operators should focus on what
        // changed recently, not what has been ringing for an hour.
        [Fact]
        public void Age_decay_demotes_long_running_alarm_below_newer_peer()
        {
            var now = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var stale  = Msg("Plc.Stale",  eAxoMessageCategory.Error, now.AddMinutes(-60));
            var fresh  = Msg("Plc.Fresh",  eAxoMessageCategory.Error, now.AddMinutes(-10));
            var anchor = Msg("Plc.Anchor", eAxoMessageCategory.Error, now); // window anchor, becomes root

            var analyzer = new AxoCauseAnalyzer(
                () => new[] { stale, fresh, anchor },
                nowUtc: () => now);
            analyzer.Recompute();

            var byMsg = analyzer.ProbableCauses.ToDictionary(c => c.Message);
            // anchor is root, top regardless of age
            Assert.Same(anchor, analyzer.TopCause!.Message);
            // among non-root peers, fresher wins
            Assert.True(byMsg[fresh].Score > byMsg[stale].Score,
                $"fresh ({byMsg[fresh].Score}) must outrank stale ({byMsg[stale].Score})");
        }

        [Fact]
        public void Changed_event_fires_only_on_top_cause_symbol_flip()
        {
            var t = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var a = Msg("Plc.A", eAxoMessageCategory.Critical, t);
            var b = Msg("Plc.B", eAxoMessageCategory.Critical, t);

            IEnumerable<IRankableMessage> source = Array.Empty<IRankableMessage>();
            var now = t;
            var analyzer = new AxoCauseAnalyzer(
                () => source,
                options: new AxoCauseAnalyzerOptions { HoldDuration = TimeSpan.Zero },
                nowUtc: () => now);

            var fires = 0;
            analyzer.Changed += () => fires++;

            // First publish (null → A) — flip
            source = new[] { a };
            analyzer.Recompute();
            Assert.Equal(1, fires);

            // Same A — no flip
            analyzer.Recompute();
            Assert.Equal(1, fires);

            // Symbol flips A → B
            source = new[] { b };
            analyzer.Recompute();
            Assert.Equal(2, fires);

            // Same B — no flip
            analyzer.Recompute();
            Assert.Equal(2, fires);

            // B → null (HoldDuration=0 lets the empty publish through)
            source = Array.Empty<IRankableMessage>();
            analyzer.Recompute();
            Assert.Equal(3, fires);
        }

        [Fact]
        public void HoldDuration_suppresses_rank_strobe()
        {
            // Simulates mid-PLC-cycle read where active count briefly drops to 0
            // before the next cycle re-populates. Bar must not flicker.
            var risen = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var critical = Msg("Plc.X", eAxoMessageCategory.Critical, risen);
            IEnumerable<IRankableMessage> source = new[] { critical };

            var now = risen;
            var analyzer = new AxoCauseAnalyzer(
                () => source,
                options: new AxoCauseAnalyzerOptions { HoldDuration = TimeSpan.FromSeconds(2) },
                nowUtc: () => now);

            analyzer.Recompute();
            Assert.Same(critical, analyzer.TopCause!.Message);

            // 0.5s later, source momentarily empty — held
            now = risen.AddSeconds(0.5);
            source = Array.Empty<IRankableMessage>();
            analyzer.Recompute();
            Assert.Same(critical, analyzer.TopCause!.Message);

            // 3s later, hold expired — clears
            now = risen.AddSeconds(3);
            analyzer.Recompute();
            Assert.Null(analyzer.TopCause);
        }

        [Fact]
        public void TopN_clamps_published_list()
        {
            var t = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var msgs = Enumerable.Range(0, 10)
                .Select(i => Msg($"Plc.M{i:00}", eAxoMessageCategory.Error, t.AddSeconds(i)))
                .ToArray<IRankableMessage>();

            var analyzer = new AxoCauseAnalyzer(
                () => msgs,
                options: new AxoCauseAnalyzerOptions { TopN = 3 });
            analyzer.Recompute();

            Assert.Equal(10, analyzer.ActiveCount);
            Assert.Equal(3, analyzer.ProbableCauses.Count);
        }

        [Fact]
        public void Acked_active_is_listed_but_scored_lower_than_equivalent_unacked()
        {
            var t = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var acked   = Msg("Plc.A", eAxoMessageCategory.Error, t,
                              state: eAxoMessengerState.ActiveAlreadyAcknowledged, acked: true);
            var unacked = Msg("Plc.B", eAxoMessageCategory.Error, t,
                              state: eAxoMessengerState.ActiveAcknowledgeRequired,  acked: false);

            var analyzer = new AxoCauseAnalyzer(() => new[] { acked, unacked });
            analyzer.Recompute();

            Assert.Equal(2, analyzer.ProbableCauses.Count);
            Assert.Same(unacked, analyzer.TopCause!.Message);
            Assert.True(analyzer.ProbableCauses[0].Score > analyzer.ProbableCauses[1].Score);
        }

        [Fact]
        public void Symbol_prefix_owner_gets_downstream_count()
        {
            var t = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var station = Msg("Plc.Station",            eAxoMessageCategory.Error, t);
            var drive   = Msg("Plc.Station.Drive",      eAxoMessageCategory.Error, t);
            var encoder = Msg("Plc.Station.Drive.Enc",  eAxoMessageCategory.Error, t);
            var unrelated = Msg("Plc.Conveyor",         eAxoMessageCategory.Error, t);

            var analyzer = new AxoCauseAnalyzer(() => new[] { station, drive, encoder, unrelated });
            analyzer.Recompute();

            var byMsg = analyzer.ProbableCauses.ToDictionary(c => c.Message);
            Assert.Equal(2, byMsg[station].DownstreamCount);
            Assert.Equal(1, byMsg[drive].DownstreamCount);
            Assert.Equal(0, byMsg[encoder].DownstreamCount);
            Assert.Equal(0, byMsg[unrelated].DownstreamCount);
        }

        // Default burst window = 8s ending at latest Risen.
        // A message older than the window is NOT eligible to be burst root,
        // even though it's globally the earliest.
        [Fact]
        public void Burst_window_is_sliding_from_latest_risen()
        {
            var t0 = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var old        = Msg("Plc.A", eAxoMessageCategory.Error, t0);                  // 15s before latest, OUT
            var earlyBurst = Msg("Plc.B", eAxoMessageCategory.Error, t0.AddSeconds(10));   // within 8s window, IN
            var latest     = Msg("Plc.C", eAxoMessageCategory.Error, t0.AddSeconds(15));   // window anchor

            var analyzer = new AxoCauseAnalyzer(() => new[] { old, earlyBurst, latest });
            analyzer.Recompute();

            var byMsg = analyzer.ProbableCauses.ToDictionary(c => c.Message);
            Assert.False(byMsg[old].IsBurstRoot,        "old message must NOT be burst root (outside window)");
            Assert.True (byMsg[earlyBurst].IsBurstRoot, "earliest IN window must be burst root");
            Assert.False(byMsg[latest].IsBurstRoot,     "latest is window anchor, not earliest");
        }
    }
}

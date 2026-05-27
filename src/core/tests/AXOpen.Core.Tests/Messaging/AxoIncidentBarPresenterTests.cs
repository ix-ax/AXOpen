using System;
using System.Collections.Generic;
using System.Linq;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using Xunit;

namespace axopen_core_tests.Messaging
{
    public class AxoIncidentBarPresenterTests
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

        private static (AxoCauseAnalyzer analyzer, Action<IEnumerable<IRankableMessage>> setSource, Action<DateTime> setNow)
            BuildAnalyzer(TimeSpan? hold = null, eAxoMessageCategory? floor = null)
        {
            IEnumerable<IRankableMessage> source = Array.Empty<IRankableMessage>();
            DateTime now = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var analyzer = new AxoCauseAnalyzer(
                () => source,
                options: new AxoCauseAnalyzerOptions
                {
                    HoldDuration = hold ?? TimeSpan.Zero,
                    // Default tests below Error need floor lowered explicitly.
                    CauseSeverityFloor = floor ?? eAxoMessageCategory.Error,
                },
                nowUtc: () => now);
            return (analyzer, s => source = s, t => now = t);
        }

        [Fact]
        public void Bar_is_hidden_when_active_count_is_zero()
        {
            var (analyzer, _, _) = BuildAnalyzer();
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(analyzer);

            Assert.False(presenter.CurrentState.IsVisible);
            Assert.Null(presenter.CurrentState.TopCause);
            Assert.Equal(IncidentBarSeverity.None, presenter.CurrentState.Severity);
        }

        [Fact]
        public void Bar_is_visible_when_top_cause_exists()
        {
            var (analyzer, setSource, _) = BuildAnalyzer();
            setSource(new[] { Msg("Plc.X", eAxoMessageCategory.Error) });
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(analyzer);

            Assert.True(presenter.CurrentState.IsVisible);
            Assert.NotNull(presenter.CurrentState.TopCause);
        }

        // Below-floor categories still need the bucket mapping for any consumer that
        // calls ToSeverityBucket directly (e.g. row rendering of a manually shown alarm).
        // Floor lowered to Info so the analyzer surfaces them as causes for the test.
        [Theory]
        [InlineData(eAxoMessageCategory.Critical,         IncidentBarSeverity.Critical)]
        [InlineData(eAxoMessageCategory.Error,            IncidentBarSeverity.Error)]
        [InlineData(eAxoMessageCategory.ProgrammingError, IncidentBarSeverity.Error)]
        [InlineData(eAxoMessageCategory.Warning,          IncidentBarSeverity.Warning)]
        [InlineData(eAxoMessageCategory.Potential,        IncidentBarSeverity.Info)]
        [InlineData(eAxoMessageCategory.Info,             IncidentBarSeverity.Info)]
        public void Severity_maps_category_to_visual_bucket(eAxoMessageCategory cat, IncidentBarSeverity expected)
        {
            var (analyzer, setSource, _) = BuildAnalyzer(floor: eAxoMessageCategory.Info);
            setSource(new[] { Msg("Plc.X", cat) });
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(analyzer);

            Assert.Equal(expected, presenter.CurrentState.Severity);
        }

        [Theory]
        [InlineData(eAxoMessageCategory.Critical,         true)]
        [InlineData(eAxoMessageCategory.ProgrammingError, true)]
        [InlineData(eAxoMessageCategory.Error,            false)] // pulse reserved for system-critical only
        [InlineData(eAxoMessageCategory.Warning,          false)]
        [InlineData(eAxoMessageCategory.Info,             false)]
        public void Pulse_only_for_critical_class_when_top_not_acked(eAxoMessageCategory cat, bool expectedPulse)
        {
            var (analyzer, setSource, _) = BuildAnalyzer(floor: eAxoMessageCategory.Info);
            setSource(new[] { Msg("Plc.X", cat) });
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(analyzer);

            Assert.Equal(expectedPulse, presenter.CurrentState.Pulses);
        }

        [Fact]
        public void Pulse_disabled_when_top_cause_is_acknowledged()
        {
            var (analyzer, setSource, _) = BuildAnalyzer();
            setSource(new[] { Msg("Plc.X", eAxoMessageCategory.Critical,
                state: eAxoMessengerState.ActiveAlreadyAcknowledged, acked: true) });
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(analyzer);

            Assert.True(presenter.CurrentState.IsVisible);
            Assert.False(presenter.CurrentState.Pulses);
        }

        [Fact]
        public void Additional_count_equals_visible_rows_minus_one()
        {
            var t = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var (analyzer, setSource, _) = BuildAnalyzer();
            setSource(new[]
            {
                Msg("Plc.A", eAxoMessageCategory.Error, t),
                Msg("Plc.B", eAxoMessageCategory.Error, t),
                Msg("Plc.C", eAxoMessageCategory.Error, t),
            });
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(analyzer);

            Assert.Equal(3, presenter.CurrentState.Rows.Count);
            Assert.Equal(2, presenter.CurrentState.AdditionalCount); // 3 rows - 1 top
        }

        [Fact]
        public void Rows_match_analyzer_probable_causes_in_order()
        {
            var t = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var a = Msg("Plc.A", eAxoMessageCategory.Error, t);
            var b = Msg("Plc.B", eAxoMessageCategory.Critical, t);

            var (analyzer, setSource, _) = BuildAnalyzer();
            setSource(new[] { a, b });
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(analyzer);

            Assert.Equal(2, presenter.CurrentState.Rows.Count);
            Assert.Same(b, presenter.CurrentState.Rows[0].Cause.Message);
            Assert.Same(a, presenter.CurrentState.Rows[1].Cause.Message);
        }

        [Fact]
        public void Ack_pending_marker_persists_until_resolved()
        {
            var critical = Msg("Plc.X", eAxoMessageCategory.Critical);
            var (analyzer, setSource, _) = BuildAnalyzer();
            setSource(new[] { critical });
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(analyzer);
            Assert.False(presenter.CurrentState.Rows[0].IsAckPending);

            presenter.NotifyAckPending(critical);
            Assert.True(presenter.CurrentState.Rows[0].IsAckPending);

            presenter.NotifyAckResolved(critical);
            Assert.False(presenter.CurrentState.Rows[0].IsAckPending);
        }

        [Theory]
        [InlineData(IncidentBarSeverity.Critical, "shadow-glow-danger")]
        [InlineData(IncidentBarSeverity.Error,    "shadow-glow-danger")]
        [InlineData(IncidentBarSeverity.Warning,  "shadow-glow-warning")]
        [InlineData(IncidentBarSeverity.Info,     "shadow-glow-info")]
        [InlineData(IncidentBarSeverity.None,     "")]
        public void Glow_class_matches_severity_bucket(IncidentBarSeverity sev, string expected)
        {
            Assert.Equal(expected, AxoIncidentBarPresenter.GlowClass(sev));
        }

        [Theory]
        [InlineData(IncidentBarSeverity.Critical, "badge badge-danger")]
        [InlineData(IncidentBarSeverity.Error,    "badge badge-danger")]
        [InlineData(IncidentBarSeverity.Warning,  "badge badge-warning")]
        [InlineData(IncidentBarSeverity.Info,     "badge badge-primary")]
        [InlineData(IncidentBarSeverity.None,     "")]
        public void Badge_class_matches_severity_bucket(IncidentBarSeverity sev, string expected)
        {
            Assert.Equal(expected, AxoIncidentBarPresenter.BadgeClass(sev));
        }

        // Background color token must match the glow color token for the same severity
        // (e.g. both 'danger' or both 'warning'), so the bar reads as a single chromatic block.
        [Theory]
        [InlineData(IncidentBarSeverity.Critical, "danger")]
        [InlineData(IncidentBarSeverity.Error,    "danger")]
        [InlineData(IncidentBarSeverity.Warning,  "warning")]
        [InlineData(IncidentBarSeverity.Info,     "info")]
        public void Background_uses_same_color_token_as_glow(IncidentBarSeverity sev, string token)
        {
            var bg = AxoIncidentBarPresenter.BackgroundClass(sev);
            var glow = AxoIncidentBarPresenter.GlowClass(sev);

            Assert.Contains(token, bg);
            Assert.Contains(token, glow);
        }

        [Fact]
        public void Background_class_is_empty_for_none_severity()
        {
            Assert.Equal(string.Empty, AxoIncidentBarPresenter.BackgroundClass(IncidentBarSeverity.None));
        }

        [Fact]
        public void Idle_hysteresis_keeps_bar_visible_after_top_cause_clears()
        {
            var t0 = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);
            var now = t0;
            IEnumerable<IRankableMessage> source = new[] { Msg("Plc.X", eAxoMessageCategory.Error, t0) };

            var analyzer = new AxoCauseAnalyzer(
                () => source,
                options: new AxoCauseAnalyzerOptions { HoldDuration = TimeSpan.Zero },
                nowUtc: () => now);
            analyzer.Recompute();

            var presenter = new AxoIncidentBarPresenter(
                analyzer,
                idleHysteresis: TimeSpan.FromSeconds(2),
                nowUtc: () => now);
            Assert.True(presenter.CurrentState.IsVisible);

            // Clear and refresh at t+0.5s — still visible (within hysteresis)
            source = Array.Empty<IRankableMessage>();
            now = t0.AddSeconds(0.5);
            analyzer.Recompute();
            presenter.Refresh();
            Assert.True(presenter.CurrentState.IsVisible);

            // At t+3s, past hysteresis — gone
            now = t0.AddSeconds(3);
            presenter.Refresh();
            Assert.False(presenter.CurrentState.IsVisible);
        }
    }
}

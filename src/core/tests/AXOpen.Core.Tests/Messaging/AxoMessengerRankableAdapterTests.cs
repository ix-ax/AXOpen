using System;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using Xunit;

namespace axopen_core_tests.Messaging
{
    public class AxoMessengerRankableAdapterTests
    {
        [Fact]
        public void Adapter_projects_each_field_from_supplied_delegates()
        {
            var risen = new DateTime(2026, 5, 26, 12, 0, 0, DateTimeKind.Utc);

            var adapter = new AxoMessengerRankableAdapter(
                symbol:            () => "Plc.Tank.Pressure",
                category:          () => eAxoMessageCategory.Critical,
                risenUtc:          () => risen,
                state:             () => eAxoMessengerState.ActiveAcknowledgeRequired,
                isAcknowledged:    () => false,
                displayMessage:    () => "Tank pressure above safe limit",
                senderDisplayName: () => "Plant › Tank",
                senderSymbol:      () => "Plc.Tank.Pressure");

            Assert.Equal("Plc.Tank.Pressure",                                  adapter.Symbol);
            Assert.Equal(eAxoMessageCategory.Critical,                         adapter.Category);
            Assert.Equal(risen,                                                adapter.RisenUtc);
            Assert.Equal(eAxoMessengerState.ActiveAcknowledgeRequired,         adapter.State);
            Assert.False(adapter.IsAcknowledged);
            Assert.Equal("Tank pressure above safe limit",                     adapter.DisplayMessage);
            Assert.Equal("Plant › Tank",                                       adapter.SenderDisplayName);
            Assert.Equal("Plc.Tank.Pressure",                                  adapter.SenderSymbol);
        }

        [Fact]
        public void SenderSymbol_falls_back_to_Symbol_when_not_provided()
        {
            var adapter = new AxoMessengerRankableAdapter(
                symbol:            () => "Plc.X",
                category:          () => eAxoMessageCategory.Error,
                risenUtc:          () => DateTime.UtcNow,
                state:             () => eAxoMessengerState.ActiveAcknowledgeRequired,
                isAcknowledged:    () => false,
                displayMessage:    () => "",
                senderDisplayName: () => "");

            Assert.Equal("Plc.X", adapter.SenderSymbol);
        }

        // Delegates must be re-invoked on each access so the adapter sees the latest
        // batch-read value, not a stale snapshot captured at construction.
        [Fact]
        public void Adapter_re_invokes_delegates_on_each_access()
        {
            var state = eAxoMessengerState.ActiveAcknowledgeRequired;
            var acked = false;

            var adapter = new AxoMessengerRankableAdapter(
                symbol:            () => "X",
                category:          () => eAxoMessageCategory.Error,
                risenUtc:          () => DateTime.UtcNow,
                state:             () => state,
                isAcknowledged:    () => acked,
                displayMessage:    () => "",
                senderDisplayName: () => "");

            Assert.False(adapter.IsAcknowledged);
            Assert.Equal(eAxoMessengerState.ActiveAcknowledgeRequired, adapter.State);

            state = eAxoMessengerState.ActiveAlreadyAcknowledged;
            acked = true;

            Assert.True(adapter.IsAcknowledged);
            Assert.Equal(eAxoMessengerState.ActiveAlreadyAcknowledged, adapter.State);
        }
    }
}

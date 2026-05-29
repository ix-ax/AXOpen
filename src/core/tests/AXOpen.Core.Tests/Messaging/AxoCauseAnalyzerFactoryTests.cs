using System;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using Xunit;

namespace axopen_core_tests.Messaging
{
    public class AxoCauseAnalyzerFactoryTests
    {
        [Fact]
        public void Create_throws_when_provider_is_null()
        {
            Assert.Throws<ArgumentNullException>(() =>
                AxoCauseAnalyzer.Create(provider: null!));
        }

        [Fact]
        public void Create_wraps_provider_with_zero_observed_objects_yields_empty_analyzer()
        {
            var provider = AxoMessageProvider.Create(Array.Empty<ITwinObject>());
            var analyzer = AxoCauseAnalyzer.Create(provider);

            analyzer.Recompute();

            Assert.Null(analyzer.TopCause);
            Assert.Equal(0, analyzer.ActiveCount);
        }
    }
}

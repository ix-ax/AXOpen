using AXOpen;
using System.Linq;
using AXOpen.Core;
using AXOpen.Logging;
using AXSharp.Connector.Localizations;
using NSubstitute.Extensions;

namespace axopen_core_tests
{
    using AXOpen.Logging;
    using System;
    using Xunit;
    using NSubstitute;
    using AXSharp.Connector;
    using System.Threading.Tasks;

    public class AxoLoggerTests
    {
        private AxoLogger _testClass;
        private ITwinObject _parent;
        private string _readableTail;
        private string _symbolTail;

        public AxoLoggerTests()
        {
            _parent = Substitute.For<ITwinObject>();
            _parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            _readableTail = "TestValue1128568445";
            _symbolTail = "TestValue807960868";
            _testClass = new AxoLogger(_parent, _readableTail, _symbolTail);
        }

        [Fact]
        public void CanCallStartDequeuing()
        {
            // Arrange
            var dequeuingInterval = 100;

            // Act
            _testClass.StartDequeuing(AxoApplication.Current.Logger, dequeuingInterval);
        }

        [Fact]
        public async Task CanCallDequeue()
        {
            _testClass.SetLogger(AxoApplication.Current.Logger);
            foreach (var level in Enum.GetValues(typeof(eLogLevel)).Cast<eLogLevel>().ToList().Where(p => p != eLogLevel.NoCat))
            {
                await _testClass.LogEntries[0].Message.SetAsync($"this is {level} message");
                await _testClass.LogEntries[0].ToDequeue.SetAsync(true);
                await _testClass.LogEntries[0].Level.SetAsync((short)level);
                await _testClass.LogEntries[0].Sender.SetAsync((ulong)0);
                // Act
                await _testClass.Dequeue();

                // Assert
                var logger = AxoApplication.Current.Logger as DummyLogger;
                Assert.Equal($"!!! : [no identity provided '0']", logger.LastMessage);
                Assert.Equal(level.ToString(), logger.LastCategory);
                Assert.False(await _testClass.LogEntries[0].ToDequeue.GetAsync());
            }
        }
    }
}
using Ix.Connector;
using ix.framework.core;

namespace ix.framework.coretests
{
    using ix.framework.core;
    using System;
    using Xunit;

    public class IxTaskTests
    {
        private IxTask _testClass;

        public IxTaskTests()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            _testClass = new IxTask(a.GetConnector(null) as ITwinObject, "a", "b");
        }

        [Fact]
        public async Task CanCallCanExecute_true()
        {
            // Arrange
            var parameter = new object();
            await _testClass.IsDisabled.SetAsync(true);

            // Act
            var result = _testClass.CanExecute(parameter);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public async Task CanCallCanExecute_false()
        {
            // Arrange
            var parameter = new object();
            await _testClass.IsDisabled.SetAsync(false);

            // Act
            var result = _testClass.CanExecute(parameter);

            // Assert
            Assert.True(result);
        }


        [Fact]
        public async Task CanCallExecute()
        {
            // Arrange
            var parameter = new object();

            // Act
            _testClass.Execute(parameter);

            // Assert
            Assert.True(await _testClass.RemoteInvoke.GetAsync());
        }
    }
}
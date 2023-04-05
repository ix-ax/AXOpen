using AXSharp.Connector;
using AXOpen.Core;

namespace AXOpen.Core.Tests
{
    using System;
    using Xunit;

    public class AxoTaskTests
    {
        private AxoTask _testClass;

        public AxoTaskTests()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            _testClass = new AxoTask(a.GetConnector(null) as ITwinObject, "a", "b");
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
        }
    }
}
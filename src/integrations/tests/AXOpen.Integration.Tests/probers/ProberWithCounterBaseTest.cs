using IntegrationTests;
using axopen_integrations;
using AXSharp.Connector;



namespace integartions.probers
{

    using System;
    using Xunit;

    public class ProberWithCounterBaseTest
    {
        private ProbersTestContext testContext = Entry.Plc.Integrations.Probers;

        public ProberWithCounterBaseTest()
        {
        }

        [Fact]
        public async Task ProbeWithCounterExecutesTest()
        {
            //--Arrange
            var sut = testContext.ProbeWithCounterTests;
            await sut._didExecuteTestMethod.SetAsync(false);
            await sut._numberOfCalls.SetAsync(0);

            //-- Act
            await sut.RunTest(10);

            //-- Assert
            Assert.True(sut._didExecuteTestMethod.GetAsync().Result);
            Assert.Equal(10ul, sut._numberOfCalls.GetAsync().Result);
        }
    }
}
using Ix.Connector;
using ix_ax_ix_framework_probers;


namespace AXOpen.proberstests
{

    using System;
    using Xunit;

    public class ProberWithCounterBaseTest
    {
        private TestContext testContext = Entry.Plc.TestContext;

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
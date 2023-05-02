using Ix.Connector;
using ix_ax_ix_framework_probers;


namespace AXOpen.proberstests
{

    using System;
    using Xunit;

    public class ProberWithDoneConditionBaseTest
    {
        private TestContext testContext = Entry.Plc.TestContext;

        public ProberWithDoneConditionBaseTest()
        {
        }

        [Fact]
        public async Task ProberWithCompletedConditionTest()
        {
            //--Arrange
            var sut = testContext.ProbeWithEndConditionTests;
            await sut._didExecuteTestMethod.SetAsync(false);
            await sut._numberOfCalls.SetAsync(0);

            //-- Act
            await sut.RunTest();

            //-- Assert
            Assert.True(sut._didExecuteTestMethod.GetAsync().Result);
            Assert.Equal(123ul, sut._numberOfCalls.GetAsync().Result);


        }

    }
}
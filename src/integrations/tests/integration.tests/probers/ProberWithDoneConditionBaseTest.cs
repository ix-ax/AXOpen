using IntegrationTests;
using intergrations;
using AXSharp.Connector;
using ix.framework.probers;


namespace integartions.probers
{

    using System;
    using Xunit;

    public class ProberWithDoneConditionBaseTest
    {
        private ProbersTestContext testContext = Entry.Plc.Integrations.Probers;

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
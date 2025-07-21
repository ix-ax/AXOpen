using AXSharp.Connector;

namespace AXOpen.Data.Tests
{
    using Tests_L1.FragmentData;
    using Pocos.Tests_L1;

    public class DistributedTests
    {
        [Fact]
        public async void should_collect_managers()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var context = connector.Distributed;

            var dService = new DistributedDataExchangeService();

            dService.CollectAxoDataExchanges(context);

            Assert.Equal(4, dService.GetExchanges("Group_1", false).Count);
            Assert.Equal(3, dService.GetExchanges("Group_2", false).Count);
            Assert.Equal(2, dService.GetExchanges("Group_3", false).Count);
            Assert.Equal(1, dService.GetExchanges("Group_4", false).Count);

            Assert.Equal(2, dService.GetExchanges("Group_1", true).Count);
            Assert.Equal(2, dService.GetExchanges("Group_2", true).Count);
            Assert.Equal(1, dService.GetExchanges("Group_3", true).Count);
            Assert.Equal(1, dService.GetExchanges("Group_4", true).Count);

            Assert.Equal(2, dService.GetExchanges("AxoDataFragmentExchange", false).Count);
            Assert.Equal(3, dService.GetExchanges("AxoObjectWrap", false).Count);
        }

        
    }
}
using System;
using AXOpen.Base.Data;
using AXOpen.Data.InMemory;
using AXSharp.Connector;
using NSubstitute;

namespace AXOpen.Data.Tests
{
    using TOnline = AXOpen.Data.AxoDataEntity;
    using TPlain = Pocos.AXOpen.Data.AxoDataEntity;
    using System.IO.Compression;
    using System.IO;
    using System.Security.Claims;

    public class DistributedTests
    {
        [Fact]
        public async void should_collect_managers()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var context = new DistributedDataTest.Context(parent, "c", "c");

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
        }
    }
}
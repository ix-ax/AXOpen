using Xunit;
using ix.framework.core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Channels;
using System.Threading.Tasks;
using Ix.Connector;

namespace ix.framework.core.Tests
{
    public class IxRemoteTaskTests
    {
        [Fact()]
        public void InitializeTest()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new IxRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.Initialize(() => Console.WriteLine(""));

            Assert.True(sut.IsInitialized.GetAsync().Result);

        }

        [Fact()]
        public void InitializeTest1()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new IxRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.Initialize(() => true);

            Assert.True(sut.IsInitialized.GetAsync().Result);
        }

        [Fact()]
        public void InitializeExclusivelyTest()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new IxRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.InitializeExclusively(() => Console.WriteLine(""));

            Assert.True(sut.IsInitialized.GetAsync().Result);

            Assert.Throws<MultipleRemoteCallInitializationException>(() => sut.InitializeExclusively(() => true));
        }

        [Fact()]
        public void InitializeExclusivelyTest1()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new IxRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.InitializeExclusively(() => true);

            Assert.True(sut.IsInitialized.GetAsync().Result);

            Assert.Throws<MultipleRemoteCallInitializationException>(() => sut.InitializeExclusively(() => true));
        }

        [Fact()]
        public void DeInitializeTest()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new IxRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.Initialize(() => true);

            sut.DeInitialize();

            Assert.False(sut.IsInitialized.GetAsync().Result);
        }

        [Fact()]
        public async void ResetExecutionTest()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new IxRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");
            sut.GetConnector().BuildAndStart();

            var mustChange = 0;
            sut.Initialize(() => mustChange++);

            await sut.StartSignature.SetAsync(2);
            await sut.DoneSignature.SetAsync(1);

            
            sut.ResetExecution();

            Assert.Equal(0Ul, await sut.StartSignature.GetAsync());
            Assert.Equal(0Ul, await sut.DoneSignature.GetAsync());
            Assert.Equal(string.Empty, await sut.ExceptionMessage.GetAsync());
            Assert.False(sut.IsRunning);
        
        }
    }
}
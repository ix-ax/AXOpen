using System.Security.Principal;
using AXOpen;
using AXOpen.Logging;
using AXSharp.Connector;

namespace AXOpen.Core.Tests
{
    public class AxoRemoteTaskTests
    {
        [Fact()]
        public void InitializeTest()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new AxoRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.Initialize(() => Console.WriteLine(""));

            Assert.True(sut.IsInitialized.GetAsync().Result);

        }

        [Fact()]
        public void InitializeTest1()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new AxoRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.Initialize(() => true);

            Assert.True(sut.IsInitialized.GetAsync().Result);
        }

        [Fact()]
        public void InitializeExclusivelyTest()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new AxoRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.InitializeExclusively(() => Console.WriteLine(""));

            Assert.True(sut.IsInitialized.GetAsync().Result);

            Assert.Throws<MultipleRemoteCallInitializationException>(() => sut.InitializeExclusively(() => true));
        }

        [Fact()]
        public void InitializeExclusivelyTest1()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new AxoRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.InitializeExclusively(() => true);

            Assert.True(sut.IsInitialized.GetAsync().Result);

            Assert.Throws<MultipleRemoteCallInitializationException>(() => sut.InitializeExclusively(() => true));
        }

        [Fact()]
        public void DeInitializeTest()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new AxoRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");

            sut.Initialize(() => true);

            sut.DeInitialize();

            Assert.False(sut.IsInitialized.GetAsync().Result);
        }

        [Fact()]
        public async void ResetExecutionTest()
        {
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            var sut = new AxoRemoteTask(a.GetConnector(null) as ITwinObject, "a", "b");
            sut.GetConnector().BuildAndStart();

            var mustChange = 0;
            sut.Initialize(() => mustChange++);

            await sut.StartSignature.SetAsync(2);
            await sut.DoneSignature.SetAsync(1);

            
            await sut.ResetExecution();

            Assert.Equal(0Ul, await sut.StartSignature.GetAsync());
            Assert.Equal(0Ul, await sut.DoneSignature.GetAsync());
            Assert.Equal(string.Empty, await sut.ErrorDetails.GetAsync());
            Assert.False(await sut.HasRemoteException.GetAsync());
            Assert.False(sut.IsRunning);
        
        }
    }

    public class AxoRemoteTaskTests2
    {
        private readonly AxoRemoteTask _axoTask;
        private readonly IAxoApplication mockAxoApplication;
        private readonly DummyLogger _logger = new DummyLogger();

        public AxoRemoteTaskTests2()
        {
            mockAxoApplication = AxoApplication.CreateBuilder().ConfigureLogger(_logger).Build();
            //_mockAxoApp.Logger.Returns(_logger);
            var a = ConnectorAdapterBuilder.Build().CreateDummy();
            _axoTask = new AxoRemoteTask(a.GetConnector(null), "a", "b");
        }

        [Fact]
        public async void Restore_WhenCalled_SetsRemoteInvokeCyclicToTrue()
        {
            
            var humanReadable = "Test Task";

            _axoTask.HumanReadable = humanReadable;

            await _axoTask.ExecuteAsync();
            Assert.True(await _axoTask.RemoteInvoke.GetAsync());
        }

        [Fact]
        public async void Restore_WhenCalled_SetsRemoteRestoreCyclicToTrue()
        {
            _axoTask.Restore();
            Assert.True(await _axoTask.RemoteRestore.GetAsync());
        }

        [Fact]
        public async void Abort_WhenCalled_SetsRemoteAbortCyclicToTrue()
        {
            _axoTask.Abort();
            Assert.True(await _axoTask.RemoteAbort.GetAsync());
        }

        [Fact]
        public async void ResumeTask_WhenCalled_SetsRemoteResumeCyclicToTrue()
        {
            _axoTask.ResumeTask();
            Assert.True(await _axoTask.RemoteResume.GetAsync());
        }
    }
}
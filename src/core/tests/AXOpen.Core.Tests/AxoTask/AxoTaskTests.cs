using AXOpen;
using AXOpen.Logging;
using AXSharp.Connector;
using NSubstitute;

namespace AXOpen.Core.Tests;

public class AxoTaskTests
{
    private readonly AxoTask _testClass;

    public AxoTaskTests()
    {
        var a = ConnectorAdapterBuilder.Build().CreateDummy();
        _testClass = new AxoTask(a.GetConnector(null), "a", "b");
    }


    [Fact]
    public async Task CanCallExecute()
    {
        // Arrange
        var parameter = new object();

        // Act
        _testClass.ExecuteAsync(parameter);
    }
}

public class AxoTaskTests2
{
    private readonly AxoTask _axoTask;
    private readonly IAxoApplication mockAxoApplication;
    private readonly DummyLogger _logger = new DummyLogger();

    public AxoTaskTests2()
    {
        
        mockAxoApplication = AxoApplication.CreateBuilder().ConfigureLogger(_logger).Build();
        //_mockAxoApp.Logger.Returns(_logger);
        var a = ConnectorAdapterBuilder.Build().CreateDummy();
        _axoTask = new AxoTask(a.GetConnector(null), "a", "b");
    }

    [Fact]
    public async void Execute_WhenCalled_ShouldLogInformationAndInvokeRemoteCommand()
    {
        var humanReadable = "Test Task";

        _axoTask.HumanReadable = humanReadable;

        await _axoTask.ExecuteAsync();

        Assert.Equal("Information", _logger.LastCategory);
        Assert.Equal($"User `NoUser` invoked command `{_axoTask.HumanReadable}`", _logger.LastMessage);
        Assert.Equal(_axoTask, _logger.LastObject);
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



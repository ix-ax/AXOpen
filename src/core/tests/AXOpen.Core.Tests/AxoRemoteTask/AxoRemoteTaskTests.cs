using System.Collections.Concurrent;
using System.Diagnostics;
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

    /// <summary>
    /// A <see cref="DummyConnector"/> that records the <see cref="eAccessPriority"/> passed to
    /// every batch read/write, so a test can assert which priority the handshake used.
    /// Captures into queues because the connector's background RwCycle also calls these methods
    /// (with the default <see cref="eAccessPriority.Normal"/>); membership of the configured value
    /// is the unambiguous signal.
    /// </summary>
    internal sealed class RecordingConnector : DummyConnector
    {
        public readonly ConcurrentQueue<eAccessPriority> ReadPriorities = new();
        public readonly ConcurrentQueue<eAccessPriority> WritePriorities = new();

        public override Task ReadBatchAsync(IEnumerable<ITwinPrimitive> primitives,
            eAccessPriority priority = eAccessPriority.Normal, int chunkSize = 250, int interChunkDelay = 250)
        {
            ReadPriorities.Enqueue(priority);
            return base.ReadBatchAsync(primitives, priority, chunkSize, interChunkDelay);
        }

        public override Task WriteBatchAsync(IEnumerable<ITwinPrimitive> primitives,
            eAccessPriority priority = eAccessPriority.Normal, int chunkSize = 250, int interChunkDelay = 250)
        {
            WritePriorities.Enqueue(priority);
            return base.WriteBatchAsync(primitives, priority, chunkSize, interChunkDelay);
        }
    }

    /// <summary>
    /// Factory that yields a <see cref="RecordingConnector"/> through the normal adapter pipeline,
    /// so the connector's <c>ConnectorAdapter</c> gets wired (a directly-constructed connector would
    /// NRE in the twin's constructor).
    /// </summary>
    internal sealed class RecordingConnectorFactory : DummyConnectorFactory
    {
        public override Connector CreateConnector(object[] parameters) => new RecordingConnector();
    }

    /// <summary>
    /// Exposes the protected start/done handshake (<c>ExecuteAsync(sender, args)</c>) for direct
    /// invocation. We drive the handshake directly rather than via the connector's read cycle: the
    /// <see cref="DummyConnector"/> read cycle (<c>BuildAndStart</c>) self-deadlocks on its internal
    /// lock, so it never raises the value-changed event that would normally fire the handshake.
    /// Invoking directly (without <c>BuildAndStart</c>) keeps the connector lock free so the batched
    /// read/write actually execute and the recording connector can capture their priorities.
    /// </summary>
    internal sealed class TestableAxoRemoteTask : AxoRemoteTask
    {
        public TestableAxoRemoteTask(ITwinObject parent, string readableTail, string symbolTail)
            : base(parent, readableTail, symbolTail) { }

        // sender/args are unused by the handshake body; null! avoids nullable-ref warnings.
        public void InvokeHandshake() => ExecuteAsync(null!, null!);
    }

    public class AxoRemoteTaskHandshakePriorityTests
    {
        private static TestableAxoRemoteTask CreateSut(out RecordingConnector recording)
        {
            // Go through the adapter pipeline so the connector's ConnectorAdapter is wired
            // (a directly-constructed connector would NRE in the twin's constructor).
            var adapter = new ConnectorAdapter(typeof(RecordingConnectorFactory)) { Parameters = new object[] { } };
            recording = (RecordingConnector)adapter.GetConnector(null);
            return new TestableAxoRemoteTask(recording, "a", "b");
        }

        private static async Task<bool> WaitUntilAsync(Func<bool> condition, int timeoutMs)
        {
            var sw = Stopwatch.StartNew();
            while (sw.ElapsedMilliseconds < timeoutMs)
            {
                if (condition()) return true;
                await Task.Delay(20);
            }
            return condition();
        }

        [Fact]
        public async Task Initialize_SetsHandshakeReadPriority_UsedByReadBatch()
        {
            var sut = CreateSut(out var recording);
            sut.Initialize(() => { }, eAccessPriority.UserInterface, eAccessPriority.UserInterface);

            // StartSignature left at 0 so the handshake reads but takes no action branch:
            // a clean, deterministic capture of just the read priority.
            sut.InvokeHandshake();

            var captured = await WaitUntilAsync(
                () => recording.ReadPriorities.Contains(eAccessPriority.UserInterface), 5000);

            Assert.True(captured, "Read handshake (ReadBatchAsync) should use the configured HandshakeReadAccessPriority.");
        }

        [Fact]
        public async Task Initialize_SetsHandshakeWritePriority_UsedByWriteBatch()
        {
            var sut = CreateSut(out var recording);
            // Distinct read (Normal) vs write (UserInterface) so the assertion proves the WRITE
            // property specifically drives the Done-ack write.
            sut.Initialize(() => { }, eAccessPriority.Normal, eAccessPriority.UserInterface);

            // Start != 0 and != Done so the deferred action runs and the Done-ack write fires.
            await sut.StartSignature.SetAsync(2);
            sut.InvokeHandshake();

            var captured = await WaitUntilAsync(
                () => recording.WritePriorities.Contains(eAccessPriority.UserInterface), 8000);

            Assert.True(captured, "Write ack (WriteBatchAsync) should use the configured HandshakeWriteAccessPriority.");
        }

        [Fact]
        public async Task Initialize_WithoutPriorityArgs_DefaultsToNormal_NotHigh()
        {
            var sut = CreateSut(out var recording);
            sut.Initialize(() => { }); // no priority args

            Assert.Equal(eAccessPriority.Normal, sut.HandshakeReadAccessPriority);
            Assert.Equal(eAccessPriority.Normal, sut.HandshakeWriteAccessPriority);

            await sut.StartSignature.SetAsync(2);
            sut.InvokeHandshake();

            // Pins the deliberate behavioral change: the handshake no longer runs at High.
            var readOk = await WaitUntilAsync(() => recording.ReadPriorities.Contains(eAccessPriority.Normal), 5000);
            var writeOk = await WaitUntilAsync(() => recording.WritePriorities.Contains(eAccessPriority.Normal), 8000);
            Assert.True(readOk, "Default read handshake priority should be Normal.");
            Assert.True(writeOk, "Default write handshake priority should be Normal.");
            Assert.DoesNotContain(eAccessPriority.High, recording.ReadPriorities);
            Assert.DoesNotContain(eAccessPriority.High, recording.WritePriorities);
        }

        [Fact]
        public async Task HandshakeReadAccessPriority_SetOnPropertyAfterInitialize_IsHonored()
        {
            var sut = CreateSut(out var recording);
            sut.Initialize(() => { }); // defaults to Normal
            sut.HandshakeReadAccessPriority = eAccessPriority.UserInterface; // retune via property

            sut.InvokeHandshake();

            var captured = await WaitUntilAsync(
                () => recording.ReadPriorities.Contains(eAccessPriority.UserInterface), 5000);

            Assert.True(captured, "Priority set on the property after Initialize should be honored by the handshake.");
        }
    }
}
using AXOpen.Logging;
using Serilog;
using Serilog.Core;
using Serilog.Events;
using Xunit;

namespace AXOpen.Logging.Tests
{
    public class TestLoggerSink : ILogEventSink
    {
        public LogEvent LastEvent { get; private set; }

        public void Emit(LogEvent logEvent)
        {
            LastEvent = logEvent;
        }
    }

    public class SerilogLoggerTests
    {
        private TestLoggerSink _testSink;
        private SerilogLogger logger;

        public SerilogLoggerTests()
        {
            _testSink = new TestLoggerSink();
            var configuration = new LoggerConfiguration()
                .WriteTo.Sink(_testSink)
                .MinimumLevel.Verbose();

            Log.Logger = configuration.CreateLogger();

            logger = new SerilogLogger(Log.Logger);

        }

        [Fact]
        public void Debug_ShouldCallSerilogFatal()
        {
            // Act
            logger.Debug("Test message");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Debug, _testSink.LastEvent.Level);
            Assert.Equal("Test message", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Debug_ShouldCallSerilogFatalWithPayload()
        {
            // Act
            logger.Debug<string>("Test message {PropertyValue}", "data");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Debug, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"data\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Verbose_ShouldCallSerilogVerbose()
        {
            // Act
            logger.Verbose("Test message");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Verbose, _testSink.LastEvent.Level);
            Assert.Equal("Test message", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Verbose_ShouldCallSerilogVerboseWithPayload()
        {
            // Act
            logger.Verbose<string>("Test message {PropertyValue}", "data");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Verbose, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"data\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Information_ShouldCallSerilogInformation()
        {
            // Act
            logger.Information("Test message");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Information, _testSink.LastEvent.Level);
            Assert.Equal("Test message", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Information_ShouldCallSerilogInformationWithPayload()
        {
            // Act
            logger.Information<string>("Test message {PropertyValue}", "data");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Information, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"data\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Warning_ShouldCallSerilogWarning()
        {
            // Act
            logger.Warning("Test message");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Warning, _testSink.LastEvent.Level);
            Assert.Equal("Test message", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Warning_ShouldCallSerilogWarningWithPayload()
        {
            // Act
            logger.Warning<string>("Test message {PropertyValue}", "data");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Warning, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"data\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Error_ShouldCallSerilogError()
        {
            // Act
            logger.Error("Test message");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Error, _testSink.LastEvent.Level);
            Assert.Equal("Test message", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Error_ShouldCallSerilogErrorWithPayload()
        {
            // Act
            logger.Error<string>("Test message {PropertyValue}", "data");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Error, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"data\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Fatal_ShouldCallSerilogFatal()
        {
            // Act
            logger.Fatal("Test message");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Fatal, _testSink.LastEvent.Level);
            Assert.Equal("Test message", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Fatal_ShouldCallSerilogFatalWithPayload()
        {
            // Act
            logger.Fatal<string>("Test message {PropertyValue}", "data");

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Fatal, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"data\"", _testSink.LastEvent.RenderMessage());
        }
    }
}
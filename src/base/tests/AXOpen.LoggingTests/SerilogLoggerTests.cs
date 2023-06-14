using System.Security.Principal;
using AXOpen.Logging;
using AXSharp.Connector;
using NSubstitute;
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
        private ITwinElement _sender;


        public SerilogLoggerTests()
        {
            _testSink = new TestLoggerSink();
            var configuration = new LoggerConfiguration()
                .WriteTo.Sink(_testSink)
                .MinimumLevel.Verbose();

            Log.Logger = configuration.CreateLogger();

            logger = new SerilogLogger(Log.Logger);
            _sender = NSubstitute.Substitute.For<ITwinElement>();
            _sender.HumanReadable.Returns("label");
            _sender.Symbol.Returns("symbalein");
        }

        [Fact]
        public void Debug_ShouldCallSerilogFatal()
        {
            // Act
            logger.Debug("Test message", new GenericIdentity("NoUser"));

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Debug, _testSink.LastEvent.Level);
            Assert.Equal("\"Test message\" \"{ UserName = NoUser }\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Debug_ShouldCallSerilogFatalWithPayload()
        {
            // Act
            logger.Debug("Test message {PropertyValue}", _sender, new GenericIdentity("NoUser"), new { });

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Debug, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"{ Symbol = symbalein, Label = label }\" \"{ UserName = NoUser, Type =  }\" \"{ }\" {details}", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Verbose_ShouldCallSerilogVerbose()
        {
            // Act
            logger.Verbose("Test message", new GenericIdentity("NoUser"));

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Verbose, _testSink.LastEvent.Level);
            Assert.Equal("\"Test message\" \"{ UserName = NoUser }\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Verbose_ShouldCallSerilogVerboseWithPayload()
        {
            // Act
            logger.Verbose("Test message {PropertyValue}", _sender, new GenericIdentity("NoUser"), new { });

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Verbose, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"{ Symbol = symbalein, Label = label }\" \"{ UserName = NoUser, Type =  }\" \"{ }\" {details}", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Information_ShouldCallSerilogInformation()
        {
            // Act
            logger.Information("Test message", new GenericIdentity("NoUser"));

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Information, _testSink.LastEvent.Level);
            Assert.Equal("\"Test message\" \"{ UserName = NoUser }\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Information_ShouldCallSerilogInformationWithPayload()
        {
            // Act
            logger.Information("Test message {PropertyValue}", _sender, new GenericIdentity("NoUser"), new { });

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Information, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"{ Symbol = symbalein, Label = label }\" \"{ UserName = NoUser, Type =  }\" \"{ }\" {details}", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Warning_ShouldCallSerilogWarning()
        {
            // Act
            logger.Warning("Test message", new GenericIdentity("NoUser"));

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Warning, _testSink.LastEvent.Level);
            Assert.Equal("\"Test message\" \"{ UserName = NoUser }\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Warning_ShouldCallSerilogWarningWithPayload()
        {
            // Act
            logger.Warning("Test message {PropertyValue}", _sender, new GenericIdentity("NoUser"), new {});

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Warning, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"{ Symbol = symbalein, Label = label }\" \"{ UserName = NoUser, Type =  }\" \"{ }\" {details}", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Error_ShouldCallSerilogError()
        {
            // Act
            logger.Error("Test message", new GenericIdentity("NoUser"));

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Error, _testSink.LastEvent.Level);
            Assert.Equal("\"Test message\" \"{ UserName = NoUser }\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Error_ShouldCallSerilogErrorWithPayload()
        {
            // Act
            logger.Error("Test message {PropertyValue}", _sender, new GenericIdentity("NoUser"), new { });

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Error, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"{ Symbol = symbalein, Label = label }\" \"{ UserName = NoUser, Type =  }\" \"{ }\" {details}", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Fatal_ShouldCallSerilogFatal()
        {
            // Act
            logger.Fatal("Test message", new GenericIdentity("NoUser"));

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Fatal, _testSink.LastEvent.Level);
            Assert.Equal("\"Test message\" \"{ UserName = NoUser }\"", _testSink.LastEvent.RenderMessage());
        }

        [Fact]
        public void Fatal_ShouldCallSerilogFatalWithPayload()
        {
            // Act
            logger.Fatal("Test message {PropertyValue}", _sender, new GenericIdentity("NoUser"), new { });

            // Assert
            Assert.NotNull(_testSink.LastEvent);
            Assert.Equal(LogEventLevel.Fatal, _testSink.LastEvent.Level);
            Assert.Equal("Test message \"{ Symbol = symbalein, Label = label }\" \"{ UserName = NoUser, Type =  }\" \"{ }\" {details}", _testSink.LastEvent.RenderMessage());
        }
    }
}
using AXOpen.Logging;

namespace AXOpen
{
    /// <summary>
    /// Provides application services and configuration builder for an AxoApplication.
    /// </summary>
    public class AxoApplication : IAxoApplication, IAxoApplicationBuilder
    {
        private static AxoApplication _current { get; } = new AxoApplication();

        private AxoApplication()
        {
            
        }
        
        /// <inheritdoc/>
        public ILogger Logger { get; private set; } = new DummyLogger();

        public static IAxoApplicationBuilder CreateBuilder()
        {
            return _current;
        }

        /// <inheritdoc/>
        public IAxoApplicationBuilder ConfigureLogger(ILogger logger)
        {
            Logger = logger;
            return this;
        }

        /// <inheritdoc/>
        public IAxoApplication Build()
        {
            return this;
        }

        /// <summary>
        /// Get currently running application.
        /// </summary>
        public static IAxoApplication Current => _current;
    }
}

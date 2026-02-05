using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Logging;
using AXSharp.Connector;

namespace AXOpen
{

    public class SystemDiagnostics
    {
        private IList<ITwinPrimitive> DiagnosticsFlags { get; } = new List<ITwinPrimitive>();
        
        public void AddDiagnosticsFlag(ITwinPrimitive diagnosticsFlag)
        {
            DiagnosticsFlags.Add(diagnosticsFlag);
        }
        
        public string DiagMessages { get; private set; }

        public async Task<string> RunDiagnostics()
        {
            var diagIdentity = new GenericIdentity("Diagnostics");
            var diags = new StringBuilder();
            AxoApplication.Current.Logger.Information($"System diagnostics requested.", diagIdentity);
            await DiagnosticsFlags.FirstOrDefault()?.GetParent()?.GetConnector().ReadBatchAsync(DiagnosticsFlags)!;
            foreach (dynamic flag in DiagnosticsFlags)
            {
                if (flag.LastValue > 0)
                {
                    diags.AppendLine($"{flag.Symbol} is in error state code '{flag.LastValue}'.");
                    AxoApplication.Current.Logger.Fatal($"{flag.Symbol} is in error state code '{flag.LastValue}'.", diagIdentity);
                }
            }
            AxoApplication.Current.Logger.Information($"System diagnostics done.", diagIdentity);
            DiagMessages = diags.ToString();
            return DiagMessages;
        }
    }
    
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

        public IIdentity ControllerIdentity { get; } = new ControllerIdentity();
        
        public SystemDiagnostics SystemDiagnostics { get; } = new SystemDiagnostics();
    }
}

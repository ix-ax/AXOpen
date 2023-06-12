using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Messaging.Static;
using AXSharp.Connector;

namespace AXOpen.Logging
{
    public partial class AxoLogger
    {

        private ILogger _logger;

        public void StartDequeuing(ILogger targetLogger, int dequeuingInterval = 100)
        {
            _logger = targetLogger;
            Task.Run(async () =>
            {
                while (true)
                {
                    await Task.Delay(dequeuingInterval);
                    await Dequeue();
                }
            });
        }

        public void SetLogger(ILogger targetLogger) { _logger = targetLogger; }

        public async Task Dequeue()
        {
            await Task.Run(async () =>
            {
                await this.ReadAsync();

                foreach (var entry in this.LogEntries.Where(p => p.ToDequeue.LastValue))
                {
                    var sender = entry.GetConnector().IdentityProvider.GetTwinByIdentity(entry.Sender.LastValue) as ITwinObject;
                    var message = string.Empty;
                    var level = (eLogLevel)entry.Level.LastValue;
                    switch (sender)
                    {
                        case AxoMessenger messenger:
                            message = $"{entry.Message.LastValue} : {messenger.MessageText}";
                            break;
                        default:
                            message = entry.Message.LastValue;
                            break;
                    }

                    CreateLogEntry(level, message, sender);

                    await entry.ToDequeue.SetAsync(false);
                }
            });
        }

        private void CreateLogEntry(eLogLevel level, string message, ITwinObject? sender)
        {
            switch (level)
            {
                case eLogLevel.Verbose:
                    _logger.Verbose($"{message}", sender, new GenericIdentity("Controller"));
                    break;
                case eLogLevel.Debug:
                    _logger.Debug($"{message}", sender, new GenericIdentity("Controller"));
                    break;
                case eLogLevel.Information:
                    _logger.Information($"{message}", sender, new GenericIdentity("Controller"));
                    break;
                case eLogLevel.Warning:
                    _logger.Warning($"{message}", sender, new GenericIdentity("Controller"));
                    break;
                case eLogLevel.Error:
                    _logger.Error($"{message}", sender, new GenericIdentity("Controller"));
                    break;
                case eLogLevel.Fatal:
                    _logger.Fatal($"{message}", sender, new GenericIdentity("Controller"));
                    break;
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
                    var sender = entry.GetConnector().IdentityProvider.GetTwinByIdentity(entry.Sender.LastValue);
                    var senderSymbol = string.Empty; //sender?.Symbol; //TODO: Implement when ready with Identities.
                    switch ((eLogLevel)entry.Level.LastValue)
                    {
                        case eLogLevel.Verbose:
                            _logger.Verbose($"{entry.Message.LastValue} : {senderSymbol}", sender);
                            break;
                        case eLogLevel.Debug:
                            _logger.Debug($"{entry.Message.LastValue} : {senderSymbol}", sender);
                            break;
                        case eLogLevel.Information:
                            _logger.Information($"{entry.Message.LastValue} : {senderSymbol}", sender);
                            break;
                        case eLogLevel.Warning:
                            _logger.Warning($"{entry.Message.LastValue} : {senderSymbol}", sender);
                            break;
                        case eLogLevel.Error:
                            _logger.Error($"{entry.Message.LastValue} : {senderSymbol}", sender);
                            break;
                        case eLogLevel.Fatal:
                            _logger.Fatal($"{entry.Message.LastValue} : {senderSymbol}", sender);
                            break;
                    }

                    await entry.ToDequeue.SetAsync(false);
                }
            });
        }
    }
}

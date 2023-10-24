using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Core;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using Serilog;

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
                var dequeued = new List<OnlinerBool>();
                var index = 0;
                var caretValue = await this.Carret.GetAsync();
                var toDequeue = this.LogEntries.Take(caretValue).ToArray();

                if (toDequeue.Length <= 0)
                    return;

                await this.GetConnector()?.ReadBatchAsync(toDequeue.SelectMany(p => p.GetValueTags()))!;

                foreach (var entry in toDequeue.Where(p => p.ToDequeue.LastValue))
                {
                    var sender = entry.GetConnector().IdentityProvider.GetTwinByIdentity(entry.Sender.LastValue) as ITwinObject;
                    var message = string.Empty;
                    var level = (eLogLevel)entry.Level.LastValue;

                    switch (sender)
                    {
                        case AxoMessenger messenger:
                            message = $"{entry.Message.LastValue} : {messenger.MessageText}";
                            break;
                        case AxoStep step:
                            message = $"{entry.Message.LastValue} : {step.StepDescription.LastValue ?? step.Description}";
                            break;
                        case null:
                            message = $"{entry.Message.LastValue} : [no identity provided '{entry.Sender.LastValue}']";
                            break;
                        default:
                            message = entry.Message.LastValue;
                            break;
                    }

                    CreateLogEntry(level, $"{message}", sender);
                    dequeued.Add(entry.ToDequeue);                    
                    entry.ToDequeue.Cyclic = false;
                }

                this.LogEntries.FirstOrDefault()?.GetConnector().WriteBatchAsync(dequeued);
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

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
                try
                {
                    var dequeued = new List<OnlinerBool>();
                    var index = 0;
                    var caretValue = await this.Carret.GetAsync();
                    var toDequeue = this.LogEntries.Take(caretValue).ToArray();

                    if (toDequeue.Length <= 0)
                        return;

                    var a = toDequeue.SelectMany(p => p.GetValueTags()).ToArray();
                    await this.GetConnector()?.ReadBatchAsync(a, eAccessPriority.Low)!;

                    foreach (var entry in toDequeue.Where(p => p.ToDequeue.LastValue))
                    {
                        var senderIdentity = entry.Sender.LastValue;
                        var sender = entry.GetConnector().IdentityProvider.GetTwinByIdentity(senderIdentity) as ITwinObject;
                        var message = string.Empty;
                        var level = (eLogLevel)entry.Level.LastValue;

                        switch (sender)
                        {
                            case AxoMessenger messenger:
                                await messenger.ReadAsync();
                                message = $"{entry.Message.LastValue} : {messenger.GetMessageText()}";
                                break;
                            case AxoStep step:
                                await step.ReadAsync();
                                message = $"Step : {entry.Message.LastValue} : {step.StepDescription.LastValue ?? step.Description}";
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

                    await this.GetConnector().WriteBatchAsync(dequeued);
                    }
                    catch (Exception e)
                    {
                        AxoApplication.Current.Logger.Information($"There was in issue with getting logs from `{this.Carret.Symbol}`", this, new GenericIdentity("anonymous"), this);
                    }
               
            });
        }

        private void CreateLogEntry(eLogLevel level, string message, ITwinObject? sender)
        {
            var controllerIdentity = AxoApplication.Current.ControllerIdentity;
            switch (level)
            {
                case eLogLevel.Verbose:
                    _logger.Verbose($"{message}", sender, controllerIdentity, sender);
                    break;
                case eLogLevel.Debug:
                    _logger.Debug($"{message}", sender, controllerIdentity, sender);
                    break;
                case eLogLevel.Information:
                    _logger.Information($"{message}", sender, controllerIdentity, sender);
                    break;
                case eLogLevel.Warning:
                    _logger.Warning($"{message}", sender, controllerIdentity, sender);
                    break;
                case eLogLevel.Error:
                    _logger.Error($"{message}", sender, controllerIdentity, sender);
                    break;
                case eLogLevel.Fatal:
                    _logger.Fatal($"{message}", sender, controllerIdentity, sender);
                    break;
            }
        }
    }
}

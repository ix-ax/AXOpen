using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector;

namespace AXOpen.Messaging
{
    public partial class AxoLogger
    {
        public void StartDequeuing(int dequeuingInterval = 100)
        {
            Task.Run(async () =>
            {
                while (true)
                {
                    await Task.Delay(dequeuingInterval);
                    await Dequeue();
                }

            });
        }

        public async Task Dequeue()
        {
            await Task.Run(async () =>
            {
                await this.ReadAsync();

                foreach (var entry in this.LogEntries.Where(p => p.ToDequeue.LastValue))
                {
                    var sender = entry.GetConnector().IdentityProvider.GetTwinByIdentity(entry.Sender.LastValue);
                    switch ((eLogLevel)entry.Level.LastValue)
                    {
                        case eLogLevel.Verbose:
                            AxoApplication.Current.Logger.Verbose(entry.Message.LastValue, sender);
                            break;
                        case eLogLevel.Debug:
                            AxoApplication.Current.Logger.Debug(entry.Message.LastValue, sender);
                            break;
                        case eLogLevel.Information:
                            AxoApplication.Current.Logger.Information(entry.Message.LastValue, sender);
                            break;
                        case eLogLevel.Warning:
                            AxoApplication.Current.Logger.Warning(entry.Message.LastValue, sender);
                            break;
                        case eLogLevel.Error:
                            AxoApplication.Current.Logger.Error(entry.Message.LastValue, sender);
                            break;
                        case eLogLevel.Fatal:
                            AxoApplication.Current.Logger.Fatal(entry.Message.LastValue, sender);
                            break;
                        default:
                            AxoApplication.Current.Logger.Fatal(entry.Message.LastValue, sender);
                            break;
                    }

                    await entry.ToDequeue.SetAsync(false);
                }
            });
        }
    }
}

using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    ///  Container for multiple AxoDialogProxyService types, based on multiple different dialogues instances and opened web clients.
    /// </summary>
    public class AxoDialogContainer : IAsyncDisposable
    {

        /// <summary>
        /// SingalRClient it is used for sending dignal to the server from dialogs -> especialy for closing dialogs
        /// </summary>
        /// 
        private SignalRDialogClient _singalRDialogClient;
        public SignalRDialogClient SingalRDialogClient
        {
            get
            {
                return _singalRDialogClient;
            }
        }

        //public HashSet<string> ObservedObjects { get; set; } = new HashSet<string>();
        public HashSet<string> ObservedObjectsAlerts { get; set; } = new HashSet<string>();

        /// <summary>
        /// DialogLocator has only one proxy service.   
        /// </summary>
        public Dictionary<string, AxoDialogProxyService> DialogProxyServicesDictionary { get; set; } = new Dictionary<string, AxoDialogProxyService>();
        public Dictionary<string, AxoAlertDialogProxyService> AlertDialogProxyServicesDictionary { get; set; } = new Dictionary<string, AxoAlertDialogProxyService>();

        public Task InitializeSignalR(string uri)
        {
            if (_singalRDialogClient == null)
            {
                _singalRDialogClient = new SignalRDialogClient(uri);
            }

            return SingalRDialogClient.StartAsync();
        }

        public Task SendToAllClients_CloseDialog(string dialogInstanceSymbol)
        {
            return SingalRDialogClient.SendToAllClients_CloseDialog(dialogInstanceSymbol);
        }

        public async ValueTask DisposeAsync()
        {
            if (SingalRDialogClient != null)
            {
                await SingalRDialogClient.StopAsync();
            }
        }
    }
}

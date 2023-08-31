using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    ///  Container for multiple AxoDialogProxyService types, based on multiple different dialogues instances and opened web clients.
    /// </summary>
    public class AxoDialogContainer: IAsyncDisposable
    {

        public DialogClient DialogClient { get; set; }
        public AxoDialogContainer()
        {
          
        }

        public void InitializeSignalR(string uri)
        {
            DialogClient = new DialogClient(uri);
        }
        public HashSet<string> ObservedObjects { get; set; } = new HashSet<string>();
        public HashSet<string> ObservedObjectsAlerts { get; set; } = new HashSet<string>();
        public Dictionary<string, AxoDialogProxyService> DialogProxyServicesDictionary { get; set; } = new Dictionary<string,AxoDialogProxyService>();
        public Dictionary<string, AxoAlertDialogProxyService> AlertDialogProxyServicesDictionary { get; set; } = new Dictionary<string, AxoAlertDialogProxyService>();
        public async ValueTask DisposeAsync()
        {
            if (DialogClient != null)
            {
                await DialogClient.StopAsync();
            }
        }
    }
}

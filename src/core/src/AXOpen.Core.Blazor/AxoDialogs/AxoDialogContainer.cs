using AXOpen.Base.Abstractions.Dialogs;
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

        public bool InitializeSignalR(string uri)
        {
            if (DialogClient == null)
            {
                DialogClient = new DialogClient(uri);
                return true;
            }
            return false;
           
        }
        public List<string> ObservedObjects { get; set; } = new List<string>();

        public List<AxoDialogProxyService> DialogProxyServices { get; set; } = new List<AxoDialogProxyService>();

        public Dictionary<string,AxoDialogProxyService> DialogProxyServicesDictionary { get; set; } = new Dictionary<string,AxoDialogProxyService>();
        public async ValueTask DisposeAsync()
        {
            if (DialogClient != null)
            {
                await DialogClient.StopAsync();
            }
        }
    }
}

using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public class AxoDialogContainer: IAsyncDisposable
    {

        public DialogClient DialogClient { get; set; }
        public AxoDialogContainer()
        {
          
        }

        public async Task InitializeSignalR(string uri)
        {
            if (DialogClient == null)
            {
                DialogClient = new DialogClient(uri);
                await DialogClient.StartAsync();
            }
        }
        public List<string> ObservedObjects { get; set; } = new List<string>();

        public List<AxoDialogProxyService> DialogProxyServices { get; set; } = new List<AxoDialogProxyService>();
        public async ValueTask DisposeAsync()
        {
            //_dialogService.DialogInvoked -= OnDialogInvoked;
            if (DialogClient != null)
            {
                await DialogClient.StopAsync();
            }
        }
    }
}

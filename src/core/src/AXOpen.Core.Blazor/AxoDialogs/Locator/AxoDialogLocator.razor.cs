using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public partial class AxoDialogLocator : ComponentBase, IDisposable
    {
        private AxoDialogProxyService _dialogProxyService { get; set; }

        [Inject]
        public AxoDialogContainer DialogContainer { get; set; }

        [Inject]
        public NavigationManager NavigationManager { get; set; }

        public SignalRDialogClient SingalRClient { get; set; }

        /// <summary>
        /// List of objects, which are observed for dialogs.
        /// Example: ObservedObjects="new[] {Entry.Plc.Context.CU0, Entry.Plc.Context.CU1}"
        /// </summary>
        [Parameter, EditorRequired]
        public IEnumerable<ITwinObject> ObservedObjects { get; set; }

        /// <summary>
        /// Unique ID of dialog locator, which is used to synchronize dialogs across clients. Make sure you pass unique value, otherwise inconsistencies may occur.
        /// When no value provided, URI is used as a ID. 
        /// </summary>
        [Parameter, EditorRequired]
        public string DialogLocatorId { get; set; }

        /// <summary>
        /// The opening dialog delay (default value is 0 ms).
        /// </summary>
        [Parameter]
        public int DialogOpenDelay { get; set; } = 0;

        public bool IsAnyDialogActive { get; set; } = false;

        public Task InitializeSignalR(string uri)
        {
            if (SingalRClient == null)
            {
                SingalRClient = new SignalRDialogClient(uri);
            }

            return SingalRClient.StartAsync();
        }


        protected override async Task OnInitializedAsync()
        {
            // create signalR client and start it
            await InitializeSignalR(NavigationManager.BaseUri);

            //if dialog id is null, set it to actual URI
            if (string.IsNullOrEmpty(DialogLocatorId)) DialogLocatorId = NavigationManager.Uri;

            //try to acquire existing dialog service instance
            var proxyExists = DialogContainer.DialogProxyServicesDictionary.TryGetValue(DialogLocatorId, out AxoDialogProxyService proxy);

            if (!proxyExists)
            {
                // if it does not exist, create new instance with observed objects and add it into container
                this._dialogProxyService = new AxoDialogProxyService(DialogLocatorId, DialogContainer, ObservedObjects); 
            }
            else
            {
                this._dialogProxyService = proxy;
                this._dialogProxyService.StartObservingObjectsForDialogues(); // needs to be reinitialized
            }

            this._dialogProxyService.EventFromPlc_DialogInvoked += OnPlc_DialogInvoked; // 
            this._dialogProxyService.EventFromPlc_DialogRemoved += OnPlc_DialogRemoved; // 


            this.SingalRClient.EventDialogOpen += OnSignalRClient_DialogOpen;
            this.SingalRClient.EventDialogClose += OnSignalRClient_DialogClose;

        }

        private void OnSignalRClient_DialogOpen(object sender, SignalRClientReceivedMessageArgs e)
        {
            ; // swallow -> it must be opened from plc
            // fix way when multiple locator are observing 1 instance..
        }

        private void OnSignalRClient_DialogClose(object sender, SignalRClientReceivedMessageArgs e)
        {
            _dialogProxyService.RemoveDisplayedDialog(e.SymbolOfDialogInstance);

            this.StateHasChanged();// rerender
        }

        private async void OnPlc_DialogInvoked(object? sender, AxoDialogEventArgs e)
        {
            if (DialogOpenDelay > 0)
            {
                await Task.Delay(DialogOpenDelay);
            }
            
            await InvokeAsync(StateHasChanged);
        }

        private async void OnPlc_DialogRemoved(object? sender, AxoDialogEventArgs e)
        {
            await InvokeAsync(StateHasChanged);
        }

        /// <summary>
        /// Releases communication and event resources when disposed.
        /// </summary>
        public async void Dispose()
        {
            if (_dialogProxyService != null)
            {
                _dialogProxyService.EventFromPlc_DialogInvoked -= OnPlc_DialogInvoked; // unsubscribe current view 
                _dialogProxyService.EventFromPlc_DialogRemoved -= OnPlc_DialogRemoved; // 
                _dialogProxyService.Dispose(); 
            }

            this.SingalRClient.EventDialogOpen -= OnSignalRClient_DialogOpen;
            this.SingalRClient.EventDialogClose -= OnSignalRClient_DialogClose;
            await this.SingalRClient.StopAsync();
        }
    }
}

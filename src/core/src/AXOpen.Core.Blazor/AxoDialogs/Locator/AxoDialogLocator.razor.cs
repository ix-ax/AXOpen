using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Serilog;
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
        
        public string ModalDisplay { set; get; } = "none;";
        public string ModalClass { set; get; } = string.Empty;
        public bool ShowBackdrop { set; get; } = false;

        [Inject]
        public AxoDialogContainer DialogContainer { get; set; }

        [Inject]
        public NavigationManager NavigationManager { get; set; }

        public SignalRDialogClient SignalRClient { get; set; }

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

        public Guid InstanceGuid { get; private set; } = new Guid();


        /// <summary>
        /// The opening dialog delay (default value is 0 ms).
        /// </summary>
        [Parameter]
        public int DialogOpenDelay { get; set; } = 0;

        public bool IsAnyDialogActive { get; set; } = false;

        public Task InitializeSignalR(string uri)
        {
            if (SignalRClient == null)
            {
                SignalRClient = new SignalRDialogClient(uri);
            }

            return SignalRClient.StartAsync();
        }

        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                await InitializedDialogHandling();
            }
        }

        protected async Task InitializedDialogHandling()
        {
            var uri = NavigationManager.BaseUri;

            // create local signalR client and start it for local container
            await this.InitializeSignalR(uri);

            // start signalR client and start it for global container
            await DialogContainer.InitializeSignalR(uri);

            //if dialog id is null, set it to actual URI
            if (string.IsNullOrEmpty(DialogLocatorId)) DialogLocatorId = uri;


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
                this._dialogProxyService.StartObservingDialogues(); // needs to be reinitialized
            }

            this._dialogProxyService.EventFromPlc_DialogInvoked += OnPlc_DialogInvoked; // 
            this._dialogProxyService.EventFromPlc_DialogRemoved += OnPlc_DialogRemoved; // 


            this.SignalRClient.EventDialogOpen += OnSignalRClient_DialogOpen;
            this.SignalRClient.EventDialogClose += OnSignalRClient_DialogClose;

            if (this._dialogProxyService.DisplayedDialogs.Count() > 0)
                this.Refresh();

        }

        private async void OnSignalRClient_DialogOpen(object sender, SignalRClientReceivedMessageArgs e)
        {
            Log.Logger.Information($"Locator -> SignalR | Open -  {e.SymbolOfDialogInstance}");

            ; // swallow -> it must be opened from plc
            // fix way when multiple locator are observing 1 instance..
        }

        private async void OnSignalRClient_DialogClose(object sender, SignalRClientReceivedMessageArgs e)
        {
            Log.Logger.Information($"Locator -> SignalR | Close -  {e.SymbolOfDialogInstance}");

            _dialogProxyService.RemoveDisplayedDialog(e.SymbolOfDialogInstance);

            await Refresh(); // rerender
        }

        private async void OnPlc_DialogInvoked(object? sender, AxoDialogEventArgs e)
        {
            Log.Logger.Information($"Locator -> PLC | Open -  {e.SymbolOfDialogInstance}");

            if (DialogOpenDelay > 0)
            {
                await Task.Delay(DialogOpenDelay);
            }

            await Refresh();
        }

        private async void OnPlc_DialogRemoved(object? sender, AxoDialogEventArgs e)
        {
            Log.Logger.Information($"Locator -> PLC | Close -  {e.SymbolOfDialogInstance}");

            await Refresh();
        }


        protected Task Refresh()
        {
            if (_dialogProxyService.DisplayedDialogs.Count() > 0)
            {
                this.Open();
            }
            else
                this.Close();

            return this.InvokeAsync(StateHasChanged);
        }

        protected void Open()
        {
            ModalDisplay = "flex";
            ModalClass = "show";
            ShowBackdrop = true;
        }
        protected void Close()
        {
            ModalDisplay = "none";
            ModalClass = string.Empty;
            ShowBackdrop = false;
        }

        /// <summary>
        /// Releases communication and event resources when disposed.
        /// </summary>
        public void Dispose()
        {
            if (_dialogProxyService != null)
            {
                _dialogProxyService.EventFromPlc_DialogInvoked -= OnPlc_DialogInvoked; // unsubscribe current view 
                _dialogProxyService.EventFromPlc_DialogRemoved -= OnPlc_DialogRemoved; // 
                _dialogProxyService.Dispose();
            }

            if (this.SignalRClient != null)
            {
                this.SignalRClient.EventDialogOpen -= OnSignalRClient_DialogOpen;
                this.SignalRClient.EventDialogClose -= OnSignalRClient_DialogClose;
                this.SignalRClient.StopAsync();
            }
        }
    }
}

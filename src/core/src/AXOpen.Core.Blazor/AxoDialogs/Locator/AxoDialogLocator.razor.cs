using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.Extensions.Localization;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Represents a component responsible for locating and managing dialogues within a Blazor application.
    /// It subscribes to dialog events and manages their display state.
    /// </summary>
    public partial class AxoDialogLocator : ComponentBase, IDisposable
    {
        private AxoDialogLocatorService _dialogProxyService { get; set; }

        /// <summary>
        /// Controls the CSS display property of the modal dialog. Defaults to "none".
        /// </summary>
        public string ModalDisplay { set; get; } = "none;";

        /// <summary>
        /// Controls the CSS class of the modal dialog. Used to toggle visibility.
        /// </summary>
        public string ModalClass { set; get; } = string.Empty;

        /// <summary>
        /// Indicates whether the modal backdrop is shown.
        /// </summary>
        public bool ShowBackdrop { set; get; } = false;

        [Inject]
        public AxoDialogContainer DialogContainer { get; set; }

        [Inject]
        public NavigationManager NavigationManager { get; set; }

        [Inject]
        public AuthenticationStateProvider Authentification { get; set; }

        /// <summary>
        /// The SignalR client for managing real-time dialogue events.
        /// </summary>
        public SignalRDialogClient SignalRClient { get; set; }

        /// <summary>
        /// The objects to observe for dialogues. These are typically data models or application state objects that can initiate dialogues.
        /// </summary>
        [Parameter, EditorRequired]
        public IEnumerable<ITwinObject> ObservedObjects { get; set; }

        /// <summary>
        /// A unique identifier for the dialog locator, typically based on the URL of the page.
        /// This ensures dialogues are synchronized across different instances.
        /// </summary>
        [Parameter, EditorRequired]
        public string DialogLocatorPath { get; set; }

        [Parameter]
        public bool DisplayInModalWindow { get; set; } = true;

        /// <summary>
        /// A unique GUID for the dialog locator instance, used for internal management and event subscription.
        /// </summary>
        public Guid DialogLocatorGuid { get; private set; } = Guid.NewGuid();

        /// <summary>
        /// Optional delay in milliseconds before opening a dialog, with a default value of 0ms.
        /// </summary>
        [Parameter]
        public int DialogOpenDelay { get; set; } = 0;

        /// <summary>
        /// Flag indicating if any dialog is currently active.
        /// </summary>
        public bool IsAnyDialogActive { get; set; } = false;

        /// <summary>
        /// Initializes the SignalR client for dialog communication.
        /// </summary>
        /// <param name="uri">The URI for the SignalR hub connection.</param>
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

        /// <summary>
        /// Initializes dialog handling by setting up SignalR clients and subscribing to dialog events.
        /// </summary>
        protected async Task InitializedDialogHandling()
        {
            var uri = NavigationManager.BaseUri;
            await InitializeSignalR(uri);
            await DialogContainer.InitializeSignalR(uri);

            if (string.IsNullOrEmpty(DialogLocatorPath)) DialogLocatorPath = uri;

            var proxyExists = DialogContainer.DialogLocatorServicesDictionary.TryGetValue(DialogLocatorPath, out AxoDialogLocatorService proxy);

            if (!proxyExists)
            {
                this._dialogProxyService = new AxoDialogLocatorService(DialogLocatorPath, DialogLocatorGuid, DialogContainer, ObservedObjects);
            }
            else
            {
                this._dialogProxyService = proxy;
                this._dialogProxyService.StartObservingDialogues(DialogLocatorGuid);
            }

            this._dialogProxyService.EventFromPlc_DialogInvoked += OnPlc_DialogInvoked;
            this._dialogProxyService.EventFromPlc_DialogRemoved += OnPlc_DialogRemoved;

            this.SignalRClient.EventDialogOpen += OnSignalRClient_DialogOpen;
            this.SignalRClient.EventDialogClose += OnSignalRClient_DialogClose;

            if (this._dialogProxyService.DisplayedDialogs.Count() > 0)
                this.Refresh();
        }

        private async void OnSignalRClient_DialogOpen(object sender, SignalRClientReceivedMessageArgs e)
        {
            Log.Logger.Information($"Locator -> SignalR | Open -  {e.SymbolOfDialogInstance}");
            _dialogProxyService.RemoveDisplayedDialog(e.SymbolOfDialogInstance);
            await Refresh();
        }

        private async void OnSignalRClient_DialogClose(object sender, SignalRClientReceivedMessageArgs e)
        {
            Log.Logger.Information($"Locator -> SignalR | Close -  {e.SymbolOfDialogInstance}");
            await Refresh();
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

        /// <summary>
        /// Refreshes the UI state based on active dialogs.
        /// </summary>
        protected Task Refresh()
        {
            if (_dialogProxyService.DisplayedDialogs.Count() > 0)
            {
                Open();
            }
            else
            {
                Close();
            }

            return InvokeAsync(StateHasChanged);
        }

        /// <summary>
        /// Opens the dialog UI elements.
        /// </summary>
        protected void Open()
        {
            ModalDisplay = "flex";
            ModalClass = "show";
            ShowBackdrop = true;
        }

        /// <summary>
        /// Closes the dialog UI elements.
        /// </summary>
        protected void Close()
        {
            ModalDisplay = "none";
            ModalClass = string.Empty;
            ShowBackdrop = false;
        }

        /// <summary>
        /// Cleans up resources and unsubscribes from events on disposal.
        /// </summary>
        public void Dispose()
        {
            if (_dialogProxyService != null)
            {
                _dialogProxyService.EventFromPlc_DialogInvoked -= OnPlc_DialogInvoked;
                _dialogProxyService.EventFromPlc_DialogRemoved -= OnPlc_DialogRemoved;
                _dialogProxyService.TryDispose(DialogLocatorGuid);
            }

            if (SignalRClient != null)
            {
                SignalRClient.EventDialogOpen -= OnSignalRClient_DialogOpen;
                SignalRClient.EventDialogClose -= OnSignalRClient_DialogClose;
                SignalRClient.StopAsync();
            }
        }
    }
}

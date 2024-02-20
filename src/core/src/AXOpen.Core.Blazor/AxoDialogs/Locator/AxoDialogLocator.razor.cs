using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Core.Blazor.Dialogs;
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
    public partial class AxoDialogLocator : AxoLocator
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
       

        /// <summary>
        /// The SignalR client for managing real-time dialogue events.
        /// </summary>
        public SignalRDialogClient SignalRClient { get; set; }

        
        [Parameter]
        public bool DisplayInModalWindow { get; set; } = true;

       
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

        /// <summary>
        /// Initializes dialog handling by setting up SignalR clients and subscribing to dialog events.
        /// </summary>
        protected override async Task InitializeObservationHandling()
        {
            var uri = NavigationManager.BaseUri;

            await InitializeSignalR(uri);
            await DialogContainer.InitializeSignalR(uri);

            if (string.IsNullOrEmpty(LocatorPath)) LocatorPath = uri;

            var proxyExists = DialogContainer.DialogLocatorServicesDictionary.TryGetValue(LocatorPath, out AxoDialogLocatorService proxy);

            if (!proxyExists)
            {
                this._dialogProxyService = new AxoDialogLocatorService(LocatorPath, DialogContainer, ObservedObjects);
            }
            else
            {
                this._dialogProxyService = proxy;
            }
                   
            this._dialogProxyService!.StartObservingDialogues(LocatorGuid);

            this._dialogProxyService.EventFromPlc_DialogInvoked += OnPlc_DialogInvoked;
            this._dialogProxyService.EventFromPlc_DialogRemoved += OnPlc_DialogRemoved;

            this.SignalRClient.EventDialogOpen += OnSignalRClient_DialogOpen;
            this.SignalRClient.EventDialogClose += OnSignalRClient_DialogClose;

            if (this._dialogProxyService.DisplayedDialogs.Count() > 0)
                await Refresh();
        }

        private async void OnSignalRClient_DialogOpen(object sender, SignalRClientReceivedMessageArgs e)
        {
            Log.Logger.Information($"AxoDialogLocator by SignalR Opening : {e.SymbolOfDialogInstance}");
            // this message is no supported and required at this moment.
            await Refresh();
        }

        private async void OnSignalRClient_DialogClose(object sender, SignalRClientReceivedMessageArgs e)
        {
            Log.Logger.Information($"AxoDialogLocator by SignalR Closing: {e.SymbolOfDialogInstance}");
            _dialogProxyService.RemoveDisplayedDialog(e.SymbolOfDialogInstance);
            await Refresh();
        }

        private async void OnPlc_DialogInvoked(object? sender, AxoDialogEventArgs e)
        {
            Log.Logger.Information($"AxoDialogLocator by PLC Opening: {e.SymbolOfDialogInstance}");
            await Refresh();
        }

        private async void OnPlc_DialogRemoved(object? sender, AxoDialogEventArgs e)
        {
            Log.Logger.Information($"AxoDialogLocator by PLC Closing: {e.SymbolOfDialogInstance}");
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
        public override void Dispose()
        {
            if (_dialogProxyService != null)
            {
                _dialogProxyService.EventFromPlc_DialogInvoked -= OnPlc_DialogInvoked;
                _dialogProxyService.EventFromPlc_DialogRemoved -= OnPlc_DialogRemoved;
                _dialogProxyService.TryDispose(LocatorGuid);
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

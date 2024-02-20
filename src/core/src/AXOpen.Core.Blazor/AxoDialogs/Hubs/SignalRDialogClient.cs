using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.SignalR.Client;
using Polly;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs.Hubs
{
    /// <summary>
    /// Handles SignalR communications for dialog synchronization across multiple clients within the application.
    /// </summary>
    public class SignalRDialogClient : IAsyncDisposable
    {
        /// <summary>
        /// Defines an event handler for receiving messages.
        /// </summary>
        public delegate void MessageReceivedEventHandler(object sender, SignalRClientReceivedMessageArgs e);

        /// <summary>
        /// Indicates whether the SignalR connection is established.
        /// </summary>
        public bool IsConnected { protected set; get; } = false;
        public bool EnableLoging { set; get; }

        private readonly string _hubUrl = "";

        /// <summary>
        /// The HubConnection used for SignalR communication.
        /// </summary>
        public HubConnection _hubConnection;

        /// <summary>
        /// Initializes a new instance of the SignalRDialogClient class.
        /// </summary>
        /// <param name="siteUrl">The base URL of the site, used to construct the full URL to the SignalR hub.</param>
        public SignalRDialogClient(string siteUrl)
        {
            _hubUrl = siteUrl.TrimEnd('/') + SignalRDialogHub.HUB_URL_SUFFIX;
        }

        /// <summary>
        /// Starts the SignalR connection asynchronously.
        /// </summary>
        public async Task StartAsync()
        {
            if (!IsConnected)
            {
                // Initialize the HubConnection with or without SSL certificate bypassing, based on developer settings
                _hubConnection = new HubConnectionBuilder()
                    .WithUrl(_hubUrl, options =>
                    {
                        if (DeveloperSettings.BypassSSLCertificate)
                        {
                            options.UseDefaultCredentials = true;
                            options.HttpMessageHandlerFactory = (msg) =>
                            {
                                if (msg is HttpClientHandler clientHandler)
                                {
                                    // Bypass SSL certificate
                                    clientHandler.ServerCertificateCustomValidationCallback +=
                                        (sender, certificate, chain, sslPolicyErrors) => true;
                                }
                                return msg;
                            };
                        }
                    })
                    .WithAutomaticReconnect()
                    .Build();

                _hubConnection.On<string>(SignalRDialogMessages.CLIENT_RECEIVE_DIALOG_OPEN, (SymbolOfDialogInstance) =>
                {
                    HandleDialogOpen(SymbolOfDialogInstance);
                });
                _hubConnection.On<string>(SignalRDialogMessages.CLIENT_RECEIVE_DIALOG_CLOSE, (SymbolOfDialogInstance) =>
                {
                    HadleDialogClose(SymbolOfDialogInstance);
                });

                // Start the connection
                await _hubConnection.StartAsync();
                IsConnected = true;
            }
        }

        /// <summary>
        /// Sends a message to all clients to open a specific dialog.
        /// </summary>
        /// <param name="SymbolOfDialogInstance">The symbol identifying the dialog instance to be opened.</param>
        public async Task SendToAllClients_OpenDialog(string SymbolOfDialogInstance)
        {
            // Ensure the connection is established before sending messages
            while (_hubConnection.State != HubConnectionState.Connected)
            {
                if (EnableLoging)
                    Log.Logger.Error($"SignalR client is not connected to:{_hubUrl}.For client Instance: {SymbolOfDialogInstance}");
                await Task.Delay(6000);
            }
            await _hubConnection.SendAsync(SignalRDialogMessages.SERVER_SEND_DIALOG_OPEN, SymbolOfDialogInstance);
        }

        /// <summary>
        /// Sends a message to all clients to close a specific dialog.
        /// </summary>
        /// <param name="SymbolOfDialogInstance">The symbol identifying the dialog instance to be closed.</param>
        public async Task SendToAllClients_CloseDialog(string SymbolOfDialogInstance)
        {
            // Ensure the connection is established before sending messages
            while (_hubConnection.State != HubConnectionState.Connected)
            {
                if(EnableLoging)
                    Log.Logger.Error($"SignalR client is not connected to:{_hubUrl}.For client Instance: {SymbolOfDialogInstance}");
               
                await Task.Delay(6000);
            }
            await _hubConnection.SendAsync(SignalRDialogMessages.SERVER_SEND_DIALOG_CLOSE, SymbolOfDialogInstance);
        }

        /// <summary>
        /// Handles opening dialog events from the server.
        /// </summary>
        /// <param name="symbolOfDialogInstance">The symbol of the dialog instance that was opened.</param>
        private void HandleDialogOpen(string symbolOfDialogInstance)
        {
            EventDialogOpen?.Invoke(this, new SignalRClientReceivedMessageArgs(symbolOfDialogInstance));
        }

        /// <summary>
        /// Handles closing dialog events from the server.
        /// </summary>
        /// <param name="symbolOfDialogInstance">The symbol of the dialog instance that was closed.</param>
        private void HadleDialogClose(string symbolOfDialogInstance)
        {
            EventDialogClose?.Invoke(this, new SignalRClientReceivedMessageArgs(symbolOfDialogInstance));
        }

        /// <summary>
        /// Event triggered when a dialog is requested to open by the server.
        /// </summary>
        public event MessageReceivedEventHandler EventDialogOpen;

        /// <summary>
        /// Event triggered when a dialog is requested to close by the server.
        /// </summary>
        public event MessageReceivedEventHandler EventDialogClose;

        /// <summary>
        /// Stops the SignalR connection asynchronously.
        /// </summary>
        public async Task StopAsync()
        {
            if (IsConnected && _hubConnection != null)
            {
                await _hubConnection.StopAsync();
                await _hubConnection.DisposeAsync();
                _hubConnection = null;
                IsConnected = false;
            }
        }


        /// <summary>
        /// Disposes the SignalR client and cleans up resources.
        /// </summary>
        public async ValueTask DisposeAsync()
        {
            if (IsConnected)
            {
                await StopAsync();
            }
        }
    }
}

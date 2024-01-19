using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.SignalR.Client;
using Polly;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs.Hubs
{
    /// <summary>
    /// Client for SignalR communication within application, serves for synchronization of dialogues across multiple clients.
    /// </summary>
    public class SignalRDialogClient : IAsyncDisposable
    {
        public delegate void MessageReceivedEventHandler(object sender, SignalRClientReceivedMessageArgs e);

        public bool IsConnected { protected set; get; } = false;
        private readonly string _hubUrl = "";
        public HubConnection _hubConnection;

        public SignalRDialogClient(string siteUrl)
        {
            _hubUrl = siteUrl.TrimEnd('/') + SignalRDialogHub.HUB_URL_SUFFIX;
        }

        public async Task StartAsync()
        {
            if (!IsConnected)
            {
                if (DeveloperSettings.BypassSSLCertificate)
                {
                    _hubConnection = new HubConnectionBuilder()
                        .WithUrl(_hubUrl, options =>
                        {
                            options.UseDefaultCredentials = true;
                            options.HttpMessageHandlerFactory = (msg) =>
                            {
                                if (msg is HttpClientHandler clientHandler)
                                {
                                    // bypass SSL certificate
                                    clientHandler.ServerCertificateCustomValidationCallback +=
                                        (sender, certificate, chain, sslPolicyErrors) => { return true; };
                                }

                                return msg;
                            };
                        })
                        .WithAutomaticReconnect()
                        .Build();
                }
                else
                {
                    _hubConnection = new HubConnectionBuilder()
                        .WithUrl(_hubUrl)
                        .WithAutomaticReconnect()
                        .Build();
                }

                _hubConnection.On<string>(SignalRDialogMessages.CLIENT_RECEIVE_DIALOG_OPEN, (SymbolOfDialogInstance) =>
                {
                    HandleDialogOpen(SymbolOfDialogInstance);
                });
                _hubConnection.On<string>(SignalRDialogMessages.CLIENT_RECEIVE_DIALOG_CLOSE, (SymbolOfDialogInstance) =>
                {
                    HadleDialogClose(SymbolOfDialogInstance);
                });

                // start the connection
                await _hubConnection.StartAsync();
                IsConnected = true;
            }
        }

        #region Ssending messages to all SignalR Client

        public async Task SendToAllClients_OpenDialog(string SymbolOfDialogInstance)
        {
            while (_hubConnection.State != HubConnectionState.Connected)
            {
                await Console.Out.WriteLineAsync($"SignalR Hub is not connected! {_hubConnection.State.ToString()}");
                await Task.Delay(6000);
            }

            await _hubConnection.SendAsync(SignalRDialogMessages.SERVER_SEND_DIALOG_OPEN, SymbolOfDialogInstance);
        }

        public async Task SendToAllClients_CloseDialog(string SymbolOfDialogInstance)
        {
            while (_hubConnection.State != HubConnectionState.Connected)
            {
                await Console.Out.WriteLineAsync($"SignalR Hub is not connected! {_hubConnection.State.ToString()}");
                await Task.Delay(6000);
            }

            await _hubConnection.SendAsync(SignalRDialogMessages.SERVER_SEND_DIALOG_CLOSE, SymbolOfDialogInstance);
        }

        #endregion Ssending messages to all SignalR Client

        #region Handling SignalR messges from server

        private void HandleDialogOpen(string symbolOfDialogInstance)
        {
            // raise an event to subscribers
            EventDialogOpen?.Invoke(this, new SignalRClientReceivedMessageArgs(symbolOfDialogInstance));
        }

        private void HadleDialogClose(string symbolOfDialogInstance)
        {
            // raise an event to subscribers
            EventDialogClose?.Invoke(this, new SignalRClientReceivedMessageArgs(symbolOfDialogInstance));
        }

        #endregion Handling SignalR messges from server


        /// <summary>
        /// Event rise when server requires close dialog
        /// </summary>
        public event MessageReceivedEventHandler EventDialogOpen;

        /// <summary>
        /// Event rise when server requires open dialog
        /// </summary>
        public event MessageReceivedEventHandler EventDialogClose;


        public async Task StopAsync()
        {
            if (IsConnected && _hubConnection != null)
            {
                // disconnect the client
                await _hubConnection.StopAsync();
                await _hubConnection.DisposeAsync();
                _hubConnection = null;
                IsConnected = false;
            }
        }

        public async ValueTask DisposeAsync()
        {
            if (IsConnected)
            {
                await StopAsync();
            }
        }
    }
}
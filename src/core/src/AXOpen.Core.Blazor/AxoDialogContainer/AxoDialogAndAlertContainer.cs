using AXOpen.Base.Dialogs;
using AXOpen.Core;
using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Manages and contains multiple AxoDialogLocatorService instances, catering to various dialog instances and web clients.
    /// It serves as a central hub for all dialog-related activities within the application.
    /// </summary>
    public class AxoDialogAndAlertContainer : IAsyncDisposable
    {
        // The SignalR client used for sending signals to the server, especially for closing dialogs
        private SignalRDialogClient _singalRDialogClient;
        public bool EnableLoging { set; get; }

        /// <summary>
        /// Provides access to the initialized SignalR dialog client.
        /// </summary>
        public SignalRDialogClient SingalRDialogClient => _singalRDialogClient;

        // Tracks alerts associated with observed objects
        public HashSet<string> ObservedObjectsAlerts { get; set; } = new HashSet<string>();

        /// <summary>
        /// Maintains a collection of dialog monitors for handling PLC events. These objects generate new events managed by the proxy service.
        /// </summary>
        public Dictionary<string, AxoAlertObserver> ObservedAlerts { get; set; } = new();


        /// <summary>
        /// Maintains a collection of dialog monitors for handling PLC events. These objects generate new events managed by the proxy service.
        /// </summary>
        public Dictionary<string, AxoDialogObserver> ObservedDialogs { get; set; } = new();

        /// <summary>
        /// Stores existing dialog-locators services, allowing for the management and retrieval of dialog services.
        /// </summary>
        public Dictionary<string, AxoDialogLocatorService> DialogLocatorServicesDictionary { get; set; } = new Dictionary<string, AxoDialogLocatorService>();

        // Additional container for managing alert dialog proxy services
        public Dictionary<string, AxoAlertProxyService> AlertDialogProxyServicesDictionary { get; set; } = new Dictionary<string, AxoAlertProxyService>();

        /// <summary>
        /// Initializes the SignalR client for dialog management and starts the connection.
        /// </summary>
        /// <param name="uri">The URI for the SignalR hub connection.</param>
        public Task InitializeSignalR(string uri)
        {
            if (_singalRDialogClient == null)
            {
                _singalRDialogClient = new SignalRDialogClient(uri);
            }

            return SingalRDialogClient.StartAsync();
        }

        /// <summary>
        /// Sends a signal to all clients to close a specific dialog instance.
        /// </summary>
        /// <param name="dialogInstanceSymbol">The symbol representing the dialog instance to be closed.</param>
        public Task SendToAllClients_CloseDialog(string dialogInstanceSymbol)
        {
            LogMessage($"CONTAINER | SignalR | Close FOR {dialogInstanceSymbol}");

            return SingalRDialogClient.SendToAllClients_CloseDialog(dialogInstanceSymbol);
        }

        /// <summary>
        /// Collects and adds dialogs to the ObservedDialogs based on the observed objects.
        /// </summary>
        /// <param name="observedObject">The objects being observed for dialogs.</param>
        /// <returns>A dictionary symbol list of the dialogs.</returns>
        internal Dictionary<string, AxoDialogObserver> CollectDialogsOnObjects(IEnumerable<ITwinObject> observedObject)
        {
            Dictionary<string, AxoDialogObserver> collectedDialogs = new();

            if (observedObject == null || !observedObject.Any()) return null;

            foreach (var item in observedObject)
            {
                CollectDialogs(item, collectedDialogs);
            }

            return collectedDialogs;
        }

        /// <summary>
        /// Collects and adds dialogs to the ObservedDialogs based on the observed objects.
        /// </summary>
        /// <param name="observedObject">The objects being observed for dialogs.</param>
        /// <returns>A dictionary symbol list of the dialogs.</returns>
        internal Dictionary<string, AxoAlertObserver> CollectAlertsOnObjects(IEnumerable<ITwinObject> observedObject)
        {
            Dictionary<string, AxoAlertObserver> collectedAllerts = new();

            if (observedObject == null || !observedObject.Any()) return null;

            foreach (var item in observedObject)
            {
                CollectAlerts(item, collectedAllerts);
            }

            return collectedAllerts;
        }



        /// <summary>
        /// Collects dialogs from the specified observed object and adds them to the provided symbol list.
        /// </summary>
        /// <typeparam name="T">The dialog type to collect.</typeparam>
        /// <param name="observedObject">The object being observed.</param>
        /// <param name="symbolListOfDialogs">The list where collected dialog symbols are added.</param>
        private void CollectDialogs(ITwinObject observedObject, Dictionary<string, AxoDialogObserver> locatedDialogs)
        {
            var descendants = observedObject.GetDescendants<AxoDialogBase>();

            foreach (var dialog in descendants)
            {
                if (!ObservedDialogs.ContainsKey(dialog.Symbol))
                {
                    var observer = new AxoDialogObserver(dialog);

                    ObservedDialogs.Add(dialog.Symbol, observer);
                    locatedDialogs.TryAdd(dialog.Symbol, observer);
                }
                else
                {
                    locatedDialogs.TryAdd(dialog.Symbol, ObservedDialogs[dialog.Symbol]);
                }
            }
        }


        /// <summary>
        /// Collects dialogs from the specified observed object and adds them to the provided symbol list.
        /// </summary>
        /// <typeparam name="T">The dialog type to collect.</typeparam>
        /// <param name="observedObject">The object being observed.</param>
        /// <param name="symbolListOfDialogs">The list where collected dialog symbols are added.</param>
        private void CollectAlerts(ITwinObject observedObject, Dictionary<string, AxoAlertObserver> locatedDialogs)
        {
            var descendants = observedObject.GetDescendants<AXOpen.Core.AxoAlert>();

            foreach (var dialog in descendants)
            {
                if (!ObservedDialogs.ContainsKey(dialog.Symbol))
                {
                    var observer = new AxoAlertObserver(dialog);

                    ObservedAlerts.Add(dialog.Symbol, observer);
                    locatedDialogs.TryAdd(dialog.Symbol, observer);
                }
                else
                {
                    locatedDialogs.TryAdd(dialog.Symbol, ObservedAlerts[dialog.Symbol]);
                }
            }
        }


        protected void LogMessage(string msg)
        {
            if (EnableLoging)
            {
                Log.Logger.Debug(msg);
            }
        }


        /// <summary>
        /// Disposes of the SignalR client and cleans up any resources.
        /// </summary>
        public async ValueTask DisposeAsync()
        {
            if (SingalRDialogClient != null)
            {
                await SingalRDialogClient.StopAsync();
            }
        }
    }
}

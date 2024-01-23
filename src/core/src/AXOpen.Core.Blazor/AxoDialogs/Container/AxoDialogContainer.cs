using AXOpen.Base.Dialogs;
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
    public class AxoDialogContainer : IAsyncDisposable
    {
        // The SignalR client used for sending signals to the server, especially for closing dialogs
        private SignalRDialogClient _singalRDialogClient;

        /// <summary>
        /// Provides access to the initialized SignalR dialog client.
        /// </summary>
        public SignalRDialogClient SingalRDialogClient => _singalRDialogClient;

        // Tracks alerts associated with observed objects
        public HashSet<string> ObservedObjectsAlerts { get; set; } = new HashSet<string>();

        /// <summary>
        /// Maintains a collection of dialog monitors for handling PLC events. These objects generate new events managed by the proxy service.
        /// </summary>
        public Dictionary<string, AxoDialogMonitoring> MonitoredDialogs { get; set; } = new Dictionary<string, AxoDialogMonitoring>();

        /// <summary>
        /// Stores existing dialog-locators services, allowing for the management and retrieval of dialog services.
        /// </summary>
        public Dictionary<string, AxoDialogLocatorService> DialogLocatorServicesDictionary { get; set; } = new Dictionary<string, AxoDialogLocatorService>();

        // Additional container for managing alert dialog proxy services
        public Dictionary<string, AxoAlertDialogProxyService> AlertDialogProxyServicesDictionary { get; set; } = new Dictionary<string, AxoAlertDialogProxyService>();

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
            Log.Logger.Information($"CONTAINER | SignalR | Close FOR {dialogInstanceSymbol}");

            return SingalRDialogClient.SendToAllClients_CloseDialog(dialogInstanceSymbol);
        }

        /// <summary>
        /// Collects and adds dialogs to the MonitoredDialogs based on the observed objects.
        /// </summary>
        /// <param name="_observedObject">The objects being observed for dialogs.</param>
        /// <returns>A dictionary symbol list of the dialogs.</returns>
        internal Dictionary<string, AxoDialogMonitoring> CollectDialogsOnObjects(IEnumerable<ITwinObject> _observedObject)
        {
            var SymbolListOfDialogs = new List<string>();

            if (_observedObject == null || !_observedObject.Any()) return null;

            foreach (var item in _observedObject)
            {
                CollectDialogs<IsModalDialogType>(item, SymbolListOfDialogs);
            }

            return GetDialogsBySymbol(SymbolListOfDialogs);
        }

        /// <summary>
        /// Retrieves dialog monitors based on provided symbols.
        /// </summary>
        /// <param name="symbols">List of dialog symbols to retrieve monitors for.</param>
        /// <returns>A dictionary of dialog monitors.</returns>
        private Dictionary<string, AxoDialogMonitoring> GetDialogsBySymbol(List<string> symbols)
        {
            var dialogs = new Dictionary<string, AxoDialogMonitoring>();

            foreach (var symbol in symbols)
            {
                MonitoredDialogs.TryGetValue(symbol, out AxoDialogMonitoring d);
                if (d != null)
                    dialogs.Add(symbol, d);
            }

            return dialogs;
        }

        /// <summary>
        /// Collects dialogs from the specified observed object and adds them to the provided symbol list.
        /// </summary>
        /// <typeparam name="T">The dialog type to collect.</typeparam>
        /// <param name="observedObject">The object being observed.</param>
        /// <param name="SymbolListOfDialogs">The list where collected dialog symbols are added.</param>
        private void CollectDialogs<T>(ITwinObject observedObject, List<string> SymbolListOfDialogs) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);

            foreach (var dialog in descendants)
            {
                SymbolListOfDialogs.Add(dialog.Symbol);

                if (!MonitoredDialogs.ContainsKey(dialog.Symbol))
                {
                    var monitoring = new AxoDialogMonitoring(dialog);
                    MonitoredDialogs.Add(dialog.Symbol, monitoring);
                }
            }
        }

        /// <summary>
        /// Recursively collects descendants of the specified type from the given object.
        /// </summary>
        /// <typeparam name="T">The type of descendants to collect.</typeparam>
        /// <param name="obj">The starting object.</param>
        /// <param name="children">The list to which found descendants are added.</param>
        /// <returns>An enumerable of found descendants.</returns>
        protected IEnumerable<T> GetDescendants<T>(ITwinObject obj, IList<T> children = null) where T : class
        {
            children = children ?? new List<T>();

            if (obj != null)
            {
                foreach (var child in obj.GetChildren())
                {
                    var ch = child as T;
                    if (ch != null)
                    {
                        children.Add(ch);
                    }

                    GetDescendants<T>(child, children);
                }
            }
            return children;
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

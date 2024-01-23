using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    ///  Container for multiple AxoDialogProxyService types, based on multiple different dialogues instances and opened web clients.
    /// </summary>
    public class AxoDialogContainer : IAsyncDisposable
    {

        /// <summary>
        /// SingalRClient it is used for sending dignal to the server from dialogs -> especialy for closing dialogs
        /// </summary>
        /// 
        private SignalRDialogClient _singalRDialogClient;
        public SignalRDialogClient SingalRDialogClient
        {
            get
            {
                return _singalRDialogClient;
            }
        }


        //public HashSet<string> ObservedObjects { get; set; } = new HashSet<string>();
        public HashSet<string> ObservedObjectsAlerts { get; set; } = new HashSet<string>();


        /// <summary>
        /// Dictionary of the Handling PLC events. On thist objects generate new evetns that are handled by proxy service.
        /// </summary>
        public Dictionary<string, DialogMonitor> MonitoredDialogs { get; set; } = new Dictionary<string, DialogMonitor>();
        /// <summary>
        /// Dictionary of the existing proxy services.
        /// </summary>
        public Dictionary<string, AxoDialogProxyService> DialogProxyServicesDictionary { get; set; } = new Dictionary<string, AxoDialogProxyService>();

        public Dictionary<string, AxoAlertDialogProxyService> AlertDialogProxyServicesDictionary { get; set; } = new Dictionary<string, AxoAlertDialogProxyService>();

        public Task InitializeSignalR(string uri)
        {
            if (_singalRDialogClient == null)
            {
                _singalRDialogClient = new SignalRDialogClient(uri);
            }

            return SingalRDialogClient.StartAsync();
        }

        public Task SendToAllClients_CloseDialog(string dialogInstanceSymbol)
        {
            Log.Logger.Information($"CONTAINER | SignalR | Close FOR  {dialogInstanceSymbol}");

            return SingalRDialogClient.SendToAllClients_CloseDialog(dialogInstanceSymbol);
        }


        /// <summary>
        /// Collect and Add dialogs to MonitoredDialogs.
        /// </summary>
        /// <param name="_observedObject"></param>
        /// <returns>list symblol list of the dialogs</returns>
        internal Dictionary<string, DialogMonitor> CollectDialogsOnObjects( IEnumerable<ITwinObject> _observedObject)
        {

            var SymbolListOfDialogs = new List<string>();

            if (_observedObject == null || _observedObject.Count() == 0) return null;

            foreach (var item in _observedObject)
            {
                CollectDialogs<IsModalDialogType>(item , SymbolListOfDialogs);
            }

            return GetDialogsBySymbol(SymbolListOfDialogs);

        }

        private Dictionary<string, DialogMonitor> GetDialogsBySymbol(List<string> symbols)
        { 
            var dialogs = new Dictionary<string, DialogMonitor>();

            foreach (var symbol in symbols)
            {

                MonitoredDialogs.TryGetValue(symbol, out DialogMonitor d);
                if (d != null)
                    dialogs.Add(symbol, d);
            }

            return dialogs;
        }

        /// <summary>
        /// Collect dialogs on the object
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="observedObject"></param>
        /// <param name="SymbolListOfDialogs"></param>
        private void CollectDialogs<T>(ITwinObject observedObject, List<string> SymbolListOfDialogs) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);

            foreach (var dialog in descendants)
            {
                SymbolListOfDialogs.Add(dialog.Symbol);

                if (!MonitoredDialogs.ContainsKey(dialog.Symbol))
                {
                    var monitoring = new DialogMonitor(dialog);
                    MonitoredDialogs.Add(dialog.Symbol, monitoring);               
                }
            }
        }

        protected IEnumerable<T> GetDescendants<T>(ITwinObject obj, IList<T> children = null) where T : class
        {
            children = children != null ? children : new List<T>();

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

        public async ValueTask DisposeAsync()
        {
            if (SingalRDialogClient != null)
            {
                await SingalRDialogClient.StopAsync();
            }
        }
    }
}

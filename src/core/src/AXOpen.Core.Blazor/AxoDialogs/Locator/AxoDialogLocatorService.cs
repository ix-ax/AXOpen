using AXOpen.Base.Dialogs;
using AXSharp.Connector;
using Serilog;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// A proxy service for modal dialogs. It initializes remote tasks responsible for handling dialogues.
    /// </summary>
    public class AxoDialogLocatorService : IDisposable
    {
        private readonly AxoDialogContainer _dialogContainer;

        private readonly IEnumerable<ITwinObject> _observedObject;

        private volatile object _lockObject = new object();

        private Dictionary<string, AxoDialogMonitoring> _observedDialogs = new();

        /// <summary>
        /// Gets the locator path used for identifying the service in the dialog container, typically the URL of the page where the dialogue is managed.
        /// </summary>
        public string LocatorPath { get; private set; }

        private List<Guid> _subscribers = new();

        /// <summary>
        /// Gets or sets the list of displayed dialogs.
        /// </summary>
        public List<IsDialogType> DisplayedDialogs { get; set; } = new();

        /// <summary>
        /// Instantiates a new <see cref="AxoDialogLocatorService"/>. Typically, this constructor is called only once.
        /// </summary>
        /// <param name="dialogLocatorPath">The Path of the DialogLocator used for service identification in the dialogContainer (typically the URL of the page where the dialogue is handled).</param>
        /// <param name="dialogContainer">The container of proxy services managed by the application over SignalR.</param>
        /// <param name="observedObjects">The twin objects that may contain invokable dialogs from the controller to be handled by this proxy service.</param>
        public AxoDialogLocatorService(
            string dialogLocatorPath,
            Guid dialogLocatorGuid,
            AxoDialogContainer dialogContainer,
            IEnumerable<ITwinObject> observedObjects)
        {
            LocatorPath = dialogLocatorPath;
            _dialogContainer = dialogContainer;
            _observedObject = observedObjects;

            _dialogContainer.DialogLocatorServicesDictionary.TryAdd(LocatorPath, this);
            _observedDialogs = _dialogContainer.CollectDialogsOnObjects(_observedObject);

            StartObservingDialogues(dialogLocatorGuid);
        }

        /// <summary>
        /// Begins observing dialogues for this proxy service.
        /// </summary>
        internal void StartObservingDialogues(Guid dialogLocatorGuid)
        {
            if (!_subscribers.Any())
            {
                foreach (var dialog in _observedDialogs)
                {
                    dialog.Value.StartDialogMonitoring(LocatorPath);

                    dialog.Value.EventHandler_Invoke += HandleDialogInvocation_FromPlc;
                    dialog.Value.EventHandler_Close += HandleDialogClosing_FromPlc;
                }
            }

            _subscribers.Add(dialogLocatorGuid);
        }

        /// <summary>
        /// Stops observing dialogues for this proxy service.
        /// </summary>
        internal void StopObservingDialogues(Guid dialogLocatorGuid)
        {
            if (_subscribers.Any(p => p == dialogLocatorGuid))
            {
                _subscribers.Remove(dialogLocatorGuid);

                if (_subscribers.Count < 1)
                {
                    foreach (var dialog in _observedDialogs)
                    {
                        dialog.Value.StopDialogMonitoring(LocatorPath);

                        dialog.Value.EventHandler_Invoke -= HandleDialogInvocation_FromPlc;
                        dialog.Value.EventHandler_Close -= HandleDialogClosing_FromPlc;
                    }
                }
            }
        }

        /// <summary>
        /// Event triggered when a dialog from the controller is invoked.
        /// </summary>
        internal event EventHandler<AxoDialogEventArgs>? EventFromPlc_DialogInvoked;

        /// <summary>
        /// Event triggered when a dialog from the controller is removed.
        /// </summary>
        internal event EventHandler<AxoDialogEventArgs>? EventFromPlc_DialogRemoved;

        /// <summary>
        /// Handles the invocation of a dialogue from the controller.
        /// </summary>
        /// <param name="dialog">The dialog to handle.</param>
        protected async void HandleDialogInvocation_FromPlc(object? sender, AxoDialogEventArgs e)
        {
            var senderAsDialogMonitor = sender as AxoDialogMonitoring;

            if (senderAsDialogMonitor != null)
            {
                lock (_lockObject)
                {
                    Log.Logger.Information($"Proxy->Plc Invoke of: {senderAsDialogMonitor.Dialog.Symbol}");

                    var exist = DisplayedDialogs.Any(p => p.Symbol == e.SymbolOfDialogInstance);
                    if (!exist)
                    {
                        DisplayedDialogs.Add(senderAsDialogMonitor.Dialog);
                    }
                }

                EventFromPlc_DialogInvoked?.Invoke(senderAsDialogMonitor.Dialog, e);
            }
        }

        /// <summary>
        /// Handles the closing of a dialogue from the controller.
        /// </summary>
        public void HandleDialogClosing_FromPlc(object? sender, AxoDialogEventArgs e)
        {
            var senderAsDialogMonitor = sender as AxoDialogMonitoring;

            if (senderAsDialogMonitor != null)
            {
                lock (_lockObject)
                {
                    Log.Logger.Information($"Proxy->Plc Closing of: {senderAsDialogMonitor.Dialog.Symbol}");

                    var exist = DisplayedDialogs.Any(p => p.Symbol == senderAsDialogMonitor.Dialog.Symbol);
                    if (exist)
                    {
                        DisplayedDialogs.Remove(senderAsDialogMonitor.Dialog);

                        EventFromPlc_DialogRemoved?.Invoke(this, e);
                    }
                }
            }
        }

        /// <summary>
        /// Removes a displayed dialog based on its symbol.
        /// </summary>
        public void RemoveDisplayedDialog(string dialogSymbol)
        {
            if (!string.IsNullOrEmpty(dialogSymbol))
            {
                lock (_lockObject)
                {
                    Log.Logger.Information($"Proxy->Plc Closing of: {dialogSymbol}");

                    var exist = DisplayedDialogs.Any(p => p.Symbol == dialogSymbol);
                    if (exist)
                    {
                        var first = DisplayedDialogs.First(p => p.Symbol == dialogSymbol);
                        DisplayedDialogs.Remove(first);

                        EventFromPlc_DialogRemoved?.Invoke(this, new AxoDialogEventArgs(dialogSymbol));
                    }
                }
            }
        }

        /// <summary>
        /// Checks if a dialog with a specific symbol is currently displayed.
        /// </summary>
        public bool IsDisplayedDialogWithSymbol(string dialogSymbol)
        {
            lock (_lockObject)
            {
                return DisplayedDialogs.Any(p => p.Symbol == dialogSymbol);
            }
        }

        /// <summary>
        /// Attempts to dispose of the proxy service based on a dialog locator GUID.
        /// </summary>
        public void TryDispose(Guid dialogLocatorGuid)
        {
            StopObservingDialogues(dialogLocatorGuid);

            Log.Logger.Information($"Proxy->TryDispose {LocatorPath}/{dialogLocatorGuid}");
        }

        /// <summary>

        /// Disposes resources related to handling and communication with the controller.
        /// </summary>
        public void Dispose()
        {
            _observedDialogs.Clear();
            Log.Logger.Information($"Proxy->Dispose {LocatorPath}");
        }
    }
}
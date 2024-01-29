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
        private readonly AxoDialogAndAlertContainer _dialogContainer;

        private readonly IEnumerable<ITwinObject> _observedObjects;

        private volatile object _lockObject = new object();

        private Dictionary<string, AxoDialogObserver> _observedDialogs = new();

        private List<Guid> _subscribers = new();

        /// <summary>
        /// Gets the locator path used for identifying the service in the dialog container, typically the URL of the page where the dialogue is managed.
        /// </summary>
        public string LocatorPath { get; private set; }

        /// <summary>
        /// Gets or sets the list of displayed dialogs.
        /// </summary>
        public List<IDialog> DisplayedDialogs { get; set; } = new();

        /// <summary>
        /// Instantiates a new <see cref="AxoDialogLocatorService"/>. Typically, this constructor is called only once.
        /// </summary>
        /// <param name="dialogLocatorPath">The Path of the DialogLocator used for service identification in the dialogContainer (typically the URL of the page where the dialogue is handled).</param>
        /// <param name="dialogContainer">The container of proxy services managed by the application over SignalR.</param>
        /// <param name="observedObjects">The twin objects that may contain invokable dialogs from the controller to be handled by this proxy service.</param>
        public AxoDialogLocatorService(
            string dialogLocatorPath,
            AxoDialogAndAlertContainer dialogContainer,
            IEnumerable<ITwinObject> observedObjects)
        {
            LocatorPath = dialogLocatorPath;
            _dialogContainer = dialogContainer;
            _observedObjects = observedObjects;

            _dialogContainer.DialogLocatorServicesDictionary.TryAdd(LocatorPath, this);

            _observedDialogs = _dialogContainer.CollectDialogsOnObjects(_observedObjects);
        }

        /// <summary>
        /// Begins observing dialogues for this proxy service.
        /// </summary>
        public void  StartObservingDialogues(Guid dialogLocatorGuid)
        {
            if (!_subscribers.Any())
            {
                foreach (var dialog in _observedDialogs)
                {
                    dialog.Value.StartObservation(LocatorPath);

                    dialog.Value.EventHandler_Invoke += HandleDialogInvocation_FromPlc;
                    dialog.Value.EventHandler_Close += HandleDialogClosing_FromPlc;
                }
            }

            CloseFinishedDialogs(); // if anyone was close during server off state

            _subscribers.Add(dialogLocatorGuid);
        }

        /// <summary>
        /// Close observing dialogues that was closed or reseted during server off state.
        /// </summary>
        internal void CloseFinishedDialogs()
        {
            List<string> toRemove = new();
            foreach (AxoDialogBase d in DisplayedDialogs)
            {
                if (d.Status.LastValue == (short)eAxoTaskState.Ready)
                {
                    toRemove.Add(d.Symbol);
                }
            }

            foreach (var dialogSymbol in toRemove)
            {
                Log.Logger.Information($"AxoDialogLocatorService closing inactive dialog: {dialogSymbol}");
                RemoveDisplayedDialog(dialogSymbol);
            }
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
                    DisposeObservedDialogsHandling();
                }
            }
        }

        private void DisposeObservedDialogsHandling()
        {
            foreach (var dialog in _observedDialogs)
            {
                dialog.Value.StopObservation(LocatorPath);

                dialog.Value.EventHandler_Invoke -= HandleDialogInvocation_FromPlc;
                dialog.Value.EventHandler_Close -= HandleDialogClosing_FromPlc;
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
            var senderAsDialogMonitor = sender as AxoDialogObserver;

            if (senderAsDialogMonitor != null)
            {
                lock (_lockObject)
                {
                    Log.Logger.Information($"AxoDialogLocatorService invoke dialog (from Plc): {senderAsDialogMonitor.Dialog.Symbol}");

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
            var senderAsDialogMonitor = sender as AxoDialogObserver;

            if (senderAsDialogMonitor != null)
            {
                lock (_lockObject)
                {
                    Log.Logger.Information($"AxoDialogLocatorService remove displayed dialog (from Plc): {senderAsDialogMonitor.Dialog.Symbol}");

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
                    Log.Logger.Information($"AxoDialogLocatorService removing displayed dialog: {dialogSymbol}");

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
            Log.Logger.Information($"AxoDialogLocatorService TryDispose() {LocatorPath}/{dialogLocatorGuid}");
            StopObservingDialogues(dialogLocatorGuid);

        }

        /// <summary>
        /// Disposes resources related to handling and communication with the controller.
        /// </summary>
        public void Dispose()
        {
            Log.Logger.Information($"AxoDialogLocatorService Dispose() {LocatorPath}");

            _subscribers.Clear();

            DisposeObservedDialogsHandling(); // force dispose

            _observedDialogs.Clear();
        }
    }
}
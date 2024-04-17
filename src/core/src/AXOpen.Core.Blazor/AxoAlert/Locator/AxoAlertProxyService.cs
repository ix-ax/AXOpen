using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs;
using AXSharp.Connector;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoAlertDialog
{
    /// <summary>
    /// Proxy service for alert dialogs, where remote tasks responsible for dialogues handling are initilized
    /// </summary>
    public class AxoAlertProxyService : IDisposable
    {
        private AxoDialogAndAlertContainer _dialogContainer;

        private IEnumerable<ITwinObject> _observedObjects;

        private List<Guid> _subscribers = new();

        private Dictionary<string, AxoAlertObserver> _observedAlertDialogs = new();

        /// <summary>
        /// Gets the locator path used for identifying the service in the dialog container, typically the URL of the page where the dialogue is managed.
        /// </summary>
        public string LocatorPath { get; private set; }

        public IAlertService ScopedAlertDialogService = new AxoAlertService();

        public AxoAlertProxyService(
            string alertLocatorPath,
            AxoDialogAndAlertContainer dialogContainer,
            IEnumerable<ITwinObject> observedObjects)
        {
            _dialogContainer = dialogContainer;
            _observedObjects = observedObjects;
            LocatorPath = alertLocatorPath;

            _dialogContainer.AlertDialogProxyServicesDictionary.TryAdd(alertLocatorPath, this);
            _observedAlertDialogs = _dialogContainer.CollectAlertsOnObjects(_observedObjects);
        }

        public void StartObservingAlertDialogues(Guid dialogLocatorGuid)
        {
            if (!_subscribers.Any())
            {
                foreach (var dialog in _observedAlertDialogs)
                {
                    dialog.Value.StartObservation(LocatorPath);

                    dialog.Value.EventHandler_Invoke += Queue;
                }
            }

            _subscribers.Add(dialogLocatorGuid);
        }

        /// <summary>
        /// Stops observing dialogues for this proxy service.
        /// </summary>
        internal void StopObservingAlertDialogues(Guid dialogLocatorGuid)
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
            foreach (var dialog in _observedAlertDialogs)
            {
                dialog.Value.StopObservation(LocatorPath);

                dialog.Value.EventHandler_Invoke -= Queue;
            }
        }

        public event EventHandler AlertDialogInvoked;

        /// <summary>
        ///  Invoked dialogues are handled within this method and subseqeuntly event is raised in application, which is then handled in UI.
        /// </summary>
        /// <param name="dialog"></param>
        protected async void Queue(object sender, EventArgs a)
        {
            if (sender is AXOpen.Core.AxoAlert)
            {
                AlertDialogInvoked?.Invoke(sender, new EventArgs());
            }
        }

        /// <summary>
        /// Attempts to dispose of the proxy service based on a dialog locator GUID.
        /// </summary>
        public void TryDispose(Guid dialogLocatorGuid)
        {
            StopObservingAlertDialogues(dialogLocatorGuid);
        }

        /// <summary>
        /// Disposes resources related to handling and communication with the controller.
        /// </summary>
        public void Dispose()
        {
            _subscribers.Clear();

            DisposeObservedDialogsHandling(); // force dispose

            _observedAlertDialogs.Clear();
        }
    }
}
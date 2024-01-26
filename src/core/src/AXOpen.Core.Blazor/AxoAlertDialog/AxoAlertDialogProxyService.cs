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
    public class AxoAlertDialogProxyService : IDisposable
    {

        private AxoDialogContainer _dialogContainer;

        private IEnumerable<ITwinObject> _observedObjects;

        private List<Guid> _subscribers = new();

        private Dictionary<string, IsAlertDialogType> _observedAlertDialogs = new();


        public IAlertDialogService ScopedAlertDialogService = new AxoAlertDialogService();

        public IsDialogType DialogInstance { set; get; }

        public AxoAlertDialogProxyService(Guid dialogLocatorGuid, AxoDialogContainer dialogContainer, IEnumerable<ITwinObject> observedObjects)
        {
            _dialogContainer = dialogContainer;
            _observedObjects = observedObjects;

            CollectAlertDialogsOnObjects();

            StartObservingAlertDialogues(dialogLocatorGuid);
        }

        public void StartObservingAlertDialogues(Guid dialogLocatorGuid)
        {
            if (!_subscribers.Any())
            {
                foreach (var dialog in _observedAlertDialogs)
                {
                    dialog.Value.Initialize(() => Queue(dialog.Value));
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
                    DeinitializeObservedDialogs();
                }
            }
        }

        private void DeinitializeObservedDialogs()
        {
            foreach (var dialog in _observedAlertDialogs)
            {
                dialog.Value.DeInitialize();
            }
        }

        public event EventHandler<AxoDialogEventArgs> AlertDialogInvoked;

        /// <summary>
        ///  Invoked dialogues are handled within this method and subseqeuntly event is raised in application, which is then handled in UI.
        /// </summary>
        /// <param name="dialog"></param>
        protected async void Queue(IsDialogType dialog)
        {
            DialogInstance = dialog;

            var asAxoAlertDialog = dialog as AXOpen.Core.AxoAlertDialog;

            if (asAxoAlertDialog != null) // is AxoAlertDialog
            {
                var reqProps = new List<ITwinPrimitive>()
                { 
                    asAxoAlertDialog._title,
                    asAxoAlertDialog._dialogType,
                    asAxoAlertDialog._message,
                    asAxoAlertDialog._timeToBurn,
                };

               await DialogInstance.GetConnector().ReadBatchAsync(reqProps);
            }
            else
            {
                await DialogInstance.ReadAsync();
            }

            AlertDialogInvoked?.Invoke(this, new AxoDialogEventArgs(string.Empty));
        }


        internal void CollectAlertDialogsOnObjects()
        {
            if (_observedObjects == null || !_observedObjects.Any()) return;

            foreach (var item in _observedObjects)
            {
                CollectAlertDialogs(item);
            }
        }

        private void CollectAlertDialogs(ITwinObject observedObject)
        {
            var descendants = observedObject.GetDescendants<IsAlertDialogType>();

            foreach (var dialog in descendants)
            {
                _observedAlertDialogs.Add(dialog.Symbol, dialog);
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

            DeinitializeObservedDialogs(); // force dispose

            _observedAlertDialogs.Clear();

        }
    }
}

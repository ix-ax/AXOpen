using AXOpen.Base.Dialogs;
using AXSharp.Connector;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Proxy service for modal dialogs, where remote tasks responsible for dialogues handling are initialized. 
    /// </summary>
    public class AxoDialogProxyService : AxoDialogProxyServiceBase, IDisposable
    {
        private AxoDialogContainer _axoDialogContainer;
        private readonly IEnumerable<ITwinObject> _observedObject;

        /// <summary>
        /// Creates new instance of <see cref="AxoDialogProxyService"/>
        /// </summary>
        /// <param name="dialogContainer">Container of proxy services handled by the application over SignalR.</param>
        /// <param name="dialogId">Id of the dialogue (typical the URL of the page where the dialogue is handled).</param>
        /// <param name="observedObjects">Twin objects that may contain invokable dialogs from the controller that are to be handled by this proxy service.</param>
        public AxoDialogProxyService(AxoDialogContainer dialogContainer,string dialogId, IEnumerable<ITwinObject> observedObjects)
        {
            _observedObject = observedObjects;
            _axoDialogContainer = dialogContainer;
            DialogId = dialogId;
            StartObservingObjectsForDialogues();
        }

        private string DialogId { get; set; }

        /// <summary>
        /// Starts observing dialogue of this proxy service.
        /// </summary>
        internal void StartObservingObjectsForDialogues()
        {
            if (_observedObject == null || _observedObject.Count() == 0) return;
            foreach (var item in _observedObject)
            {
                _axoDialogContainer.ObservedObjects.Add(item.Symbol);
                StartObservingDialogs<IsModalDialogType>(item);
            }
        }

        internal event EventHandler<AxoDialogEventArgs>? DialogInvoked;

        /// <summary>
        /// Handles the invocation of the dialogue from the controller.
        /// </summary>
        /// <param name="dialog">Dialogue to be handled.</param>
        protected async void HandleDialogInvocation(IsDialogType dialog)
        {
            DialogInstance = dialog;
            DialogInstance.DialogId = DialogId;
            await DialogInstance.ReadAsync();
            DialogInvoked?.Invoke(this, new AxoDialogEventArgs(DialogId));
        }

        private void StartObservingDialogs<T>(ITwinObject observedObject) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);
            foreach (var dialog in descendants)
            {
                dialog.Initialize(() => HandleDialogInvocation(dialog));
            }
        }

        /// <summary>
        /// Releases resources related to handling and communication with the controller.
        /// </summary>
        public void Dispose()
        {
            foreach (var observedObject in _observedObject)
            {
                var descendants = GetDescendants<IsDialogType>(observedObject);
                foreach (var dialog in descendants)
                {
                    dialog.DeInitialize();
                }
            }
        }
    }
}

using AXOpen.Base.Dialogs;
using AXSharp.Connector;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Proxy service for modal dialogs, where remote tasks responsible for dialogues handling are initialized. 
    /// </summary>
    public class AxoDialogProxyService : AxoDialogProxyServiceBase, IDisposable
    {
        private readonly AxoDialogContainer _dialogContainer;
        private readonly IEnumerable<ITwinObject> _observedObject;

        private List<IsDialogType> _observedDialogs = new();

        private string DialogLocatorId { get; set; }

        /// <summary>
        /// Creates new instance of <see cref="AxoDialogProxyService"/>, in standard case is this constructor called only once.
        /// </summary>
        /// <param name="dialogLocatorId">Id of DialogLocator. Use for identification of the service in the dailogContainer. (typical the URL of the page where the dialogue is handled)..</param>
        /// <param name="dialogContainer">Container of proxy services handled by the application over SignalR.</param>
        /// <param name="observedObjects">Twin objects that may contain invokable dialogs from the controller that are to be handled by this proxy service.</param>
        public AxoDialogProxyService(string dialogLocatorId, AxoDialogContainer dialogContainer, IEnumerable<ITwinObject> observedObjects)
        {
            DialogLocatorId = dialogLocatorId;
            _dialogContainer = dialogContainer;
            _observedObject = observedObjects;

            _dialogContainer.DialogProxyServicesDictionary.TryAdd(DialogLocatorId, this);

            StartObservingObjectsForDialogues();
        }

        /// <summary>
        /// Starts observing dialogue of this proxy service.
        /// </summary>
        protected void StartObservingObjectsForDialogues()
        {
            if (_observedObject == null || _observedObject.Count() == 0) return;

            foreach (var item in _observedObject)
            {
                //todo -> it is needed: _dialogContainer.ObservedObjects,  are not used...
                _dialogContainer.ObservedObjects.Add(item.Symbol);
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
            await dialog.ReadAsync();

            var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialog.Symbol);
            if (!exist)
            {
                this.DisplayedDialogs.Add(dialog);
            }

            // just invoke in dialog locator state change....
            DialogInvoked?.Invoke(this, new AxoDialogEventArgs(DialogLocatorId, dialog.Symbol));
        }

        private void StartObservingDialogs<T>(ITwinObject observedObject) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);

            foreach (var dialog in descendants)
            {
                _observedDialogs.Add(dialog);
                dialog.Initialize(() => HandleDialogInvocation(dialog));
            }
        }


        /// <summary>
        /// Releases resources related to handling and communication with the controller.
        /// </summary>
        public void Dispose()
        {
            foreach (var dialog in _observedDialogs)
            {
                dialog.DeInitialize();
            }
            _observedDialogs.Clear();
        }
    }
}

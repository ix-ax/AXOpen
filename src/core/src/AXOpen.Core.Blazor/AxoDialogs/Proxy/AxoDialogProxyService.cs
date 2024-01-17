using AXOpen.Base.Dialogs;
using AXSharp.Connector;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Proxy service for modal dialogs, where remote tasks responsible for dialogues handling are initialized. 
    /// </summary>
    public class AxoDialogProxyService :  IDisposable
    {
        private readonly AxoDialogContainer _dialogContainer;
        private readonly IEnumerable<ITwinObject> _observedObject;

        private List<IsDialogType> _observedDialogs = new();

        private string _dialogLocatorId { get; set; }

        public List<IsDialogType> DisplayedDialogs { get; set; } = new();


        /// <summary>
        /// Creates new instance of <see cref="AxoDialogProxyService"/>, in standard case is this constructor called only once.
        /// </summary>
        /// <param name="dialogLocatorId">Id of DialogLocator. Use for identification of the service in the dailogContainer. (typical the URL of the page where the dialogue is handled)..</param>
        /// <param name="dialogContainer">Container of proxy services handled by the application over SignalR.</param>
        /// <param name="observedObjects">Twin objects that may contain invokable dialogs from the controller that are to be handled by this proxy service.</param>
        public AxoDialogProxyService(string dialogLocatorId, AxoDialogContainer dialogContainer, IEnumerable<ITwinObject> observedObjects)
        {
            _dialogLocatorId = dialogLocatorId;
            _dialogContainer = dialogContainer;
            _observedObject = observedObjects;

            _dialogContainer.DialogProxyServicesDictionary.TryAdd(_dialogLocatorId, this);

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

        internal event EventHandler<AxoDialogEventArgs>? NewDialogInvoked;
        internal event EventHandler<AxoDialogEventArgs>? DailogRemoved;

        /// <summary>
        /// Handles the invocation of the dialogue from the controller.
        /// </summary>
        /// <param name="dialog">Dialogue to be handled.</param>
        protected async void HandleDialogInvocation(IsDialogType dialog)
        {
            await dialog.ReadAsync();

            dialog.DialogLocatorId = _dialogLocatorId;

            var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialog.Symbol);
            if (!exist)
            {
                this.DisplayedDialogs.Add(dialog);
            }

            // just invoke in dialog locator state change....
            NewDialogInvoked?.Invoke(this, new AxoDialogEventArgs(_dialogLocatorId, dialog.Symbol));
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


        public void RemoveDisplayedDialog(IsDialogType dialog)
        {
            var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialog.Symbol);
            if (exist)
            {
                this.DisplayedDialogs.Remove(dialog);
                DailogRemoved?.Invoke(this, new AxoDialogEventArgs(_dialogLocatorId, dialog.Symbol));
            }
        }

        public void RemoveDisplayedDialog(string dialogSymbol)
        {
            var exist = this.DisplayedDialogs.Any((p) => p.Symbol == dialogSymbol);
            if (exist)
            {
                var first = this.DisplayedDialogs.First((p) => p.Symbol == dialogSymbol);
                this.DisplayedDialogs.Remove(first);
                DailogRemoved?.Invoke(this, new AxoDialogEventArgs(_dialogLocatorId, dialogSymbol));

            }
        }

        public bool IsDisplayedDialogWithSymbol(string dialogSymbol)
        {
            return this.DisplayedDialogs.Any((p) => p.Symbol == dialogSymbol);
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

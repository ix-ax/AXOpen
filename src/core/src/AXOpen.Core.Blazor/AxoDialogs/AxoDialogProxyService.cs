using AXOpen.Base.Abstractions.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Dialogs;
using AXSharp.Connector;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    /// <summary>
    /// Proxy service for modal dialogs, where remote tasks responsible for dialogues handling are initilized. 
    /// </summary>
    public class AxoDialogProxyService : AxoDialogProxyServiceBase, IDisposable
    {
        private AxoDialogContainer _axoDialogContainer;
        private readonly IEnumerable<ITwinObject> _observedObject;

        public AxoDialogProxyService(AxoDialogContainer dialogContainer,string id, IEnumerable<ITwinObject> observedObjects)
        {
            _observedObject = observedObjects;
            _axoDialogContainer = dialogContainer;
            DialogServiceId = id;
            StartObservingObjectsForDialogues();
        }

        public string DialogServiceId { get; set; }

        public void StartObservingObjectsForDialogues()
        {
            if (_observedObject == null || _observedObject.Count() == 0) return;
            foreach (var item in _observedObject)
            {
                _axoDialogContainer.ObservedObjects.Add(item.Symbol);
                UpdateDialogs<IsModalDialogType>(item);
            }
          
        }

        public event EventHandler<AxoDialogEventArgs>? DialogInvoked;

        protected async void Queue(IsDialogType dialog)
        {
            DialogInstance = dialog;
            DialogInstance.DialogId = DialogServiceId;
            await DialogInstance.ReadAsync();
            DialogInvoked?.Invoke(this, new AxoDialogEventArgs(DialogServiceId));
        }

        

        void UpdateDialogs<T>(ITwinObject observedObject) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);
            foreach (var dialog in descendants)
            {
                dialog.Initialize(() => Queue(dialog));
            }
        }

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

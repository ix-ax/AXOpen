using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Dialogs;
using AXSharp.Connector;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public class AxoDialogProxyService : IAxoDialogProxyServiceSingleton
    {
        public DialogClient DialogClient { get; set; }

        public AxoDialogProxyService()
        {
             
        }

        public AxoDialogProxyService(string id, IEnumerable<ITwinObject> observedObjects)
        {
            DialogServiceId = id;
            SetObservedObjects(observedObjects);
        }

        public string DialogServiceId { get; set; }

        public void SetObservedObjects(IEnumerable<ITwinObject> observedObjects)
        {
            if (observedObjects == null || observedObjects.Count() == 0) return;
            foreach (var item in observedObjects)
            {
                //check if we observing symbol, if yes, we do not have to initialize new remote tasks
                if (!ObservedObjects.Contains(item.Symbol))
                {
                    //create observer for this object
                    ObservedObjects.Add(item.Symbol);
                    UpdateDialogs(item);
                }
            }
          
        }
        public event EventHandler<AxoDialogEventArgs> DialogInvoked;
        public IsDialogType DialogInstance { get; set; } 

        protected async void Queue(IsDialogType dialog)
        {
            DialogInstance = dialog;
            DialogInstance.DialogId = DialogServiceId;
            Console.WriteLine($"Queue! {dialog.GetType()}");
            await DialogInstance.ReadAsync();
            DialogInvoked?.Invoke(this, new AxoDialogEventArgs(DialogServiceId));
        }

        public List<string> ObservedObjects{ get; set; } = new List<string>();
        void UpdateDialogs(ITwinObject observedObject)
        {
            var descendants = GetDescendants<IsDialogType>(observedObject);
            foreach (var dialog in descendants)
            {
                dialog.Initialize(() => Queue(dialog));
            }
            
        }

        private IEnumerable<T> GetDescendants<T>(ITwinObject obj, IList<T> children = null) where T : class
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

  
    }
}

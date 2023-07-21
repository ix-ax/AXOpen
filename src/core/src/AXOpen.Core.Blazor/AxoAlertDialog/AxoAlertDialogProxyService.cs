using AXOpen.Base.Abstractions.Dialogs;
using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoDialogs;
using AXOpen.Dialogs;
using AXSharp.Connector;
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
    public class AxoAlertDialogProxyService : AxoDialogProxyServiceBase
    {
        public AxoAlertDialogProxyService()
        {
            DialogService = new AxoAlertDialogService();
        }

        public IAlertDialogService DialogService { get; set; }
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
                    UpdateDialogs<IsAlertDialogType>(item);
                }
            }

        }
        public event EventHandler<AxoDialogEventArgs> AlertDialogInvoked;

        /// <summary>
        ///  Invoked dialogues are handled within this method and subseqeuntly event is raised in application, which is then handled in UI.
        /// </summary>
        /// <param name="dialog"></param>
        protected async void Queue(IsDialogType dialog)
        {
            //Console.WriteLine("!!!QUEUE");
            DialogInstance = dialog;
            await DialogInstance.ReadAsync();
            AlertDialogInvoked?.Invoke(this, new AxoDialogEventArgs(string.Empty));
        }

        public List<string> ObservedObjects { get; set; } = new List<string>();
        void UpdateDialogs<T>(ITwinObject observedObject) where T : class, IsDialogType
        {
            var descendants = GetDescendants<T>(observedObject);
            foreach (var dialog in descendants)
            {
                dialog.Initialize(() => Queue(dialog));
            }

        }
    }
}

using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Dialogs;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    //public delegate void Notify();
    public class AxoDialogProxyService
    {
        public DialogClient DialogClient { get; set; }
        public AxoDialogProxyService()
        {
            ObservedObjects = new List<string>();
        }

        public AxoDialogProxyService(string uri, string id, IEnumerable<ITwinObject> observedObjects)
        {
            ObservedObjects = new List<string>();
            //DialogClient = new DialogClient(uri);
            DialogServiceId = id;
            SetObservedObjects(observedObjects);
        }

        public string DialogServiceId { get; set; }

        public void SetObservedObjects(IEnumerable<ITwinObject> observedObjects)
        {
            Console.WriteLine("Objects set!");
            if (observedObjects == null || observedObjects.Count() == 0) return;
            foreach (var item in observedObjects)
            {
                //check if we observing symbol, if yes, we do not have to initialize new remote tasks
                if (!ObservedObjects.Contains(item.Symbol))
                {
                    //create observer for this object
                    ObservedObjects.Add(item.Symbol);
                    UpdateDialogs(item);
                    Console.WriteLine("Dialogs unique initialize!");
                }
            }

          
        }

       //   public event Notify DialogInvoked;
        public event EventHandler<AxoDialogEventArgs> DialogInvoked;
        public IsDialogType DialogInstance { get; set; }

        protected async void Queue(IsDialogType dialog)
        {
            await Task.Run(() =>
            {
                DialogInstance = dialog;
                DialogInstance.DialogId = DialogServiceId;
                DialogInstance.ReadAsync();
            });
                Console.WriteLine("Queue!");
                DialogInvoked?.Invoke(this, new AxoDialogEventArgs(DialogServiceId));

        }

        public List<string> ObservedObjects{ get; set; }
        void UpdateDialogs(ITwinObject observedObject)
        {
            var descendants = GetDescendants<IsDialogType>(observedObject);
            foreach (var dialog in descendants)
            {
                dialog.Initialize(() => Queue(dialog));
            }
            
        }


        public IEnumerable<T> GetDescendants<T>(ITwinObject obj, IList<T> children = null) where T : class
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

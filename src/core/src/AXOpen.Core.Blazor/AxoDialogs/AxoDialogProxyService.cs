using AXOpen.Dialogs;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public delegate void Notify();
    public class AxoDialogProxyService
    {
        public AxoDialogProxyService()
        {
            ObservedObjects = new List<string>();
        }
        //public AxoDialogProxyService(IEnumerable<ITwinObject> observedObjects) 
        //{
        //    UpdateDialogs(observedObjects);
        //}

        public void SetObservedObjects(IEnumerable<ITwinObject> observedObjects)
        {
            Console.WriteLine("Objects set!");
            if (observedObjects == null || observedObjects.Count() == 0) return;
            foreach (var item in observedObjects)
            {
                //check if we observing symbol, if yes, we do not have to initialize new remote tasks
                if (ObservedObjects.Contains(item.Symbol))
                {
                    continue;
                }
                else
                {
                    //check no, create observer for this object
                    ObservedObjects.Add(item.Symbol);
                    UpdateDialogs(item);
                    Console.WriteLine("Dialogs unique initialize!");
                }
            }
            //ObservedObjects.AddRange(observedObjects.Select(x => x.Symbol));
            //UpdateDialogs(observedObjects);
          
        }

        

        public event Notify DialogInvoked;
        public event Notify DialogInvoked2;
        public IsDialog DialogInstance { get; set; }

        protected async void Queue(IsDialog dialog)
        {
            await Task.Run(() =>
            {
                DialogInstance = dialog;
                DialogInstance.ReadAsync();
                DialogInstance.Show = true;
            });
                Console.WriteLine("Queue!");
                DialogInvoked?.Invoke();
             //await InvokeAsync(StateHasChanged);
            //DialogInvoked2.Invoke();

            //});


            //DialogInstance.Notify += new EventHandler(Notified);
            //DialogInstance.NotifyNow();

        }
        public bool HasBaseEventHandlerInitialized { get; set; } = false;
        public bool HasConcreteEventHandlerInitialized { get; set; } = false;
        public List<string> ObservedObjects{ get; set; }
        void UpdateDialogs(ITwinObject observedObject)
        {
            var descendants = GetDescendants<IsDialog>(observedObject);
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

        //public static AxoDialogProxyService Create(IEnumerable<ITwinObject> observedObjects)
        //{
        //    var dialogProxyService = new AxoDialogProxyService(observedObjects);
        //    return dialogProxyService;
        //}
    }
}

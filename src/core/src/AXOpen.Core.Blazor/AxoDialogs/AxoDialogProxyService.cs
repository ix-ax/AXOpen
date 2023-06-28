using AXOpen.Dialogs;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public delegate void Notify();
    public class AxoDialogProxyService
    {
        public AxoDialogProxyService(IEnumerable<ITwinObject> observedObjects) 
        {
            UpdateDialogs(observedObjects);
        }

        public event Notify DialogInvoked;
        public IsDialog DialogInstance { get; set; }

        protected async void Queue(IsDialog dialog)
        {
            await Task.Run(() =>
            {
                DialogInstance = dialog;
                DialogInstance.ReadAsync();
              
            });
           
            DialogInvoked?.Invoke();
        }
        


        void UpdateDialogs(IEnumerable<ITwinObject> observedObjects)
        {
            if (observedObjects == null || observedObjects.Count() == 0) return;
            foreach (var observedObject in observedObjects)
            {
                var descendants = GetDescendants<IsDialog>(observedObject);
                foreach (var dialog in descendants)
                {
                    dialog.Initialize(() => Queue(dialog));
                }
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

        public static AxoDialogProxyService Create(IEnumerable<ITwinObject> observedObjects)
        {
            var dialogProxyService = new AxoDialogProxyService(observedObjects);
            return dialogProxyService;
        }
    }
}

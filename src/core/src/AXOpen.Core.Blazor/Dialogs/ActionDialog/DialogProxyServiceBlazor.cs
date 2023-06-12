using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Abstractions.Dialogs.ActionDialog;
using AXSharp.Connector;

namespace AXSharp.Presentation.Blazor.Controls.Dialogs.ActionDialog
{
    public delegate void Notify();
    public class DialogProxyServiceBlazor : DialogProxyServiceBase
    {
        public event Notify? DialogInvoked;
        public DialogProxyServiceBlazor(IEnumerable<ITwinObject> observedObjects) : base(observedObjects)
        {
            UpdateDialogs(observedObjects);
        }

        public IsDialog DialogVortex { get; set; }
        protected override async void Queue(IsDialog dialog)
        {
            //dialog.Read();
            await Task.Run(() =>
            {
                DialogVortex = dialog;
                //DialogVortex.Read();
            });

            OnProcessCompleted();

        }
        protected virtual void OnProcessCompleted()
        {
            //if ProcessCompleted is not null then call delegate
            DialogInvoked?.Invoke();
        }


        void UpdateDialogs(IEnumerable<ITwinObject> observedObjects)
        {
            if (observedObjects == null || observedObjects.Count() == 0) return;
            foreach (var observedObject in observedObjects)
            {
                //foreach (var dialog in observedObject.GetDescendants<IsDialog>())
                //{
                //    dialog.Initialize(() => Queue(dialog));
                //}
            }

        }

        public static DialogProxyServiceBlazor Create(IEnumerable<ITwinObject> observedObjects)
        {
            var dialogProxyService = new DialogProxyServiceBlazor(observedObjects);
            return dialogProxyService;
        }

    }
}
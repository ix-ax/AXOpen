using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Abstractions.Dialogs.ActionDialog;
using AXSharp.Connector;

namespace AXSharp.Presentation.Blazor.Controls.Dialogs.ActionDialog
{
    public abstract class DialogProxyServiceBase
    {
        protected DialogProxyServiceBase(IEnumerable<ITwinObject> observedObjects)
        {
            UpdateDialogs(observedObjects);
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
        protected abstract void Queue(IsDialog dialog);
    }
}

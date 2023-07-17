using AXOpen.Dialogs;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.AxoDialogs
{
    public interface IAxoDialogProxyServiceSingleton
    {
        public event EventHandler<AxoDialogEventArgs> DialogInvoked;
        public IsDialogType DialogInstance { get; set; }
        public void SetObservedObjects(IEnumerable<ITwinObject> observedObjects);
    }
}

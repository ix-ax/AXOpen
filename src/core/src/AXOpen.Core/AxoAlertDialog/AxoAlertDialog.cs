using AXOpen.Base.Abstractions.Dialogs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector;

namespace AXOpen.Core
{
    public partial class AxoAlertDialog: IsAlertDialogType
    {
        public string DialogId { get; set; }

        public new void Initialize(Action dialogAction)
        {
            DeferredAction = dialogAction;
            this.IsInitialized.Cyclic = true;
            this.StartSignature.StartPolling(250, this);
            this.StartSignature.ValueChangeEvent += ExecuteAsync;
            _defferedActionCount++;
        }

        public new void DeInitialize()
        {
            this.IsInitialized.Cyclic = false;
            this.StartSignature.StopPolling(this);
            this.StartSignature.ValueChangeEvent -= ExecuteAsync;
            _defferedActionCount--;
        }


        public void Dispose()
        {
            DeInitialize();
        }
    }
}

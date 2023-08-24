using System;
using AXOpen.Base.Dialogs;
using AXSharp.Connector;

namespace AXOpen.Core
{
    public partial class AxoAlertDialog : IsAlertDialogType
    {
        /// <inheritdoc/>
        public string DialogId { get; set; }

        /// <inheritdoc/>
        public new void Initialize(Action dialogAction)
        {
            DeferredAction = dialogAction;
            this.IsInitialized.Cyclic = true;
            this.StartSignature.StartPolling(250, this);
            this.StartSignature.ValueChangeEvent += ExecuteAsync;
            _defferedActionCount++;
        }

        /// <inheritdoc/>
        public new void DeInitialize()
        {
            this.IsInitialized.Cyclic = false;
            this.StartSignature.StopPolling(this);
            this.StartSignature.ValueChangeEvent -= ExecuteAsync;
            _defferedActionCount--;
        }

        /// <summary>
        /// Releases additional resources allocated byt his dialog.
        /// </summary>
        public void Dispose()
        {
            DeInitialize();
        }
    }
}

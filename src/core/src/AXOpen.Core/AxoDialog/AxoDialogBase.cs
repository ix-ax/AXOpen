using AXOpen.Base.Dialogs;
using AXSharp.Connector;

namespace AXOpen.Core
{

    public partial class AxoDialogBase : IsModalDialogType
    {
        public string DialogId { get; set; }

        /// <summary>
        /// Initialized remote task for this dialog, with polling instead of cyclic subscription.
        /// </summary>
        /// <param name="dialogAction">Action that will be performed on remove call.</param>
        public new void Initialize(Action dialogAction)
        {
            DeferredAction = dialogAction;
            this.IsInitialized.Cyclic = true;
            this.StartSignature.StartPolling(250, this);
            this.StartSignature.ValueChangeEvent += ExecuteAsync;
            _defferedActionCount++;
        }

        /// <summary>
        /// Removes handling of this dialogue, unsubscribing from polling and removed all event handler.
        /// </summary>
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

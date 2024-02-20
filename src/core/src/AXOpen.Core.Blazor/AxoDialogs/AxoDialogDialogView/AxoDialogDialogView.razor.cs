using AXOpen.Core.Blazor.AxoDialogs;
using AXSharp.Connector;

namespace AXOpen.Core
{
    public partial class AxoDialogDialogView : AxoDialogBaseView<AxoDialog>, IDisposable
    {


        private bool IsOkDialogType() => (Component._buttons.Cyclic == (short)eDialogButtons.Ok);


        private bool IsYesNoDialogType() => (Component._buttons.Cyclic == (short)eDialogButtons.YesNo);


        private bool IsYesNoCancelDialogType() => (Component._buttons.Cyclic == (short)eDialogButtons.YesNoCancel);


        protected override void OnInitialized()
        {
            base.OnInitialized(); // call always "base"
        }


        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            base.AddToPolling(element, pollingInterval); // call always "base"

            var dialog = (AxoDialog)element;

            if (dialog != null)
            {
                var selecedToPool = new List<ITwinElement>();

                selecedToPool.Add(dialog._dialogType);
                selecedToPool.Add(dialog._buttons);
                selecedToPool.Add(dialog._caption);
                selecedToPool.Add(dialog._text); // can be changed

                foreach (var item in selecedToPool)
                {
                    item.StartPolling(pollingInterval, this);
                    PolledElements.Add(item);
                }
            }

        }


        public async Task DialogAnswerOk()
        {
            Component._answer.Edit = (short)eDialogAnswer.OK;
            await CloseDialogsWithSignalR();
        }
        public async Task DialogAnswerYes()
        {
            Component._answer.Edit = (short)eDialogAnswer.Yes;
            await CloseDialogsWithSignalR();
        }
        public async Task DialogAnswerNo()
        {
            Component._answer.Edit = (short)eDialogAnswer.No;
            await CloseDialogsWithSignalR();
        }
        public async Task DialogAnswerCancel()
        {
            Component._answer.Edit = (short)eDialogAnswer.Cancel;
            await CloseDialogsWithSignalR();
        }



        public override void Dispose()
        {
            base.Dispose();
        }
    }
}

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
            Component._closeSignal.ValueChangeEvent += OnCloseSignal;
            base.OnInitialized();
        }

        // experimental stuff for external closings
        private async void OnCloseSignal(object sender, EventArgs e) 
        {
            if (Component._closeSignal.Cyclic)
            {
                //this is probably reduntant (normal Close should enough, however some wierdness is occuring
                await CloseDialogsWithSignalR();
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
            Component._answer.ValueChangeEvent -= OnCloseSignal;
        }
    }
}

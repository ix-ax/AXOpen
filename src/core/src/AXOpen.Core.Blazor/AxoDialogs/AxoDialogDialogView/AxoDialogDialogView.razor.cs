using AXOpen.Core.Blazor.AxoDialogs;
using AXSharp.Connector;

namespace AXOpen.Core
{
    public partial class AxoDialogDialogView : AxoDialogBaseView<AxoDialog>, IDisposable
    {


        private bool IsOkDialogType() => Component._hasOK.Cyclic;
        

        private bool IsYesNoDialogType() => Component._hasYes.Cyclic && Component._hasNo.Cyclic;
        

        private bool IsYesNoCancelDialogType() => Component._hasYes.Cyclic && Component._hasNo.Cyclic && Component._hasCancel.Cyclic;


        protected override void OnInitialized()
        {
            Component._answer.ValueChangeEvent += OnCloseSignal;
            base.OnInitialized();

        }

        private async void OnCloseSignal(object sender, EventArgs e) 
        {
            await ((AxoDialog)Component).ReadAsync();
            var asnwer = Component._answer.LastValue;
            if (asnwer != (short)eDialogAnswer.NoAnswer && !IsInternalClose)
            {
                await CloseDialogsWithSignalR();

            }
            IsInternalClose = false;

        }
        private bool IsInternalClose { get; set; }
        public async Task DialogAnswerOk()  
        {
            IsInternalClose = true;
            Component._answer.Edit = (short)eDialogAnswer.OK;
           await CloseDialogsWithSignalR();
           
        }
        public async Task DialogAnswerYes()
        {
            IsInternalClose = true;
            Component._answer.Edit = (short)eDialogAnswer.Yes;
            await CloseDialogsWithSignalR();
        }
        public async Task DialogAnswerNo()
        {
            IsInternalClose = true;
            Component._answer.Edit = (short)eDialogAnswer.No;
            await CloseDialogsWithSignalR();
        }
        public async Task DialogAnswerCancel()
        {
            IsInternalClose = true;
            Component._answer.Edit = (short)eDialogAnswer.Cancel;
            await CloseDialogsWithSignalR();
        }

        public void Dispose()
        {
            Component._answer.ValueChangeEvent -= OnCloseSignal;
            _dialogContainer.DialogClient.MessageReceivedDialogClose -= OnCloseDialogMessage;
            _dialogContainer.DialogClient.MessageReceivedDialogOpen -= OnOpenDialogMessage;
        }
    }
}

using AXOpen.Core.Blazor.AxoDialogs;

namespace AXOpen.Core
{
    public partial class AxoDialogDialogView : AxoDialogBaseView<AxoDialog>
    {


        private bool IsOkDialogType() => Component._hasOK.Cyclic;
        

        private bool IsYesNoDialogType() => Component._hasYes.Cyclic && Component._hasNo.Cyclic;
        

        private bool IsYesNoCancelDialogType() => Component._hasYes.Cyclic && Component._hasNo.Cyclic && Component._hasCancel.Cyclic;
        

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
    }
}

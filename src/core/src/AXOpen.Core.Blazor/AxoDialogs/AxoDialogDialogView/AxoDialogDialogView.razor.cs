﻿using AXOpen.Core.Blazor.AxoDialogs;
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
            Component._closeSignal.ValueChangeEvent += OnCloseSignal;
            base.OnInitialized();
        }

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

        public void Dispose()
        {
            Component._answer.ValueChangeEvent -= OnCloseSignal;
            _dialogContainer.DialogClient.MessageReceivedDialogClose -= OnCloseDialogMessage;
            _dialogContainer.DialogClient.MessageReceivedDialogOpen -= OnOpenDialogMessage;
        }
    }
}
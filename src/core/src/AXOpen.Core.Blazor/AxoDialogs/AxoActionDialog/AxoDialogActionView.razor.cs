using AXOpen.Core.Blazor.AxoDialogs;
using AXOpen.Dialogs;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Pocos.AXOpen.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{
    public partial class AxoDialogActionView : AxoDialogBaseView<AxoDialog>
    {

        
        public IsDialog Dialog { get; private set; }


        private bool IsOkDialogType() => Component._hasOK.Cyclic;
        

        private bool IsYesNoDialogType() => Component._hasYes.Cyclic && Component._hasNo.Cyclic;
        

        private bool IsYesNoCancelDialogType() => Component._hasYes.Cyclic && Component._hasNo.Cyclic && Component._hasCancel.Cyclic;
        

        public async Task DialogAnswerOk()  
        {
            Component._answer.Edit = (short)eDialogAnswer.OK;
            //await HideOffcanvasAsync();
            await CloseDialog();
            //AxoApplication.Current.Logger.Information($"{nameof(DialogAnswerOk)} of {Component.HumanReadable} was executed @{{payload}}.", new { Component.Symbol });
            //Dialog = null;
            //await InvokeAsync(StateHasChanged);
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerOk)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public async Task DialogAnswerYes()
        {
            Component._answer.Edit = (short)eDialogAnswer.Yes;
            await CloseDialog();
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerYes)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public async Task DialogAnswerNo()
        {
            Component._answer.Edit = (short)eDialogAnswer.No;
            await CloseDialog();
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerNo)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public async Task DialogAnswerCancel()
        {
            Component._answer.Edit = (short)eDialogAnswer.Cancel;
            await CloseDialog();
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerCancel)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
    }
}

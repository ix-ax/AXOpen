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
       

        public async Task DialogAnswerOk()  
        {
            Component._answer.Edit = (short)eDialogAnswer.OK;
            //await HideOffcanvasAsync();
            await CloseDialog();
       
            //Dialog = null;
            //await InvokeAsync(StateHasChanged);
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerOk)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public void DialogAnswerYes()
        {
            Component._answer.Edit = (short)eDialogAnswer.Yes;
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerYes)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public void DialogAnswerNo()
        {
            Component._answer.Edit = (short)eDialogAnswer.No;
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerNo)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public void DialogAnswerCancel()
        {
            Component._answer.Edit = (short)eDialogAnswer.Cancel;
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerCancel)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
    }
}

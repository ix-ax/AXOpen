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
    public partial class AxoDialogDialogView : AxoDialogBaseView<AxoDialog>
    {


        private bool IsOkDialogType() => Component._hasOK.Cyclic;
        

        private bool IsYesNoDialogType() => Component._hasYes.Cyclic && Component._hasNo.Cyclic;
        

        private bool IsYesNoCancelDialogType() => Component._hasYes.Cyclic && Component._hasNo.Cyclic && Component._hasCancel.Cyclic;
        

        public async Task DialogAnswerOk()  
        {
            Component._answer.Edit = (short)eDialogAnswer.OK;
            await CloseDialog();
        }
        public async Task DialogAnswerYes()
        {
            Component._answer.Edit = (short)eDialogAnswer.Yes;
            await CloseDialog();
        }
        public async Task DialogAnswerNo()
        {
            Component._answer.Edit = (short)eDialogAnswer.No;
            await CloseDialog();
        }
        public async Task DialogAnswerCancel()
        {
            Component._answer.Edit = (short)eDialogAnswer.Cancel;
            await CloseDialog();
        }
    }
}

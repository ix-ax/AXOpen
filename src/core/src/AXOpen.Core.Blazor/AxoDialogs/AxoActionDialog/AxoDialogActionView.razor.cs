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
    public partial class AxoDialogActionView : RenderableComplexComponentBase<AxoDialog>
    {

        
        public IsDialog Dialog { get; private set; }
       

        public void DialogAnswerOk()
        {
            Component._answer.Edit = (short)eDialogAnswer.OK;
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerOk)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        //public void DialogAnswerYes()
        //{
        //    Dialog._answer.Synchron = (short)eDialogAnswer.Yes;
        //    //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerYes)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        //}
        //public void DialogAnswerNo()
        //{
        //    Dialog._answer.Synchron = (short)eDialogAnswer.No;
        //    //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerNo)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        //}
        //public void DialogAnswerCancel()
        //{
        //    Dialog._answer.Synchron = (short)eDialogAnswer.Cancel;
        //    //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerCancel)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        //}
    }
}

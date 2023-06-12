using AXOpen.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXSharp.Presentation.Blazor.Controls.Dialogs.ActionDialog
{
    public class TcoDialogDialogViewModel : RenderableViewModelBase
    {
        public Pocos.AXOpen.Core.AxoDialog Dialog { get; private set; } = new Pocos.AXOpen.Core.AxoDialog();
        public override object Model { get => Dialog; set => Dialog = (Pocos.AXOpen.Core.AxoDialog)value; }

        public void DialogAnswerOk()
        {
            Dialog._answer = (short)eDialogAnswer.OK;
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerOk)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public void DialogAnswerYes()
        {
            Dialog._answer = (short)eDialogAnswer.Yes;
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerYes)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public void DialogAnswerNo()
        {
            Dialog._answer = (short)eDialogAnswer.No;
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerNo)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }
        public void DialogAnswerCancel()
        {
            Dialog._answer = (short)eDialogAnswer.Cancel;
            //TcoAppDomain.Current.Logger.Information($"{nameof(DialogAnswerCancel)} of {Dialog.HumanReadable} was executed @{{payload}}.", new { Dialog.Symbol });
        }


    }
}
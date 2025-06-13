using System.Security.Principal;
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



        private string BackgroundColor
        {
            get
            {
                var parsedEnum = (eDialogType)Enum.Parse(typeof(eDialogType), Component._dialogType.Cyclic.ToString());
                switch (parsedEnum)
                {
                    case eDialogType.Info:
                        return "bg-info-500"; // light red
                    case eDialogType.Warning:
                        return "bg-warning-500"; // light yellow
                    case eDialogType.Danger:
                        return "bg-danger-500"; // light blue
                    case eDialogType.Undefined:
                        return "bg-info-500"; // light green
                    default:
                        return "bg-info-500"; // default white
                }
            }
        }


        public override void ConfigurePolling()
        {
           this.StartPolling(this.Component, 250); // call always "base"

            var dialog = (AxoDialog)this.Component;

            if (dialog != null)
            {
                var toPool = new List<ITwinElement>();

                toPool.Add(dialog._dialogType);
                toPool.Add(dialog._buttons);
                toPool.Add(dialog._caption);
                toPool.Add(dialog._text); // can be changed

                foreach (var item in toPool)
                {
                    StartPolling(item);
                    PolledElements.Add(item);
                }
            }

        }

        public async Task DialogAnswerOk()
        {
            Component._answer.Edit = (short)eDialogAnswer.OK;
            AxoApplication.Current.Logger.Information($"User answered `OK`, to question {Component._text.LastValue} [{Component._caption.LastValue}]", Component, await GetUserIdentity());
            await CloseDialogsWithSignalR();
        }

        private async Task<IIdentity?> GetUserIdentity()
        {
            var authenticationStatus = await _asp.GetAuthenticationStateAsync();
            return authenticationStatus.User.Identity;
        }

        public async Task DialogAnswerYes()
        {
            Component._answer.Edit = (short)eDialogAnswer.Yes;
            AxoApplication.Current.Logger.Information($"User answered `YES`, to question {Component._text.LastValue} [{Component._caption.LastValue}]", Component, await GetUserIdentity());
            await CloseDialogsWithSignalR();
        }
        public async Task DialogAnswerNo()
        {
            Component._answer.Edit = (short)eDialogAnswer.No;
            AxoApplication.Current.Logger.Information($"User answered `NO`, to question {Component._text.LastValue} [{Component._caption.LastValue}]", Component, await GetUserIdentity());
            await CloseDialogsWithSignalR();
        }
        public async Task DialogAnswerCancel()
        {
            Component._answer.Edit = (short)eDialogAnswer.Cancel;
            AxoApplication.Current.Logger.Information($"User answered `CANCEL`, to question {Component._text.LastValue} [{Component._caption.LastValue}]", Component, await GetUserIdentity());
            await CloseDialogsWithSignalR();
        }



        public override void Dispose()
        {
            base.Dispose();
        }
    }
}

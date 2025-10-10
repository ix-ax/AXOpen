using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
//using Microsoft.JSInterop;
using System.Security.Principal;
using AXOpen.Core;
using static System.Runtime.InteropServices.JavaScript.JSType;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;


namespace AXOpen.Messaging.Static
{
    public partial class AxoMessengerView : RenderableComplexComponentBase<AxoMessenger>, IDisposable
    {

        [Inject]
        protected AuthenticationStateProvider? AuthenticationStateProvider { get; set; }

        //[Inject]
        //protected IJSRuntime js { get; set; }
        //private IJSObjectReference? jsModule;

        protected async Task<string?> GetCurrentUserName()
        {
            var authenticationState = await AuthenticationStateProvider?.GetAuthenticationStateAsync();
            return authenticationState?.User?.Identity?.Name;
        }

        protected async Task<IIdentity?> GetCurrentUserIdentity()
        {
            var authenticationState = await AuthenticationStateProvider.GetAuthenticationStateAsync();
            return authenticationState?.User?.Identity;
        }

        private async void AcknowledgeTask()
        {
            Component.AcknowledgeRequest.Cyclic = true;
            AxoApplication.Current.Logger.Information($"Message '{this.MessageText}' acknowledged.", this.Component, await GetCurrentUserIdentity());
        }

        private async void HelpTextTask()
        {
            this.ShowHelpText = !this.ShowHelpText;
        }
        private async void RestoreTask()
        {
            if (this.Component.GetParent() is AxoTask t)
            {
                t.Restore();
                AxoApplication.Current.Logger.Information($"Task '{this.Component.GetParent().Symbol}' has been restored using alarm view.", this.Component, await GetCurrentUserIdentity());
            }
        }

        public override void ConfigurePolling()
        {
            if (Component is null) return;
            StartPolling(Component.MessengerState, 500);
            StartPolling(Component.MessageCode, 500);
            StartPolling(Component.Category, 500);
            StartPolling(Component.Risen, 500);
            StartPolling(Component.Fallen, 500);
            StartPolling(Component.Acknowledged, 500);
        }

        public override void Dispose()
        {
            if (Component is null) return;
            Component.StopPolling(this);
            base.Dispose();
        }
        private string BackgroundColor
        {
            get
            {
                string retval = "btn-default";
                if (IsActive)
                {
                    retval = AckBtnBackgroundColor;
                }
                return retval;
            }
        }

        private string AckBtnBackgroundColor
        {
            get
            {
                string retval = "btn-default";
                if (Component.Category.Cyclic < 600)         // Upto warning level excluding
                {
                    retval = "btn-info";
                }
                else if (Component.Category.Cyclic < 700)   //From warning level including, upto error level excluding
                {
                    retval = "btn-warning";
                }
                else if (Component.Category.Cyclic <= 1200) //From error level including, upto catastrophic level including
                {
                    retval = "btn-danger";
                }
                return retval;
            }
        }
        private string Category
        {
            get
            {
                switch (Component.Category.Cyclic)
                {
                    case 0:
                        return "All";
                        break;
                    case 100:
                        return "Trace";
                        break;
                    case 200:
                        return "Debug";
                        break;
                    case 300:
                        return "Info";
                        break;
                    case 400:
                        return "TimedOut";
                        break;
                    case 500:
                        return "Notification";
                        break;
                    case 600:
                        return "Warning";
                        break;
                    case 700:
                        return "Error";
                        break;
                    case 900:
                        return "ProgrammingError";
                        break;
                    case 1000:
                        return "Critical";
                        break;
                    case 1100:
                        return "Fatal";
                        break;
                    case 1200:
                        return "Catastrophic";
                        break;
                    case 32000:
                        return "None";
                        break;
                    default:
                        return "None";
                        break;
                }
            }
        }
        private string ParentDescription
        {
            get
            {
                var _parent = Component.GetParent();

                if (_parent != null)
                {
                    AxoComponent _axoComponent = _parent as AxoComponent;

                    if (_axoComponent != null)
                    {
                        if (!string.IsNullOrEmpty(_axoComponent.Description_raw))
                            return $"{_axoComponent.AttributeName} ({_axoComponent.Description_raw}) ";
                        else
                            return _axoComponent.AttributeName;
                    }
                    else
                        return _parent.AttributeName;
                }

                return Component.AttributeName;
            }
        }
        private string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.AttributeName;
        private string Symbol => !(string.IsNullOrEmpty(Component.Symbol)) ? Component.Symbol.Replace(".", " . ") : "Unable to retrieve symbol!";
        private string MessageText => Component.GetMessageText();
        private string HelpText => Component.GetHelpText();
        private bool HelpTextDefined => Component.HelpTextDefined;
        private string Risen => !(string.IsNullOrEmpty(Component.Risen.Cyclic.ToString())) ? Component.Risen.Cyclic.ToString() : "";
        private string Fallen => !(string.IsNullOrEmpty(Component.Fallen.Cyclic.ToString())) ? Component.Fallen.Cyclic.ToString() : "";
        private string Acknowledged => !(string.IsNullOrEmpty(Component.Acknowledged.Cyclic.ToString())) ? Component.Acknowledged.Cyclic.ToString() : "";
        private eAxoMessengerState MessengerState
        {
            get
            {
                if (Component.State == eAxoMessengerState.Idle)
                {
                    ShowHelpText = false;
                }
                return Component.State;
            }
        }
        private bool IsActive => Component.State == eAxoMessengerState.ActiveAcknowledgeRequired || Component.State == eAxoMessengerState.ActiveAcknowledgeNotRequired || Component.State == eAxoMessengerState.ActiveAlreadyAcknowledged;
        private bool AcknowledgedBeforeFallen => Component.State == eAxoMessengerState.ActiveAlreadyAcknowledged;
        private bool HideAcknowledgeButton => Component.State <= eAxoMessengerState.Idle || Component.State == eAxoMessengerState.ActiveAcknowledgeNotRequired || Component.State == eAxoMessengerState.ActiveAlreadyAcknowledged;
        private bool HideHelpButton => MessengerState == eAxoMessengerState.Idle || !HelpTextDefined;

        private bool HideRepairButton => (!IsActive || this.Component.GetParent() is not AxoTask);
        private bool ShowHelpText;



        private bool OnlyAlarmView { get; set; } = true;

        private void ToggleComponentView()
        {
            this.OnlyAlarmView = false;
        }

        private void ToggleAlarmView()
        {
            this.OnlyAlarmView = !this.OnlyAlarmView;
            this.StateHasChanged();
        }
    }

    public class AxoMessengerDetailedCommandView : AxoMessengerView
    {
        public AxoMessengerDetailedCommandView()
        {

        }
    }

    public class AxoMessengerDetailedStatusView : AxoMessengerView
    {
        public AxoMessengerDetailedStatusView()
        {
        }
    }


}

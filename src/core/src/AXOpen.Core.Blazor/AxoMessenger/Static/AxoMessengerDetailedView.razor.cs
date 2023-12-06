using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.JSInterop;
using System.Security.Principal;
using static System.Runtime.InteropServices.JavaScript.JSType;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Messaging.Static
{
    public partial class AxoMessengerDetailedView : RenderableComplexComponentBase<AxoMessenger>, IDisposable
    {

        [Inject]
        protected AuthenticationStateProvider? AuthenticationStateProvider { get; set; }

        [Inject]
        protected IJSRuntime js { get; set; }
        private IJSObjectReference? jsModule;


        protected override async Task OnAfterRenderAsync(bool firstRender)
        {
            if (firstRender)
            {
                var jsObject = await js.InvokeAsync<IJSObjectReference>("import", "./_content/AXOpen.Core.Blazor/AxoMessenger/Static/AxoMessengerView.razor.js");
                await jsObject.InvokeVoidAsync("addPopovers");
            }
        }

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

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            base.AddToPolling(element);
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component.MessengerState);
        }

        public override void Dispose()
        {
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
        private string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.AttributeName;
        private string Symbol => !(string.IsNullOrEmpty(Component.Symbol)) ? Component.Symbol : "Unable to retrieve symbol!";
        private string MessageText => GetMessageText();
        private string HelpText => GetHelpText();
        private string Risen => !(string.IsNullOrEmpty(Component.Risen.Cyclic.ToString())) ? Component.Risen.Cyclic.ToString() : "";
        private string Fallen => !(string.IsNullOrEmpty(Component.Fallen.Cyclic.ToString())) ? Component.Fallen.Cyclic.ToString() : "";
        private string Acknowledged => !(string.IsNullOrEmpty(Component.Acknowledged.Cyclic.ToString())) ? Component.Acknowledged.Cyclic.ToString() : "";
        private bool IsActive => Component.State > eAxoMessengerState.Idle;
        private bool AcknowledgementRequired => true; //Component.State >= eAxoMessengerState.ActiveAckn;
        private bool AcknowledgedBeforeFallen => Component.AcknowledgedBeforeFallen.Cyclic;
        private bool AcknowledgementDoesNotRequired => !AcknowledgementRequired;
        private bool WaitingForAcknowledge => Component.State >= eAxoMessengerState.NotActiveWatingAckn;
        private bool HideAckowledgeButton => !AcknowledgementRequired || AcknowledgedBeforeFallen || (!IsActive && !WaitingForAcknowledge);

        private string GetMessageText()
        {
            ulong messageCode = Component.MessageCode.Cyclic;
            string retVal = "";

            //Just one static text defined inside the `MessageText` attribute in the PLC code is used
            if (Component.MessageCode.Cyclic == 0)
                retVal = string.IsNullOrEmpty(Component.MessageText) ? "Message text not defined!" : Component.MessageText;
            else
            {
                try
                {
                    //Several static texts defined inside the `PlcTextsList` attribute in the PLC code are used
                    if (Component.PlcMessengerTextList != null && Component.PlcMessengerTextList.Count > 0)
                    {
                        string _messageText = (from item in Component.PlcMessengerTextList where item.Key == messageCode select item.Value.MessageText.ToString()).FirstOrDefault();
                        retVal = string.IsNullOrEmpty(_messageText) ? "Message text not defined for the message code: " + messageCode.ToString() + " !" : _messageText;
                    }
                    //Message texts are written in .NET and passed into the component
                    else if (Component.DotNetMessengerTextList != null && Component.DotNetMessengerTextList.Count > 0)
                    {
                        string _messageText = (from item in Component.DotNetMessengerTextList where item.Key == messageCode select item.Value.MessageText.ToString()).FirstOrDefault();
                        retVal = string.IsNullOrEmpty(_messageText) ? "Message text not defined for the message code: " + messageCode.ToString() + " !" : _messageText;
                    }
                    else
                    {
                        retVal = "Message text not defined for the message code: " + messageCode.ToString() + " !";
                    }
                }
                catch (Exception)
                {
                    retVal = "Message text not defined for the message code: " + messageCode.ToString() + " !";
                    return retVal;
                    throw;
                }
            }
            return retVal;
        }

        private string GetHelpText()
        {
            ulong messageCode = Component.MessageCode.Cyclic;
            string retVal = "";

            //Just one static text defined inside the `Help` attribute in the PLC code is used
            if (Component.MessageCode.Cyclic == 0)
                retVal = string.IsNullOrEmpty(Component.Help) ? "Help text not defined!" : Component.Help;
            else
            {
                try
                {
                    //Several static texts defined inside the `PlcTextsList` attribute in the PLC code are used
                    if (Component.PlcMessengerTextList != null && Component.PlcMessengerTextList.Count > 0)
                    {
                        string _helpText = (from item in Component.PlcMessengerTextList where item.Key == messageCode select item.Value.HelpText.ToString()).FirstOrDefault();
                        retVal = string.IsNullOrEmpty(_helpText) ? "Help text not defined for the message code: " + messageCode.ToString() + " !" : _helpText;
                    }
                    //Message texts are written in .NET and passed into the component
                    else if (Component.DotNetMessengerTextList != null && Component.DotNetMessengerTextList.Count > 0)
                    {
                        string _helpText = (from item in Component.DotNetMessengerTextList where item.Key == messageCode select item.Value.HelpText.ToString()).FirstOrDefault();
                        retVal = string.IsNullOrEmpty(_helpText) ? "Help text not defined for the message code: " + messageCode.ToString() + " !" : _helpText;
                    }
                    else
                    {
                        retVal = "Help text not defined for the message code: " + messageCode.ToString() + " !";
                    }
                }
                catch (Exception)
                {
                    retVal = "Help text not defined for the message code: " + messageCode.ToString() + " !";
                    return retVal;
                    throw;
                }
            }
            return retVal;
        }

        private bool OnlyAlarmView { get; set; } = true;

        private void ToggleComponentView()
        {
            this.OnlyAlarmView =false;
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

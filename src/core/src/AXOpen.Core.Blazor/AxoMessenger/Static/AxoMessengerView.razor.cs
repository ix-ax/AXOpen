using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Principal;
using AXOpen.Core;
using static System.Runtime.InteropServices.JavaScript.JSType;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using AXSharp.Connector.Localizations;
using System.Globalization;


namespace AXOpen.Messaging.Static
{
    public partial class AxoMessengerView : RenderableComplexComponentBase<AxoMessenger>, IDisposable
    {
        [Inject]
        protected AuthenticationStateProvider? AuthenticationStateProvider { get; set; }

        [Parameter]
        public string? Class { get; set; }

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
            AxoApplication.Current.Logger.Information($"Message '{this.Component.GetMessageText()}' acknowledged.", this.Component, await GetCurrentUserIdentity());
        }

        private async Task RestoreParentTask()
        {
            Component.RestoreParentTask(await this.GetCurrentUserIdentity());
            AxoApplication.Current.Logger.Information($"Message '{this.Component.GetMessageText()}' restored.", this.Component, await GetCurrentUserIdentity());
        }

        private string FormatAcknowledged()
        {
            if (!Component.IsAcknowledged)
            {
                return (eAxoMessengerState)Component.MessengerState.LastValue == eAxoMessengerState.ActiveAcknowledgeRequired ? "Pending" : "Not Required";
            }

            return Component.Risen.LastValue.Equals(DateTime.MinValue)
                ? "Acknowledged"
                : FormatTimestamp(Component.Risen.LastValue);
        }

        private string FormatDuration()
        {
            if (Component.Risen.LastValue.Equals(DateTime.MinValue))
            {
                return "—";
            }

            var start = Component.Risen.LastValue;
            var end = Component.IsActive
                ? DateTime.UtcNow
                : Component.Acknowledged.LastValue;

            if (end < start)
            {
                return "—";
            }

            var duration = end - start;
            return duration switch
            {
                { TotalMinutes: < 1 } => "< 1 min",
                { TotalHours: < 1 } => $"{(int)duration.TotalMinutes} min",
                { TotalDays: < 1 } => $"{duration.TotalHours:F1} h",
                _ => $"{duration.TotalDays:F1} d"
            };
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
                            return $"{_axoComponent.GetAttributeName(CultureInfo.CurrentUICulture)} ({_axoComponent.Description_raw}) ";
                        else
                            return _axoComponent.GetAttributeName(CultureInfo.CurrentCulture);
                    }
                    else
                        return _parent.GetAttributeName(CultureInfo.CurrentUICulture);
                }

                return Component.GetAttributeName(CultureInfo.CurrentUICulture);
            }
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

using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Principal;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using System.Globalization;
using AXSharp.Connector.Localizations;

namespace AXOpen.Core
{
    public partial class AxoToggleTaskView : RenderableComplexComponentBase<AxoToggleTask>
    {

        [Inject]
        protected AuthenticationStateProvider? AuthenticationStateProvider { get; set; }

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

        private async void ToggleTask()
        {
            AxoApplication.Current.Logger.Information($"Command `{Component.HumanReadable}` toggled.", Component, await GetCurrentUserIdentity());
            Component.RemoteToggle.Cyclic = true;
        }

        public bool IsOn => Component.State.LastValue;

        private string StateDescription
        {
            get
            {
                return IsOn
                    ? (string.IsNullOrEmpty(Component.AttributeStateOnDesc) ? "<#On#>" : Component.AttributeStateOnDesc)
                    : (string.IsNullOrEmpty(Component.AttributeStateOffDesc) ? "<#Off#>" : Component.AttributeStateOffDesc);
            }
        }

        private string ButtonClass
        {
            get
            {
                if (IsDisabled)
                    return "btn-inactive";

                return IsOn ? "btn-success" : "btn-info";
            }
        }

        [Parameter]
        public bool Disable { get; set; }

        [Parameter]
        public string? Text { get; set; }

        [Parameter]
        public bool HideRestoreButton { get; set; } = false;

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic;

        public string Description => string.IsNullOrEmpty(Text)
                                     ? string.IsNullOrEmpty(Component.AttributeName)
                                     ? Component.GetSymbolTail()
                                     : Component.GetAttributeName(CultureInfo.CurrentUICulture)
                                     : Text;

        public string LabelText => $"{Description} — {StateDescription}";

        public override void ConfigurePolling()
        {
            this.StartPolling(Component.IsDisabled);
            this.StartPolling(Component.State);
        }
    }

    public class AxoToggleTaskCommandView : AxoToggleTaskView
    {
        public AxoToggleTaskCommandView()
        {
            this.Disable = false;
        }
    }

    public class AxoToggleTaskStatusView : AxoToggleTaskView
    {
        public AxoToggleTaskStatusView()
        {
            this.Disable = true;
        }
    }
}

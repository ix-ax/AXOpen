using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Principal;

namespace AXOpen.Core
{
    public partial class AxoToggleTaskView : IDisposable
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
        private string StateDescription
        {
            get
            {
                return Component.State.LastValue ? (string.IsNullOrEmpty(Component.AttributeStateOnDesc) ? "<#On#>" : Component.AttributeStateOnDesc) : (string.IsNullOrEmpty(Component.AttributeStateOffDesc) ? "<#Off#>" : Component.AttributeStateOffDesc);
            }
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component);
        }

        public void Dispose()
        {
            Component.StopPolling();
        }

        [Parameter]
        public bool Disable { get; set; }

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic;

        public string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.AttributeName;
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

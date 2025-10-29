using System.Globalization;
using System.Security.Principal;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoTaskLGView : RenderableComplexComponentBase<AxoTask>, IDisposable
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

        public eAxoTaskState State => ((eAxoTaskState)this.Component.Status.LastValue);

        public override void ConfigurePolling()
        {
            this.StartPolling(Component.Status, 250);
            this.StartPolling(Component.IsDisabled, 250);
            this.StartPolling(Component.ErrorDetails, 250);
        }

        private async void InvokeTask()
        {
            AxoApplication.Current.Logger.Information($"Command `{Component.HumanReadable}` invoked by user action.", this.Component, await GetCurrentUserIdentity());
            await Component.ExecuteAsync();
        }

        private async void RestoreTask()
        {
            AxoApplication.Current.Logger.Information($"Command `{Component.HumanReadable}` restored by user action.", Component, await GetCurrentUserIdentity());
            Component.Restore();
            (this.Component as AxoRemoteTask)?.ResetExecution();
        }

        private async void AbortTask()
        {
            AxoApplication.Current.Logger.Information($"Command `{Component.HumanReadable}` aborted by user action.", Component, await GetCurrentUserIdentity());
            Component.Abort();
        }

        private async void ResumeTask()
        {
            AxoApplication.Current.Logger.Information($"Command `{Component.HumanReadable}` resumed by user action.", Component, await GetCurrentUserIdentity());
            Component.ResumeTask();
        }

        [Parameter]
        public bool Disable { get; set; }

        [Parameter]
        public bool HideRestoreButton { get; set; }

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic;

        public string Description
        {
            get
            {
                if(!string.IsNullOrEmpty(Label))
                {
                    return Label;
                }
                return string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.GetAttributeName(CultureInfo.CurrentUICulture);
            }
        }         
    }

    public class AxoTaskCommandLGView : AxoTaskLGView
    {
        public AxoTaskCommandLGView()
        {
            this.Disable = false;
        }
    }

    public class AxoTaskStatusLGView : AxoTaskLGView
    {
        public AxoTaskStatusLGView()
        {
            this.Disable = true;
        }
    }
}

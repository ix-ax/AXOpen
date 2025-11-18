using System.Globalization;
using System.IO;
using System.Net.Http.Headers;
using System.Reflection;
using System.Security.Principal;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoTaskView : RenderableComplexComponentBase<AxoTask>, IDisposable
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

        private string AnimationClass
        {
            get
            {
                if (this.Component.IsDisabled.LastValue)
                    return "";
                switch ((eAxoTaskState)Component.Status.LastValue)
                {
                    case eAxoTaskState.Busy:
                        return "animate-pulse";
                    case eAxoTaskState.Done:
                        return "";
                    case eAxoTaskState.Aborted:
                        return "";
                    case eAxoTaskState.Error:
                        return "";
                    default:
                        return "";
                }
            }
        }
        
        private string ButtonClass
        {
            get
            {
                if(this.Component.IsDisabled.LastValue)
                    return "btn-inactive blur-[1px]";

                switch ((eAxoTaskState)Component.Status.LastValue)
                {
                    case eAxoTaskState.Busy:
                        return "btn-active shadow-xl shadow-active-500/50";
                    case eAxoTaskState.Done:
                        return "btn-success";
                    case eAxoTaskState.Aborted:
                        return "btn-attention";
                    case eAxoTaskState.Error:
                        return "btn-danger";
                    case eAxoTaskState.Ready:
                        return "btn-info";
                    default:
                        return "btn-inactive";
                }
            }
        }

        private bool IsTaskRunning => Component.Status.Cyclic == (ushort)eAxoTaskState.Busy;
        private bool IsTaskAborted => Component.Status.Cyclic == (ushort)eAxoTaskState.Aborted;

        [Parameter]
        public bool Disable { get; set; }

        [Parameter]
        public bool Enabled { get; set; } = true;

        [Parameter]
        public bool HideRestoreButton { get; set; }

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic || !Enabled;

        public string Description => string.IsNullOrEmpty(Text) ? string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.GetAttributeName(CultureInfo.CurrentUICulture) : Text;
    }

    public class AxoTaskCommandView : AxoTaskView
    {
        public AxoTaskCommandView()
        {
            this.Disable = false;
        }
    }

    public class AxoTaskStatusView : AxoTaskView
    {
        public AxoTaskStatusView()
        {
            this.Disable = true;
        }
    }
}
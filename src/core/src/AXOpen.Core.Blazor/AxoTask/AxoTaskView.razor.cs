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

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {

            var task = (AxoTask)element;
            var kids = task.GetValueTags().ToList();

            
               kids.ForEach(p =>
               {
                   p.StartPolling(pollingInterval, this);
                   PolledElements.Add(p);
               });
               
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

        private string ButtonClass
        {
            get
            {
                switch ((eAxoTaskState)Component.Status.LastValue)
                {
                    case eAxoTaskState.Done:
                        return "btn-success";
                    case eAxoTaskState.Error:
                        return "btn-danger";
                    default:
                        return "btn-primary";
                }
            } 
        }

        private bool IsTaskRunning => Component.Status.Cyclic == (ushort)eAxoTaskState.Busy;
        private bool IsTaskAborted => Component.Status.Cyclic == (ushort)eAxoTaskState.Aborted;

        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component);
        }

        [Parameter]
        public bool Disable { get; set; }

        [Parameter]
        public bool HideRestoreButton { get; set; }

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic;

        public string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.AttributeName;
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

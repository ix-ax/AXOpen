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

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            var task = (AxoTask)element;
            var kids = task.GetValueTags().ToList();

            kids.Remove(task.Identity); 
            kids.Remove(task.RemoteAbort); 
            kids.Remove(task.RemoteInvoke);
            kids.Remove(task.RemoteRestore);
            kids.Remove(task.RemoteResume);

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

        private Pocos.AXOpen.Core.AxoTask _lastPocoValue = new();

        protected override bool ShouldRender()
        {
            if (_lastPocoValue.Status != Component.Status.LastValue)
            {
                SaveLastPocoValue();
                return true;
            }

            if (_lastPocoValue.IsDisabled != IsDisabled)
            {
                SaveLastPocoValue();
                return true;
            }

            if (_lastPocoValue.StartTimeStamp != Component.StartTimeStamp.LastValue)
            {
                SaveLastPocoValue();
                return true;
            }
            if (_lastPocoValue.StartSignature != Component.StartSignature.LastValue)
            {
                SaveLastPocoValue();
                return true;
            }

            return false;
        }

        private void SaveLastPocoValue()
        {
            _lastPocoValue.Status = Component.Status.LastValue;
            _lastPocoValue.IsDisabled = IsDisabled;
            _lastPocoValue.RemoteInvoke = Component.RemoteInvoke.LastValue;
            _lastPocoValue.RemoteRestore = Component.RemoteRestore.LastValue;
            _lastPocoValue.RemoteAbort = Component.RemoteAbort.LastValue;
            _lastPocoValue.RemoteResume = Component.RemoteResume.LastValue;
            _lastPocoValue.StartSignature = Component.StartSignature.LastValue;
            _lastPocoValue.Duration = Component.Duration.LastValue;
            _lastPocoValue.StartTimeStamp = Component.StartTimeStamp.LastValue;
            _lastPocoValue.ErrorDetails = Component.ErrorDetails.LastValue;
        }

        [Parameter]
        public bool Disable { get; set; }

        [Parameter]
        public bool HideRestoreButton { get; set; }

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic;

        public string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.GetAttributeName(CultureInfo.CurrentUICulture);
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
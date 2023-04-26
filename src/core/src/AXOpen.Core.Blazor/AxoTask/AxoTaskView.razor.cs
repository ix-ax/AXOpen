using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoTaskView : IDisposable
    {
        private void InvokeTask()
        {
            Component.RemoteInvoke.Cyclic = true;
        }
        private void RestoreTask()
        {
            (this.Component as AxoRemoteTask)?.ResetExecution();
            Component.RemoteRestore.Cyclic = true;
        }
        private void AbortTask()
        {
            Component.RemoteAbort.Cyclic = true;
        }
        private void ResumeTask()
        {
            Component.RemoteResume.Cyclic = true;
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

        public void Dispose()
        {
            Component.StopPolling();
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

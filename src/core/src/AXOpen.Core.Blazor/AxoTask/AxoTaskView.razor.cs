using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoTaskView : IDisposable
    {
        private void InvokeTask()
        {
            Component.ExecuteAsync();
        }
        private void RestoreTask()
        {
            Component.Restore();
            (this.Component as AxoRemoteTask)?.ResetExecution();
        }
        private void AbortTask()
        {
            Component.Abort();
        }
        private void ResumeTask()
        {
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

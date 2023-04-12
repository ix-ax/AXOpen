using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoTaskView : IDisposable
    {
        private string description;
        private bool hideRestoreButton;
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

        private string ButtonClass = "btn-primary";
        private bool IsTaskRunning => Component.Status.Cyclic == (ushort)eAxoTaskState.Busy;
        private bool IsTaskAborted => Component.Status.Cyclic == (ushort)eAxoTaskState.Aborted;

        private void UpdateTaskColor(object sender, EventArgs e)
        {
            switch ((eAxoTaskState)Component.Status.LastValue)
            {
                case eAxoTaskState.Done:
                    ButtonClass = "btn-success";
                    break;
                case eAxoTaskState.Error:
                    ButtonClass = "btn-danger";
                    break;
                default:
                    ButtonClass = "btn-primary";
                    break;
            }
        }

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            UpdateTaskColor(this, new EventArgs());
            Component.Status.PropertyChanged += UpdateTaskColor;
        }

        public void Dispose()
        {
            Component.Status.PropertyChanged -= UpdateTaskColor;
            Component.StopPolling();
        }

        [Parameter]
        public bool IsDisabled { get; set; }

        [Parameter]
        public string Description
        {
            get
            {
                return description;
            }
            set
            {
                if (!string.IsNullOrEmpty(value)) 
                {
                    description = value;
                }
            }
               
        }

        [Parameter]
        public bool HideRestoreButton
        {
            get
            {
                return hideRestoreButton;
            }
            set
            {
                hideRestoreButton = value;
            }
        }
    }
}

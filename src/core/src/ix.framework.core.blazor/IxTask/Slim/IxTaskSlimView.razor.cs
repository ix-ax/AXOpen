using Ix.Connector;
using Microsoft.AspNetCore.Components;

namespace ix.framework.core
{
    public partial class IxTaskSlimView : IDisposable
    {
        private string description;
        private bool hideRestoreButton;
        private void InvokeTask()
        {
            Component.RemoteInvoke.Cyclic = true;
        }
        private void RestoreTask()
        {
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
        private bool IsTaskRunning => Component.Status.Cyclic == (ushort)eIxTaskState.Busy;
        private bool IsTaskAborted => Component.Status.Cyclic == (ushort)eIxTaskState.Aborted;

        protected void UpdateTaskColor(object sender, EventArgs e)
        {
            switch ((eIxTaskState)Component.Status.LastValue)
            {
                case eIxTaskState.Done:
                    ButtonClass = "btn-success";
                    break;
                case eIxTaskState.Error:
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

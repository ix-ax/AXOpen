using Ix.Connector;
using Microsoft.AspNetCore.Components;

namespace ix.framework.core
{
    public partial class IxTaskSlimView : IDisposable
    {
        private string _description;
        protected void InvokeTask()
        {
            Component.RemoteInvoke.Cyclic = true;
        }
        protected void RestoreTask()
        {
            Component.RemoteRestore.Cyclic = true;
        }
        protected void AbortTask()
        {
            Component.RemoteAbort.Cyclic = true;
        }
        protected void ResumeTask()
        {
            Component.RemoteResume.Cyclic = true;
        }

        public string ButtonClass = "btn-primary";

        public bool IsTaskRunning => Component.Status.Cyclic == (ushort)eIxTaskState.Busy;
        public bool IsTaskAborted => Component.Status.Cyclic == (ushort)eIxTaskState.Aborted;

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
                return _description;
            }
            set
            {
                if (!string.IsNullOrEmpty(value)) 
                {
                    _description = value;
                }
            }
               
        }

        private bool _hideRestoreButton;
        [Parameter]
        public bool HideRestoreButton
        {
            get
            {
                return _hideRestoreButton;
            }
            set
            {
                _hideRestoreButton = value;
            }
        }
    }
}

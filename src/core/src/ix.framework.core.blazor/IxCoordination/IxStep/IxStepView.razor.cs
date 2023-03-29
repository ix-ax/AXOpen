using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System.Reflection.Metadata.Ecma335;

namespace ix.framework.core
{
    public partial class IxStepView
    {
        private bool isControllable;

        private string RowClass = "bg-white text-dark";
        private bool IsActive => Component.IsActive.Cyclic == true;

        private string Description => string.IsNullOrEmpty(Component.Description) ? Component.StepDescription.Cyclic : Component.Description;

        private void UpdateStepRowColors(object sender, EventArgs e)
        {
            switch ((eIxTaskState)Component.Status.LastValue)
            {
                case eIxTaskState.Disabled:
                    RowClass = "bg-secondary text-white";
                    break;
                case eIxTaskState.Ready:
                    RowClass = "bg-primary text-white";
                    break;
                case eIxTaskState.Kicking:
                    RowClass = "bg-light text-dark";
                    break;
                case eIxTaskState.Busy:
                    RowClass = "bg-warning text-dark";
                    break;
                case eIxTaskState.Done:
                    RowClass = "bg-success text-white";
                    break;
                case eIxTaskState.Error:
                    RowClass = "bg-danger text-white";
                    break;
                default:
                    RowClass = "bg-white text-dark";
                    break;
            }
        }

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            UpdateStepRowColors(this, new EventArgs());
            Component.Status.PropertyChanged += UpdateStepRowColors;
        }

        public void Dispose()
        {
            Component.StopPolling();
            Component.Status.PropertyChanged -= UpdateStepRowColors;
        }

        [Parameter]
        public bool IsControllable
        {
            get
            {
                return isControllable;
            }
            set
            {
                isControllable = value;
            }
        }
    }
}

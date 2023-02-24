using Microsoft.AspNetCore.Components;
using System.Reflection.Metadata.Ecma335;

namespace ix.framework.core
{
    public partial class IxStepSlimView
    {
        private bool _isControllable;

        public string RowClass = "bg-white text-dark";
        public bool IsActive => Component.IsActive.Cyclic == true;

        protected string Description => string.IsNullOrEmpty(Component.Description) ? Component.StepDescription.Cyclic : Component.Description;

        protected void UpdateStepRowColors(object sender, EventArgs e)
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
            Component.Status.PropertyChanged -= UpdateStepRowColors;
        }

        [Parameter]
        public bool IsControllable
        {
            get
            {
                return _isControllable;
            }
            set
            {
                _isControllable = value;
            }
        }
    }
}

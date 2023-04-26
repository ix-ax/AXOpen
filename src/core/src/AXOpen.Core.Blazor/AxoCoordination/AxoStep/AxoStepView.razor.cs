using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System.Reflection.Metadata.Ecma335;

namespace AXOpen.Core
{
    public partial class AxoStepView
    {
        private string RowClass => UpdateStepRowColors();

        private bool IsActive => Component.IsActive.Cyclic == true;

        private string Description => string.IsNullOrEmpty(Component.StepDescription.Cyclic) ? Component.Description : Component.StepDescription.Cyclic;

        private string UpdateStepRowColors()
        {
            switch ((eAxoTaskState)Component.Status.Cyclic)
            {
                case eAxoTaskState.Disabled:
                    return "bg-secondary text-white";
                case eAxoTaskState.Ready:
                    return"bg-primary text-white";
                case eAxoTaskState.Kicking:
                    return "bg-light text-dark";
                case eAxoTaskState.Busy:
                    return "bg-warning text-dark";
                case eAxoTaskState.Done:
                    return "bg-success text-white";
                case eAxoTaskState.Error:
                    return "bg-danger text-white";
                default:
                    return "bg-white text-dark";
            }
        }

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            UpdateStepRowColors();
        }

        [Parameter]
        public bool IsControllable { get; set; }
    }

    public class AxoStepCommandView : AxoStepView
    {
        public AxoStepCommandView()
        {
            IsControllable = true;
        }
    }

    public class AxoStepStatusView : AxoStepView
    {
        public AxoStepStatusView()
        {
            IsControllable = false;
        }
    }
}

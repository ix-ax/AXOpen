using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System.ComponentModel;
using System.Reflection.Metadata.Ecma335;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoStepView : RenderableComplexComponentBase<AxoStep>
    {
        private bool IsActive => Component.IsActive.Cyclic == true;

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component,350);
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

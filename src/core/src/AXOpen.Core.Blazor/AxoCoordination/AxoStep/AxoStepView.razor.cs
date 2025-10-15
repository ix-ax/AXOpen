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

        [Parameter] public string? Class { get; set; }

        [Parameter]
        public bool IsControllable { get; set; }

        public override void ConfigurePolling()
        {
            this.StartPolling(Component.Descr, 750);
            this.StartPolling(Component.Status, 750);
            this.StartPolling(Component.Duration, 750);
        }
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

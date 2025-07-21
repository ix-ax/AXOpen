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

        [Parameter]
        public bool IsControllable { get; set; }

        public override void ConfigurePolling()
        {
            this.StartPolling(Component.Descr, 350);
            this.StartPolling(Component.Status, 350);
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

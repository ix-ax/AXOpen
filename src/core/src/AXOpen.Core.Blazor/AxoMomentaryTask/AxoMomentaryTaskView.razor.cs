using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoMomentaryTaskView : RenderableComplexComponentBase<AxoMomentaryTask>
    {
        private void SwitchOnTask()
        {
            Component.RemoteSwitchOn.Cyclic = true;
        }
        private void SwitchOffTask()
        {
            Component.RemoteSwitchOn.Cyclic = false;
        }
        private string StateDescription
        {
            get
            {
                return Component.State.LastValue ? (string.IsNullOrEmpty(Component.AttributeStateOnDesc) ? "<#On#>" : Component.AttributeStateOnDesc) : (string.IsNullOrEmpty(Component.AttributeStateOffDesc) ? "<#Off#>" : Component.AttributeStateOffDesc);
            }
        }

        [Parameter]
        public bool Disable { get; set; }

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic;

        public string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.AttributeName;
        public override void ConfigurePolling()
        {
            StartPolling(Component.IsDisabled, 500);
            StartPolling(Component.State, 500);
        }
    }

    public class AxoMomentaryTaskCommandView : AxoMomentaryTaskView
    {
        public AxoMomentaryTaskCommandView()
        {
            this.Disable = false;
        }
    }

    public class AxoMomentaryTaskStatusView : AxoMomentaryTaskView
    {
        public AxoMomentaryTaskStatusView()
        {
            this.Disable = true;
        }
    }
}

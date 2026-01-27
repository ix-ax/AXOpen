using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using System.Globalization;
using AXSharp.Connector.Localizations;

namespace AXOpen.Core
{
    public partial class AxoMomentaryTaskView : RenderableComplexComponentBase<AxoMomentaryTask>
    {
        [Parameter]
        public bool Disable { get; set; }

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic;

        private void SwitchOnTask()
        {
            Component.RemoteSwitchOn.Cyclic = true;
        }
        private void SwitchOffTask()
        {
            Component.RemoteSwitchOn.Cyclic = false;
        }
        private string StateDescription => Component.State.LastValue ? (string.IsNullOrEmpty(Component.AttributeStateOnDesc) ? "<#On#>" : Component.AttributeStateOnDesc) : (string.IsNullOrEmpty(Component.AttributeStateOffDesc) ? "<#Off#>" : Component.AttributeStateOffDesc);

        public string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.Translate(Component.AttributeName, CultureInfo.CurrentUICulture);
        
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

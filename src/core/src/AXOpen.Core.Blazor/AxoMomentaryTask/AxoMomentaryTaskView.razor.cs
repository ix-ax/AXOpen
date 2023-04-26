using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoMomentaryTaskView : IDisposable
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

        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component);
        }

        public void Dispose()
        {
            Component.StopPolling();
            Component.RemoteSwitchOn.Cyclic = false;
        }

        [Parameter]
        public bool Disable { get; set; }

        public bool IsDisabled => Disable || Component.IsDisabled.Cyclic;

        public string Description => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.AttributeName;
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

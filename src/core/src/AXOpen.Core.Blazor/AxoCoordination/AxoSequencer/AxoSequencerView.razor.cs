using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoSequencerView : IDisposable
    {
        public IEnumerable<AxoStep?> Steps => Component.GetKids().OfType<AxoStep>();

        [Parameter]
        public bool IsControllable { get; set; }

        [Parameter] public bool HasSettings { get; set; } = true;

        [Parameter] public bool HasStepControls { get; set; } = true;

        [Parameter] public bool HasStepDetails { get; set; } = true;

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
        }

        public void Dispose()
        {
            Component.StopPolling();
        }
    }
}

using System.ComponentModel;
using System.Runtime.CompilerServices;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoSequencerContainerView  
    {
        public IEnumerable<AxoStep?> Steps => Component.GetKids().OfType<AxoStep>();

        [Parameter] public bool IsControllable { get; set; } = true;

        [Parameter] public bool HasTaskControlButton { get; set; } = true;

        [Parameter] public bool HasSettings { get; set; } = true;

        [Parameter] public bool HasStepControls { get; set; } = true;

        [Parameter] public bool HasStepDetails { get; set; } = true;

        protected override void OnInitialized()
        {
            base.OnInitialized();
            this.UpdateValuesOnChange(Component);
        }
    }

    public class AxoSequencerContainerCommandView : AxoSequencerContainerView
    {
        public AxoSequencerContainerCommandView()
        {
            IsControllable = true;
        }
    }

    public class AxoSequencerContainerStatusView : AxoSequencerContainerView
    {
        public AxoSequencerContainerStatusView()
        {
            IsControllable = false;
        }
    }
}

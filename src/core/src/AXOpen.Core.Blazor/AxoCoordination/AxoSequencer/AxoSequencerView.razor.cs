using System.ComponentModel;
using System.Runtime.CompilerServices;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoSequencerView  
    {
        public IEnumerable<AxoStep?> Steps => Component.GetKids().OfType<AxoStep>();

        [Parameter] public bool IsControllable { get; set; } = true;

        [Parameter] public bool HasTaskControlButton { get; set; } = false;

        [Parameter] public bool HasSettings { get; set; } = true;

        [Parameter] public bool HasStepControls { get; set; } = true;

        [Parameter] public bool HasStepDetails { get; set; } = true;

        protected override void OnInitialized()
        {
            base.OnInitialized();
            this.UpdateValuesOnChange(Component);
        }
    }

    public class AxoSequencerCommandView : AxoSequencerView
    {
        public AxoSequencerCommandView()
        {
            IsControllable = true;
        }
    }

    public class AxoSequencerStatusView : AxoSequencerView
    {
        public AxoSequencerStatusView()
        {
            IsControllable = false;
        }
    }
}

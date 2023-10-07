using System.ComponentModel;
using System.Runtime.CompilerServices;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using AXOpen.Core;

namespace AXOpen.Core
{
    public partial class AxoSequencerView : RenderableComplexComponentBase<AxoSequencer>, IDisposable
    {
        public IEnumerable<AxoStep> Steps => Component.GetKids().OfType<AxoStep>();

        [Parameter] public bool IsControllable { get; set; } = true;

        [Parameter] public bool HasTaskControlButton { get; set; } = true;

        [Parameter] public bool HasSettings { get; set; } = true;

        [Parameter] public bool HasStepControls { get; set; } = true;

        [Parameter] public bool HasStepDetails { get; set; } = true;

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            var sequencer = (AxoSequencer)element;
            var firstLevelPrimitives = sequencer.GetValueTags().ToList();

            firstLevelPrimitives.ForEach(p =>
            {
                p.StartPolling(pollingInterval, this);
                PolledElements.Add(p);
            });
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            this.UpdateValuesOnChange(Component);
        }

        private void RefreshComponent()
        {
            Component.ReadAsync();
        }

        private ElementReference activeStepReference { get; set; }
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

using System.ComponentModel;
using System.Runtime.CompilerServices;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{
    public partial class AxoSequencerView
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

        private string Description(AxoStep step)
        {
            var text = string.IsNullOrEmpty(step.StepDescription.Cyclic)
                ? step.Order.Cyclic.ToString()
                : step.StepDescription.Cyclic;

            if (step.IsActive.Cyclic)
            {
                return $">> {text} <<";
            }

            return text;
        }

        private string StepRowColor(AxoStep step)
        {
            switch ((eAxoTaskState)step.Status.Cyclic)
            {
                case eAxoTaskState.Disabled:
                    return "bg-secondary text-white";
                case eAxoTaskState.Ready:
                    return "bg-primary text-white";
                case eAxoTaskState.Kicking:
                    return "bg-light text-dark";
                case eAxoTaskState.Busy:
                    return "bg-warning text-dark";
                case eAxoTaskState.Done:
                    return "bg-success text-white";
                case eAxoTaskState.Error:
                    return "bg-danger text-white";
                default:
                    return "bg-white text-dark";
            }
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

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
        public IEnumerable<AxoStep> AllAxoStepInstances => Component.GetKids().OfType<AxoStep>();

        private List<AxoStep> _AllSteps;
        public List<AxoStep> AllSteps
        {
            get
            {
                if (_AllSteps == null)
                {
                    _AllSteps = new List<AxoStep>();

                    _AllSteps.AddRange(AllAxoStepInstances);
                    _AllSteps.Remove(this.Component.CurrentStep);
                    _AllSteps.Remove(this.Component.BeforeStep);
                    _AllSteps.Remove(this.Component.AfterStep);

                }

                return _AllSteps;
            }

        }

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

        private async void RefreshStepsInSequnce()
        {
            // read out steps order numbers
            await Component.GetConnector().ReadBatchAsync(AllSteps.GetStepsOrderElements());

            List<ITwinPrimitive> activeProperties = new();
            foreach (AxoStep activeStep in AllSteps.Where(p => p != null && p.Order.Cyclic != 0))
            {
                activeStep.GetPrimitivesDescriptionErrorDetails(activeProperties);
                activeStep.GetPrimitivesDurationStatus(activeProperties);
            }

            if (activeProperties.Count > 0)
            {
                await Component.GetConnector().ReadBatchAsync(activeProperties);
            }
        } 
        
        private async void RefreshDurationAndStatus()
        {
            List<ITwinPrimitive> activeProperties = new();
            foreach (AxoStep activeStep in AllSteps.Where(p => p != null && p.Order.Cyclic != 0))
            {
                activeStep.GetPrimitivesDurationStatus(activeProperties);
            }

            if (activeProperties.Count > 0)
            {
                await Component.GetConnector().ReadBatchAsync(activeProperties);
            }
        }

        public bool EnableModalContent { set; get; }

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

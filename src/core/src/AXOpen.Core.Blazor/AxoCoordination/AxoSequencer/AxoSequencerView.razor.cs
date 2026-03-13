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
        [Parameter]
        public bool IsControllable { get; set; } = true;

        [Parameter]
        public bool HasExternalStepModeControl { get; set; } = false;

        private string _description => string.IsNullOrEmpty(this.Component.CurrentStep.Descr.GetCyclic()) ? "-" : this.Component.CurrentStep.Descr.GetCyclic();

        private string _duration => this.Component.Duration.GetCyclic().ToString(@"hh\:mm\:ss\.fff");

        private eAxoSteppingMode _currentSteppingMode => (eAxoSteppingMode)this.Component.SteppingMode.LastValue;

        private async Task ToggleStepMode()
        {
            var currentSteppingMode = (eAxoSteppingMode)this.Component.SteppingMode.LastValue;

            if (currentSteppingMode == eAxoSteppingMode.Continous)
            {
                await this.Component.SetReqSteppingMode.SetAsync(true);
                await this.Component.ReqSteppingMode.SetAsync((short)eAxoSteppingMode.StepByStep);
            }
            else
            {
                await this.Component.SetReqSteppingMode.SetAsync(true);
                await this.Component.ReqSteppingMode.SetAsync((short)eAxoSteppingMode.Continous);
            }
        }

        private string _runStepButtonText => string.IsNullOrEmpty(this.Component.CurrentStep.Descr.GetCyclic(Thread.CurrentThread.CurrentUICulture)) ? "-" : this.Component.CurrentStep.Descr.GetCyclic(Thread.CurrentThread.CurrentUICulture);

        private IEnumerable<AxoObject> _associatedComponents => this.Component.Associates.Where(p => p is AxoObject).Cast<AxoObject>();


        private eSequenceStatus _currentStatus
        {
            get
            {
                var taskState = (eAxoTaskState)this.Component.Status.LastValue;

                if (taskState == eAxoTaskState.Error)
                {
                    return eSequenceStatus.SequencerError;
                }

                if (_associatedComponents.Any(p => p.MsgCnt.LastValue > 0)
                    && this.Component.Duration.LastValue > TimeSpan.FromSeconds(this.Component.MaxSequenceDuration.LastValue.TotalSeconds))
                {
                    return eSequenceStatus.ExternalComponentError;
                }

                if (this.Component.Duration.LastValue >
                TimeSpan.FromSeconds(this.Component.MaxSequenceDuration.LastValue.TotalSeconds)
                && this.Component.Duration.LastValue > TimeSpan.FromSeconds(10))
                {
                    return eSequenceStatus.SequenceTimeOutError;
                }

                if (taskState == eAxoTaskState.Busy)
                {
                    return eSequenceStatus.Active;
                }

                return eSequenceStatus.Inactive;
            }
        }

        public override void ConfigurePolling()
        {
            this.StartPolling(this.Component.CurrentStep.Descr, 500);
            this.StartPolling(this.Component.SteppingMode, 500);
            this.StartPolling(this.Component.Duration, 1000);
            this.StartPolling(this.Component.MsgCnt, 2500);
            foreach (var a in _associatedComponents)
            {
                this.StartPolling(a.MsgCnt, 2500);
            }
            this.StartPolling(Component.MaxSequenceDuration, 1000);
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

    public enum eSequenceStatus
    {
        Inactive,
        Active,
        SequencerError,
        SequenceTimeOutError,
        ExternalComponentError,
    }
}

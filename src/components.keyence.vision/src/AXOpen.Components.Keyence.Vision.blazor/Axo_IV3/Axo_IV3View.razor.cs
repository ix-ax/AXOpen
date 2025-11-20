using AXOpen.Components.Keyence.Vision;
using AXOpen.Core;
using AXOpen.Core.Blazor;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXOpen.VisualComposer.Components.VisualComposerItem;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
#pragma warning disable CS1591

namespace AXOpen.Components.Keyence.Vision
{
    public partial class Axo_IV3View : AxoComponentViewBase<Axo_IV3>
    {

        private string GetLiveViewUrl => $"http://{Component.DeviceIpAddress}/iv3-wm-i.html";
        protected bool IsReady => Component.Inputs.CommandStatusBits.Ready.Cyclic;
        protected bool IsBusy => Component.Inputs.CommandStatusBits.BUSY.Cyclic;
        protected bool IsImaging => Component.Inputs.CommandStatusBits.ImagingStatus.Cyclic;
        protected bool TriggerReady => Component.Inputs.CommandStatusBits.TriggerReady.Cyclic;
        protected bool HasResult => Component.Inputs.CommandStatusBits.ResultAvailable.Cyclic;
        protected bool HasWarning => Component.Inputs.CommandStatusBits.Warning.Cyclic;
        protected bool HasError => Component.Inputs.CommandStatusBits.Error.Cyclic;
        protected bool LastResultOk => Component.Inputs.DeviceResultBits_1.OverallJudgmentOK.Cyclic;
        protected bool LastResultNg => Component.Inputs.DeviceResultBits_1.OverallJudgmentNG.Cyclic;
        protected bool IsScanning => IsBusy || IsImaging || IsScanningTaskActive;

        protected string StatusText => IsBusy ? "BUSY" : IsReady ? "READY" : "IDLE";
        protected string AlertText => HasError ? "ERROR" : HasWarning ? "WARNING" : "STABLE";

        protected int CurrentProgramNumber => Component.Inputs.DeviceStatusWords.CurrentProgramNo.Cyclic;
        protected int ProgressPercentage => Math.Clamp((int)Component.Progress.Cyclic, 0, 100);             

        /// <inheritdoc />
        public override async void ConfigurePolling()
        {
            StartPolling(Component.Progress);
            StartPolling(Component.RequiredProgramNumber);

            StartPolling(Component.TriggerTask.Status);
            StartPolling(Component.ChangeProgramTask.Status);
            StartPolling(Component.RestoreTask.Status);
            StartPolling(Component.HardwareDiagnosticsTask.Status);

            StartPolling(Component.Inputs.CommandStatusBits.BUSY);
            StartPolling(Component.Inputs.CommandStatusBits.Ready);
            StartPolling(Component.Inputs.CommandStatusBits.ImagingStatus);
            StartPolling(Component.Inputs.CommandStatusBits.TriggerReady);
            StartPolling(Component.Inputs.CommandStatusBits.ResultAvailable);
            StartPolling(Component.Inputs.CommandStatusBits.Warning);
            StartPolling(Component.Inputs.CommandStatusBits.Error);

            StartPolling(Component.Inputs.DeviceResultBits_1.OverallJudgmentOK);
            StartPolling(Component.Inputs.DeviceResultBits_1.OverallJudgmentNG);

            StartPolling(Component.Inputs.DeviceStatusWords.CurrentProgramNo);
            StartPolling(Component.Inputs.DeviceStatusWords.ProgramNoDuringJudgment);
            StartPolling(Component.Inputs.DeviceStatusWords.ResultNo);
            StartPolling(Component.Inputs.DeviceStatusWords.ProcessingTime);

            StartPolling(Component.Inputs.DeviceStatistics.NumberOfTriggers, 750);
            StartPolling(Component.Inputs.DeviceStatistics.NumberOfOKs, 750);
            StartPolling(Component.Inputs.DeviceStatistics.NumberOfNGs, 750);
            StartPolling(Component.Inputs.DeviceStatistics.NumberOfTriggerErrors, 750);
            StartPolling(Component.Inputs.DeviceStatistics.ProcessingTimeMax, 750);
            StartPolling(Component.Inputs.DeviceStatistics.ProcessingTimeMin, 750);
            StartPolling(Component._isManuallyControllable, 500);
            
            foreach (var templateTask in TemplateTasks)
            {
                StartPolling(templateTask.Task.Status);
            }           
        }

        /// <summary>
        /// Returns a badge class representing the provided state and visual variant.
        /// </summary>
        protected string GetStatusChipClass(bool state, string variant) =>
            state
                ? variant switch
                {
                    "success" => "badge badge-success",
                    "busy" => "badge badge-info",
                    "primary" => "badge badge-primary",
                    "warning" => "badge badge-warning",
                    "error" => "badge badge-danger animate-pulse-danger",
                    "info" => "badge badge-primary",
                    _ => "badge badge-primary"
                }
                : "badge badge-outline text-text/60";

        /// <summary>
        /// Formats processing time values with an ms suffix.
        /// </summary>
        protected string FormatProcessingTime(uint value) => string.Format(CultureInfo.InvariantCulture, "{0} ms", value);

        /// <summary>
        /// Formats large counters using thousands separators.
        /// </summary>
        protected string FormatNumber(ulong value) => string.Format(CultureInfo.InvariantCulture, "{0:N0}", value);

        /// <summary>
        /// Indicates whether the trigger task is currently executing or faulted.
        /// </summary>
        protected bool IsScanningTaskActive
        {
            get
            {
                var taskState = (eAxoTaskState)Component.TriggerTask.Status.LastValue;
                return taskState == eAxoTaskState.Busy || taskState == eAxoTaskState.Error;
            }
        }

        /// <summary>
        /// Describes the set of optional template tasks exposed by the PLC component.
        /// </summary>
        protected IEnumerable<(string Label, AxoTask Task)> TemplateTasks => new List<(string, AxoTask)>
        {
            ("10 steps · 3", Component.TemplateTask_10steps_3),
            ("10 steps · 4", Component.TemplateTask_10steps_4),
            ("10 steps · 5", Component.TemplateTask_10steps_5),
            ("10 steps · 6", Component.TemplateTask_10steps_6),
            ("20 steps · 1", Component.TemplateTask_20steps_1),
            ("20 steps · 2", Component.TemplateTask_20steps_2),
            ("20 steps · 3", Component.TemplateTask_20steps_3),
            ("20 steps · 4", Component.TemplateTask_20steps_4),
            ("20 steps · 5", Component.TemplateTask_20steps_5),
            ("20 steps · 6", Component.TemplateTask_20steps_6)
        };
    }

    public class Axo_IV3StatusView : Axo_IV3View
    {
        public Axo_IV3StatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class Axo_IV3CommandView : Axo_IV3View
    {
        public Axo_IV3CommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class Axo_IV3SpotView : Axo_IV3View
    {
        public Axo_IV3SpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}
#pragma warning restore CS1591

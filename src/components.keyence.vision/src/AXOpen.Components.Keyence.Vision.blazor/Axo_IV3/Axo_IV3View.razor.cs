using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using AXOpen.Components.Keyence.Vision;
using AXOpen.Core;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXOpen.VisualComposer.Components.VisualComposerItem;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
#pragma warning disable CS1591

namespace AXOpen.Components.Keyence.Vision
{
    public partial class Axo_IV3View : RenderableComplexComponentBase<Axo_IV3>
    {
        public enum eDisplayMode
        {
            Spot,
            Basic,
            Advanced,
            Raw
        }

        [Parameter]
        public eDisplayMode DisplayMode { get; set; } = eDisplayMode.Spot;

        private bool ShowAnimationPanel { get; set; } = true;

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

        private bool ShowMessages { get; set; }
        private AxoMessageProvider? _messageProvider { get; set; }
        private int _previousAlarmCount { get; set; }

        private bool HasActiveMessages => _alarmCount > 0;
        private int _alarmCount => _messageProvider?.Messengers?.Count(a => a.State != eAxoMessengerState.Idle) ?? 0;
        private int ActiveAlarmCount => _alarmCount;

        private eAlarmLevel _alarmLevel
        {
            get
            {
                var messengers = _messageProvider?.Messengers;
                if (messengers == null)
                {
                    return eAlarmLevel.NoAlarms;
                }

                if (messengers.Any(p => p.State > eAxoMessengerState.Idle))
                {
                    var seriousness = (eAxoMessageCategory)messengers.Max(p => p.Category.LastValue);

                    return seriousness switch
                    {
                        eAxoMessageCategory.Info => eAlarmLevel.ActiveInfo,
                        eAxoMessageCategory.Warning => eAlarmLevel.ActiveWarnings,
                        eAxoMessageCategory.Error or eAxoMessageCategory.ProgrammingError or eAxoMessageCategory.Critical => eAlarmLevel.ActiveErrors,
                        _ => eAlarmLevel.NoAlarms
                    };
                }

                if (messengers.Any(p => p.State > eAxoMessengerState.InactiveWaitingForAcknowledge))
                {
                    return eAlarmLevel.Unacknowledged;
                }

                return eAlarmLevel.NoAlarms;
            }
        }

        private string AlarmBadgeClass =>
            _alarmLevel switch
            {
                eAlarmLevel.ActiveErrors => "animate-pulse-danger badge-danger",
                eAlarmLevel.ActiveWarnings => "badge-warning",
                eAlarmLevel.ActiveInfo => "badge-primary",
                eAlarmLevel.Unacknowledged => "badge-warning",
                _ => "badge-primary"
            };

        private string AlarmBorderClass =>
            _alarmLevel switch
            {
                eAlarmLevel.NoAlarms => string.Empty,
                eAlarmLevel.Unacknowledged => "border-warning",
                eAlarmLevel.ActiveInfo => "border-info",
                eAlarmLevel.ActiveWarnings => "border-warning/20! shadow-glow-warning",
                eAlarmLevel.ActiveErrors => "border-danger/20! shadow-glow-danger",
                _ => string.Empty
            };

        private string AlarmBackgroundClass =>
            _alarmLevel switch
            {
                eAlarmLevel.NoAlarms => string.Empty,
                eAlarmLevel.Unacknowledged => "bg-warning",
                eAlarmLevel.ActiveInfo => "bg-info",
                eAlarmLevel.ActiveWarnings => "bg-warning/20! shadow-glow-warning",
                eAlarmLevel.ActiveErrors => "bg-danger/20! shadow-glow-danger",
                _ => string.Empty
            };

        private void ToggleMessages() => ShowMessages = !ShowMessages;

        private void ToggleSpotMode()
        {
            if (GetVisualItemContainer() == null)
            {
                DisplayMode = DisplayMode == eDisplayMode.Spot ? eDisplayMode.Advanced : eDisplayMode.Spot;
            }
        }

        private void ToggleAdvancedMode() => DisplayMode = DisplayMode == eDisplayMode.Advanced ? eDisplayMode.Basic : eDisplayMode.Advanced;

        private void ToggleServiceView() => DisplayMode = DisplayMode == eDisplayMode.Raw ? eDisplayMode.Basic : eDisplayMode.Raw;

        protected override void OnInitialized()
        {
            base.OnInitialized();
            _messageProvider = AxoMessageProvider.Create(new ITwinObject[] { Component });
        }

        protected override void OnAfterRender(bool firstRender)
        {
            base.OnAfterRender(firstRender);

            if (_previousAlarmCount > 0 && _alarmCount == 0 && ShowMessages)
            {
                ShowMessages = false;
                StateHasChanged();
            }

            _previousAlarmCount = _alarmCount;
        }

        private int? OriginalZIndex;

        private void BringToForeGround()
        {
            var visualItem = GetVisualItemContainer();
            if (visualItem?.Origin != null)
            {
                var container = visualItem.Parent;
                if (container != null && !container.IsDesign)
                {
                    OriginalZIndex = visualItem.Origin.ZIndex;
                    visualItem.Origin.ZIndex = int.MaxValue;
                }
            }
        }

        private void BringToZIndexBack()
        {
            var visualItem = GetVisualItemContainer();
            if (visualItem?.Origin != null && OriginalZIndex != null)
            {
                var container = visualItem.Parent;
                if (container != null && !container.IsDesign)
                {
                    visualItem.Origin.ZIndex = OriginalZIndex.Value;
                    OriginalZIndex = null;
                }
            }
        }

        private VisualComposerItem? GetVisualItemContainer()
        {
            var rcc = RccContainer as RenderableContentControl;
            var retVal = rcc?.ParentContainer as VisualComposerItem;
            return retVal;
        }

        protected async Task OpenDetails(string presentationType = "Status-Display")
        {
            if (RccContainer is RenderableContentControl rccContainer)
            {
                if (rccContainer.ParentContainer is VisualComposerItem composerItem)
                {
                    if (!composerItem.InDesign)
                    {
                        if (composerItem.Parent is { } parent)
                        {
                            await parent.OpenDetails(Component, presentationType);
                        }
                    }
                }
            }
        }

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

            if (_messageProvider != null)
            {
                await _messageProvider.InitializeUpdate(StartPolling);
            }

            if (Component.Messenger != null)
            {
                StartPolling(Component.Messenger.MessengerState, 1500);
            }

            if (Component.TaskMessenger != null)
            {
                StartPolling(Component.TaskMessenger.MessengerState, 1500);
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

    /// <summary>
    /// Read-only view variant pinned to advanced mode.
    /// </summary>
    public class Axo_IV3StatusView : Axo_IV3View
    {
        /// <summary>
        /// Initializes the status view with the advanced layout.
        /// </summary>
        public Axo_IV3StatusView()
        {
            DisplayMode = eDisplayMode.Advanced;
        }
    }

    /// <summary>
    /// Command-capable view variant pinned to advanced mode.
    /// </summary>
    public class Axo_IV3CommandView : Axo_IV3View
    {
        /// <summary>
        /// Initializes the command view with the advanced layout.
        /// </summary>
        public Axo_IV3CommandView()
        {
            DisplayMode = eDisplayMode.Advanced;
        }
    }

    /// <summary>
    /// Compact visualization variant used in dashboards.
    /// </summary>
    public class Axo_IV3SpotView : Axo_IV3View
    {
        /// <summary>
        /// Initializes the spot view with the spot layout.
        /// </summary>
        public Axo_IV3SpotView()
        {
            DisplayMode = eDisplayMode.Spot;
        }
    }
}
#pragma warning restore CS1591

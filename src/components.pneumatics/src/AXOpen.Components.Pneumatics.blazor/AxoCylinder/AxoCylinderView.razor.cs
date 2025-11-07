using AXOpen.Core;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Components.Pneumatics
{
    public partial class AxoCylinderView : RenderableComplexComponentBase<AxoCylinder>
    {
        [Parameter]
        public bool EnableControls { get; set; } = true;

        [Parameter]
        public bool ShowAnimation { get; set; } = true;

        private bool ShowAnimationPanel { get; set; } = false;
        private bool ShowServiceView { get; set; } = false;

        protected bool IsInInnerPosition => Component._InSensor.Cyclic && !Component._OutSensor.Cyclic;
        protected bool IsInOuterPosition => Component._OutSensor.Cyclic && !Component._InSensor.Cyclic;
        protected bool IsMoving => Component._MoveInSignal.Cyclic || Component._MoveOutSignal.Cyclic;

        private bool ShowMessages { get; set; } = false;
        private AxoMessageProvider? _messageProvider { get; set; }
        private int _previousAlarmCount { get; set; } = 0;

        private bool HasActiveMessages => _alarmCount > 0;

        private int _alarmCount => _messageProvider?.Messengers.Count(a => a.State != eAxoMessengerState.Idle) ?? 0;

        private int ActiveAlarmCount => _alarmCount;

        private eAlarmLevel _alarmLevel
        {
            get
            {
                var messengers = _messageProvider?.Messengers;
                if (messengers == null) return eAlarmLevel.NoAlarms;

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
                else if (messengers.Any(p => p.State > eAxoMessengerState.InactiveWaitingForAcknowledge))
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
                eAlarmLevel.NoAlarms => "",
                eAlarmLevel.Unacknowledged => "border-warning",
                eAlarmLevel.ActiveInfo => "border-info",
                eAlarmLevel.ActiveWarnings => "border-warning/20! shadow-glow-warning",
                eAlarmLevel.ActiveErrors => "border-danger/20! shadow-glow-danger",
                _ => ""
            };

        private void ToggleMessages()
        {
            ShowMessages = !ShowMessages;
        }

        private void ToggleAnimation()
        {
            ShowAnimationPanel = !ShowAnimationPanel;
        }

        private void ToggleServiceView()
        {
            ShowServiceView = !ShowServiceView;
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            _messageProvider = AxoMessageProvider.Create(new ITwinObject[] { this.Component });
        }

        protected override void OnAfterRender(bool firstRender)
        {
            base.OnAfterRender(firstRender);

            // Auto-collapse alarm panel when all alarms are cleared
            if (_previousAlarmCount > 0 && _alarmCount == 0 && ShowMessages)
            {
                ShowMessages = false;
                StateHasChanged();
            }

            _previousAlarmCount = _alarmCount;
        }

        public override void ConfigurePolling()
        {
            // Poll sensor states
            this.StartPolling(Component._InSensor);
            this.StartPolling(Component._OutSensor);

            // Poll signal states
            this.StartPolling(Component._MoveInSignal);
            this.StartPolling(Component._MoveOutSignal);

            // Poll task statuses
            this.StartPolling(Component._MoveOutTask.Status);
            this.StartPolling(Component._MoveInTask.Status);
            this.StartPolling(Component._StopTask.Status);

            // Poll messenger state
            if (Component._Messenger != null)
            {
                this.StartPolling(Component._Messenger.MessengerState, 1500);
            }
        }
    }
}

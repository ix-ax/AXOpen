using AXOpen.Core;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXOpen.VisualComposer.Components.VisualComposerItem;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Components.Pneumatics
{
    public partial class AxoCylinderView : RenderableComplexComponentBase<AxoCylinder>
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

        private bool ShowAnimationPanel { get; set; } = false;
        private bool ShowServiceView { get; set; } = false;
        protected bool EnableControls { get; set; } = true;
        protected bool ShowAnimation { get; set; } = true;

        protected bool IsInInnerPosition => Component.InSensor.Cyclic && !Component.OutSensor.Cyclic;
        protected bool IsInOuterPosition => Component.OutSensor.Cyclic && !Component.InSensor.Cyclic;
        protected bool IsMoving => Component.MoveInSignal.Cyclic || Component.MoveOutSignal.Cyclic;

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

        private string AlarmBackgroundClass =>
           _alarmLevel switch
           {
               eAlarmLevel.NoAlarms => "",
               eAlarmLevel.Unacknowledged => "bg-warning",
               eAlarmLevel.ActiveInfo => "bg-info",
               eAlarmLevel.ActiveWarnings => "bg-warning/20! shadow-glow-warning",
               eAlarmLevel.ActiveErrors => "bg-danger/20! shadow-glow-danger",
               _ => ""
           };

        private void ToggleMessages()
        {
            ShowMessages = !ShowMessages;
        }

        private void ToggleSpotMode()
        {
            if (this.GetVisualItemContainer() == null)
            {
                this.DisplayMode = this.DisplayMode == eDisplayMode.Spot ? eDisplayMode.Advanced : eDisplayMode.Spot;
            }
        }

        private void ToggleAdvancedMode()
        {
            this.DisplayMode = this.DisplayMode == eDisplayMode.Advanced ? eDisplayMode.Basic : eDisplayMode.Advanced;
        }

        private void ToggleServiceView()
        {
            this.DisplayMode = this.DisplayMode == eDisplayMode.Raw ? eDisplayMode.Basic : eDisplayMode.Raw;
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

        // Z-Index management for Visual Composer
        private int? OriginalZIndex;

        /// <summary>
        /// Brings the component to the foreground by setting z-index to maximum.
        /// Called on mouse enter.
        /// </summary>
        private void BringToForeGround()
        {
            var visualItem = GetVisualItemContainer();
            if (visualItem?.Origin != null)
            {
                var container = visualItem?.Parent;
                if (container != null && !container.IsDesign)
                {
                    OriginalZIndex = visualItem.Origin.ZIndex;
                    visualItem.Origin.ZIndex = int.MaxValue;
                }
            }
        }

        /// <summary>
        /// Restores the original z-index of the component.
        /// Called on mouse leave.
        /// </summary>
        private void BringToZIndexBack()
        {
            var visualItem = GetVisualItemContainer();
            if (visualItem?.Origin != null && OriginalZIndex != null)
            {
                var container = visualItem?.Parent;
                if (container != null && !container.IsDesign)
                {
                    visualItem.Origin.ZIndex = OriginalZIndex.Value;
                    OriginalZIndex = null;
                }
            }
        }

        /// <summary>
        /// Gets the Visual Composer container item if the component is rendered inside Visual Composer.
        /// </summary>
        private VisualComposerItem? GetVisualItemContainer()
        {
            var rcc = this.RccContainer as RenderableContentControl;
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
                        composerItem.Parent.OpenDetails(this.Component, presentationType); // Updated to use presentationType                        
                    }
                }
            }
        }

        public override async void ConfigurePolling()
        {
            // Poll sensor states
            this.StartPolling(Component.InSensor);
            this.StartPolling(Component.OutSensor);

            // Poll signal states
            this.StartPolling(Component.MoveInSignal);
            this.StartPolling(Component.MoveOutSignal);

            // Poll task statuses
            this.StartPolling(Component._MoveOutTask.Status);
            this.StartPolling(Component._MoveInTask.Status);
            this.StartPolling(Component._StopTask.Status);

            this.StartPolling(Component._isManuallyControllable, 500);

            await this._messageProvider?.InitializeUpdate(this.StartPolling);

            // Poll messenger state
            if (Component._Messenger != null)
            {
                this.StartPolling(Component._Messenger.MessengerState, 1500);
            }
        }
    }


    public class AxoCylinderStatusView : AxoCylinderView
    {
        public AxoCylinderStatusView()
        {
            this.DisplayMode = eDisplayMode.Advanced;
        }
    }

    public class AxoCylinderCommandView : AxoCylinderView
    {
        public AxoCylinderCommandView()
        {
            this.DisplayMode = eDisplayMode.Advanced;
        }
    }

    public class AxoCylinderSpotView : AxoCylinderView
    {
        public AxoCylinderSpotView()
        {
            this.DisplayMode = eDisplayMode.Spot;
        }
    }
}

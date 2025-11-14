using AXOpen.Components.Drives;
using AXOpen.Core;
using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXOpen.VisualComposer.Components.VisualComposerItem;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Humanizer;
using Microsoft.AspNetCore.Components;
using System;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using static AXOpen.Components.Festo.Drives.AxoCmmtAsView;

namespace AXOpen.Components.Festo.Drives;

public partial class AxoCmmtAsView : RenderableComplexComponentBase<AxoCmmtAs>
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

    private bool ShowMessages { get; set; }
    private AxoMessageProvider? _messageProvider;
    private int _previousAlarmCount;
    private int? _originalZIndex;
    private enum eAlarmLevel
    {
        NoAlarms,
        ActiveInfo,
        ActiveWarnings,
        ActiveErrors,
        Unacknowledged
    }

    public override async void ConfigurePolling()
    {
        StartPolling(Component.DriveState, 250);
        StartPolling(Component.ActualPosition, 250);
        StartPolling(Component.ActualVelocity, 250);
        StartPolling(Component.ActualTorque, 250);

        var zsw1 = Component.AxisRefExt.Telegram111_In.ZSW1;
        StartPolling(zsw1.operationEnabled, 250);
        StartPolling(zsw1.ready, 250);
        StartPolling(zsw1.driveStopped, 250);
        StartPolling(zsw1.faultPresent, 250);
        StartPolling(zsw1.warningActive, 250);
        StartPolling(zsw1.followingErrorInTolerance, 250);

        StartPolling(Component.AxisRefExt.Telegram111_In.Fault_Code, 500);
        StartPolling(Component.AxisRefExt.Telegram111_In.Warn_Code, 500);
        StartPolling(Component.AxisRefExt.Telegram111_In.XIST_A, 500);
        StartPolling(Component.AxisRefExt.Telegram111_In.NIST_B, 500);
        StartPolling(Component.AxisRefExt.Telegram750_In.M_Actual, 500);

        StartPolling(Component.AxoStop_Task.Status, 250);
        StartPolling(Component.AxoStop_Task.IsDisabled, 500);

        StartPolling(Component.AxoHalt_Task.Status, 250);
        StartPolling(Component.AxoHalt_Task.IsDisabled, 500);

        StartPolling(Component.AxoHome_Task.Status, 250);
        StartPolling(Component.AxoHome_Task.IsDisabled, 500);

        StartPolling(Component.AxoMoveAbsolute_Task.Status, 250);
        StartPolling(Component.AxoMoveAbsolute_Task.IsDisabled, 500);

        StartPolling(Component.AxoMoveRelative_Task.Status, 250);
        StartPolling(Component.AxoMoveRelative_Task.IsDisabled, 500);

        StartPolling(Component.AxoMoveAdditive_Task.Status, 250);
        StartPolling(Component.AxoMoveAdditive_Task.IsDisabled, 500);

        StartPolling(Component.AxoMoveVelocity_Task.Status, 250);
        StartPolling(Component.AxoMoveVelocity_Task.IsDisabled, 500);

        StartPolling(Component.AxoTorqueControl_Task.Status, 250);
        StartPolling(Component.AxoTorqueControl_Task.IsDisabled, 500);

        StartPolling(Component.RestoreTask.Status, 250);
        StartPolling(Component.RestoreTask.IsDisabled, 500);

        StartPolling(Component.HardwareDiagnosticsTask, 1000);

        StartPolling(Component._isManuallyControllable, 500);

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

    private int _alarmCount
    {
        get
        {
            var messengers = _messageProvider?.Messengers;
            if (messengers == null)
            {
                return 0;
            }

            return messengers.Count(m => m.State != eAxoMessengerState.Idle);
        }
    }
    private bool HasActiveMessages => _alarmCount > 0;
    private int ActiveAlarmCount => _alarmCount;

    private eAlarmLevel AlarmLevel
    {
        get
        {
            var messengers = _messageProvider?.Messengers;
            if (messengers == null || !messengers.Any())
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

    private string AlarmBadgeClass => AlarmLevel switch
    {
        eAlarmLevel.ActiveErrors => "animate-pulse-danger badge-danger",
        eAlarmLevel.ActiveWarnings => "badge-warning",
        eAlarmLevel.ActiveInfo => "badge-primary",
        eAlarmLevel.Unacknowledged => "badge-warning",
        _ => "badge-primary"
    };

    private string AlarmBorderClass => AlarmLevel switch
    {
        eAlarmLevel.ActiveErrors => "border-danger/30! shadow-glow-danger",
        eAlarmLevel.ActiveWarnings => "border-warning/40! shadow-glow-warning",
        eAlarmLevel.ActiveInfo => "border-info",
        eAlarmLevel.Unacknowledged => "border-warning",
        _ => string.Empty
    };

    private string AlarmBackgroundClass => AlarmLevel switch
    {
        eAlarmLevel.ActiveErrors => "bg-danger/10",
        eAlarmLevel.ActiveWarnings => "bg-warning/10",
        eAlarmLevel.ActiveInfo => "bg-info/10",
        eAlarmLevel.Unacknowledged => "bg-warning/20",
        _ => string.Empty
    };

    private bool IsPowered => Component.AxisRefExt.Telegram111_In.ZSW1.operationEnabled.Cyclic;
    private bool HasFault => Component.AxisRefExt.Telegram111_In.ZSW1.faultPresent.Cyclic;
    private bool HasWarning => Component.AxisRefExt.Telegram111_In.ZSW1.warningActive.Cyclic;
    private bool AxisReady => Component.AxisRefExt.Telegram111_In.ZSW1.ready.Cyclic;
    private bool AxisFault => HasFault;
    private bool DriveStopped => Component.AxisRefExt.Telegram111_In.ZSW1.driveStopped.Cyclic;
    private bool AxisFollowing => Component.AxisRefExt.Telegram111_In.ZSW1.followingErrorInTolerance.Cyclic;

    private eAxoDriveState DriveStateEnum => (eAxoDriveState)Component.DriveState.Cyclic;
    private string DriveStateLabel => DriveStateEnum.Humanize();
    private bool IsStopping => DriveStateEnum == eAxoDriveState.Stopping;
    private bool IsHoming => Component.AxoHome_Task.Status.Cyclic == (ushort)eAxoTaskState.Busy;

    private double ActualPosition => Component.ActualPosition.Cyclic;
    private double ActualVelocity => Component.ActualVelocity.Cyclic;
    private double ActualTorque => Component.ActualTorque.Cyclic;

    private string PositionText => string.Format(CultureInfo.InvariantCulture, "{0:F2} mm", ActualPosition);
    private string VelocityText => string.Format(CultureInfo.InvariantCulture, "{0:F2} mm/s", ActualVelocity);
    private string TorqueText => string.Format(CultureInfo.InvariantCulture, "{0:F2} Nm", ActualTorque);

    private double ReferenceVelocity => Math.Max(Math.Abs(Component.AxoMoveVelocity_Velocity.Cyclic), 1.0);
    private double NormalizedVelocity => Clamp(ReferenceVelocity == 0 ? 0 : ActualVelocity / ReferenceVelocity, -1.0, 1.0);
    private string NeedleRotationdeg => (NormalizedVelocity * 135.0).ToString("F1", CultureInfo.InvariantCulture) + "deg";
    private string HeroMotionClass => !IsPowered
        ? "idle"
        : Math.Abs(NormalizedVelocity) < 0.05 ? "steady" : NormalizedVelocity > 0 ? "forward" : "reverse";

    private string FaultCodeText => FormatWord(Component.AxisRefExt.Telegram111_In.Fault_Code.Cyclic);

    private static string FormatWord(ushort value) => $"0x{value:X4}";

    private static double Clamp(double value, double min, double max)
    {
        if (value < min)
        {
            return min;
        }

        if (value > max)
        {
            return max;
        }

        return value;
    }

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

    private void BringToForeGround()
    {
        var visualItem = GetVisualItemContainer();
        if (visualItem?.Origin != null)
        {
            var container = visualItem.Parent;
            if (container != null && !container.IsDesign)
            {
                _originalZIndex = visualItem.Origin.ZIndex;
                visualItem.Origin.ZIndex = int.MaxValue;
            }
        }
    }

    private void BringToZIndexBack()
    {
        var visualItem = GetVisualItemContainer();
        if (visualItem?.Origin != null && _originalZIndex != null)
        {
            var container = visualItem.Parent;
            if (container != null && !container.IsDesign)
            {
                visualItem.Origin.ZIndex = _originalZIndex.Value;
                _originalZIndex = null;
            }
        }
    }

    private VisualComposerItem? GetVisualItemContainer()
    {
        if (RccContainer is RenderableContentControl rcc)
        {
            return rcc.ParentContainer as VisualComposerItem;
        }

        return null;
    }

    protected Task OpenDetails(string presentationType = "Status-Display")
    {
        if (RccContainer is RenderableContentControl rccContainer)
        {
            if (rccContainer.ParentContainer is VisualComposerItem composerItem && !composerItem.InDesign)
            {
                var parent = composerItem.Parent;
                parent?.OpenDetails(Component, presentationType);
            }
        }

        return Task.CompletedTask;
    }
}


public class AxoCmmtAsStatusView : AxoCmmtAsView
{
    public AxoCmmtAsStatusView()
    {
        this.DisplayMode = eDisplayMode.Advanced;
    }
}

public class AxoCmmtAsCommandView : AxoCmmtAsView
{
    public AxoCmmtAsCommandView()
    {
        this.DisplayMode = eDisplayMode.Advanced;
    }
}

public class AxoCmmtAsSpotView : AxoCmmtAsView
{
    public AxoCmmtAsSpotView()
    {
        this.DisplayMode = eDisplayMode.Spot;
    }
}
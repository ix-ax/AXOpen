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
    internal const string StatusPillBaseClass = "inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-[0.65rem] font-semibold uppercase tracking-[0.2em] transition-all duration-200";
    private const string PillSuccessState = "border-emerald-400/70 text-emerald-100 bg-emerald-500/10 shadow-[0_0_18px_rgba(16,185,129,0.25)]";
    private const string PillDangerState = "border-red-500/70 text-red-100 bg-red-500/10 shadow-[0_0_18px_rgba(248,113,113,0.25)]";
    private const string PillWarningState = "border-amber-400/70 text-amber-100 bg-amber-500/10 shadow-[0_0_18px_rgba(251,191,36,0.22)]";
    private const string PillPrimaryState = "border-sky-400/70 text-sky-100 bg-sky-500/10 shadow-[0_0_18px_rgba(14,165,233,0.25)]";
    private const string PillMutedState = "border-border/50 text-text/70 bg-background/30 shadow-none";

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
    internal bool HasActiveMessages => _alarmCount > 0;
    internal int ActiveAlarmCount => _alarmCount;

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

    private static string BuildStatusPill(string variantClass) => $"{StatusPillBaseClass} {variantClass}";
    private string StatefulPill(bool condition, string activeVariant) => BuildStatusPill(condition ? activeVariant : PillMutedState);

    internal string AlarmBadgeClass => AlarmLevel switch
    {
        eAlarmLevel.ActiveErrors => "border-red-500/70 text-red-100 bg-red-500/10",
        eAlarmLevel.ActiveWarnings => "border-amber-400/70 text-amber-100 bg-amber-500/10",
        eAlarmLevel.ActiveInfo => "border-sky-400/70 text-sky-100 bg-sky-500/10",
        eAlarmLevel.Unacknowledged => "border-amber-400/70 text-amber-100 bg-amber-500/10",
        _ => "border-slate-500/60 text-slate-200 bg-slate-800/30"
    };
    internal string AlarmBadgePillClass => BuildStatusPill(AlarmBadgeClass);

    internal string AlarmBorderClass => AlarmLevel switch
    {
        eAlarmLevel.ActiveErrors => "ring-1 ring-red-500/40 shadow-[0_0_35px_rgba(248,113,113,0.35)]",
        eAlarmLevel.ActiveWarnings => "ring-1 ring-amber-400/40 shadow-[0_0_35px_rgba(251,191,36,0.25)]",
        eAlarmLevel.ActiveInfo => "ring-1 ring-sky-400/40 shadow-[0_0_30px_rgba(56,189,248,0.25)]",
        eAlarmLevel.Unacknowledged => "ring-1 ring-amber-400/50 shadow-[0_0_25px_rgba(251,191,36,0.3)]",
        _ => string.Empty
    };

    internal string AlarmBackgroundClass => AlarmLevel switch
    {
        eAlarmLevel.ActiveErrors => "bg-red-500/10",
        eAlarmLevel.ActiveWarnings => "bg-amber-400/10",
        eAlarmLevel.ActiveInfo => "bg-sky-400/10",
        eAlarmLevel.Unacknowledged => "bg-amber-500/15",
        _ => string.Empty
    };

    internal bool IsPowered => Component.AxisRefExt.Telegram111_In.ZSW1.operationEnabled.Cyclic;
    internal bool HasFault => Component.AxisRefExt.Telegram111_In.ZSW1.faultPresent.Cyclic;
    internal bool HasWarning => Component.AxisRefExt.Telegram111_In.ZSW1.warningActive.Cyclic;
    internal bool AxisReady => Component.AxisRefExt.Telegram111_In.ZSW1.ready.Cyclic;
    internal bool AxisFault => HasFault;
    internal bool DriveStopped => Component.AxisRefExt.Telegram111_In.ZSW1.driveStopped.Cyclic;
    internal bool AxisFollowing => Component.AxisRefExt.Telegram111_In.ZSW1.followingErrorInTolerance.Cyclic;

    private eAxoDriveState DriveStateEnum => (eAxoDriveState)Component.DriveState.Cyclic;
    internal string DriveStateLabel => DriveStateEnum.Humanize();
    internal bool IsStopping => DriveStateEnum == eAxoDriveState.Stopping;
    private bool IsHoming => Component.AxoHome_Task.Status.Cyclic == (ushort)eAxoTaskState.Busy;

    private double ActualPosition => Component.ActualPosition.Cyclic;
    private double ActualVelocity => Component.ActualVelocity.Cyclic;
    private double ActualTorque => Component.ActualTorque.Cyclic;

    internal string PositionText => string.Format(CultureInfo.InvariantCulture, "{0:F2} mm", ActualPosition);
    internal string VelocityText => string.Format(CultureInfo.InvariantCulture, "{0:F2} mm/s", ActualVelocity);
    internal string TorqueText => string.Format(CultureInfo.InvariantCulture, "{0:F2} Nm", ActualTorque);

    private double ReferenceVelocity => Math.Max(Math.Abs(Component.AxoMoveVelocity_Velocity.Cyclic), 1.0);
    private double NormalizedVelocity => Clamp(ReferenceVelocity == 0 ? 0 : ActualVelocity / ReferenceVelocity, -1.0, 1.0);
    internal string NeedleRotationdeg => (NormalizedVelocity * 135.0).ToString("F1", CultureInfo.InvariantCulture) + "deg";
    internal string HeroStateClasses
    {
        get
        {
            var opacityClass = IsPowered ? "opacity-100" : "opacity-70";

            if (HasFault)
            {
                return opacityClass + " border-red-500/70 shadow-[0_0_30px_rgba(248,113,113,0.35)]";
            }

            if (HasWarning)
            {
                return opacityClass + " border-amber-400/70 shadow-[0_0_30px_rgba(251,191,36,0.25)]";
            }

            return opacityClass + " border-slate-600/40 shadow-none";
        }
    }

    internal string PoweredStatePill => StatefulPill(IsPowered, PillSuccessState);
    internal string FaultStatePill => StatefulPill(HasFault, PillDangerState);
    internal string StoppingStatePill => StatefulPill(IsStopping, PillWarningState);
    internal string DriveStatePillClass => BuildStatusPill(PillPrimaryState);
    internal string ServiceTogglePillClass => BuildStatusPill(DisplayMode >= eDisplayMode.Raw ? PillWarningState : PillPrimaryState);

    internal string AxisReadyPillClass => StatefulPill(AxisReady, PillSuccessState);
    internal string AxisFaultPillClass => StatefulPill(AxisFault, PillDangerState);
    internal string DriveStoppedPillClass => StatefulPill(DriveStopped, PillPrimaryState);
    internal string AxisFollowingPillClass => StatefulPill(AxisFollowing, PillSuccessState);

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

    internal void ToggleMessages() => ShowMessages = !ShowMessages;

    internal void ToggleSpotMode()
    {
        if (GetVisualItemContainer() == null)
        {
            DisplayMode = DisplayMode == eDisplayMode.Spot ? eDisplayMode.Advanced : eDisplayMode.Spot;
        }
    }

    internal void ToggleAdvancedMode() => DisplayMode = DisplayMode == eDisplayMode.Advanced ? eDisplayMode.Basic : eDisplayMode.Advanced;

    internal void ToggleServiceView() => DisplayMode = DisplayMode == eDisplayMode.Raw ? eDisplayMode.Basic : eDisplayMode.Raw;

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

    internal Task OpenDetails(string presentationType = "Status-Display")
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
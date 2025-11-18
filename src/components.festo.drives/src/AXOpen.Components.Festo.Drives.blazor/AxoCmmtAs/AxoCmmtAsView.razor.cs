using AXOpen.Components.Drives;
using AXOpen.Core;
using AXOpen.Core.Blazor;
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

public partial class AxoCmmtAsView : AxoComponentViewBase<AxoCmmtAs>
{
    internal const string StatusPillBaseClass = "inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-[0.65rem] font-semibold uppercase tracking-[0.2em] transition-all duration-200";
    private const string PillSuccessState = "border-emerald-400/70 text-emerald-100 bg-emerald-500/10 shadow-[0_0_18px_rgba(16,185,129,0.25)]";
    private const string PillDangerState = "border-red-500/70 text-red-100 bg-red-500/10 shadow-[0_0_18px_rgba(248,113,113,0.25)]";
    private const string PillWarningState = "border-amber-400/70 text-amber-100 bg-amber-500/10 shadow-[0_0_18px_rgba(251,191,36,0.22)]";
    private const string PillPrimaryState = "border-sky-400/70 text-sky-100 bg-sky-500/10 shadow-[0_0_18px_rgba(14,165,233,0.25)]";
    private const string PillMutedState = "border-border/50 text-text/70 bg-background/30 shadow-none";
   
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
    }
       
    private static string BuildStatusPill(string variantClass) => $"{StatusPillBaseClass} {variantClass}";
    private string StatefulPill(bool condition, string activeVariant) => BuildStatusPill(condition ? activeVariant : PillMutedState);
            
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
    
}


public class AxoCmmtAsStatusView : AxoCmmtAsView
{
    public AxoCmmtAsStatusView()
    {
        this.ViewType = eViewType.Status;
    }
}

public class AxoCmmtAsCommandView : AxoCmmtAsView
{
    public AxoCmmtAsCommandView()
    {
        this.ViewType = eViewType.Command;
    }
}

public class AxoCmmtAsSpotView : AxoCmmtAsView
{
    public AxoCmmtAsSpotView()
    {
        this.ViewType = eViewType.Spot;
    }
}
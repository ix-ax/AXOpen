using AXOpen.Components.Abstractions.Drives;
using AXOpen.Components.Drives;
using AXOpen.Core.Blazor;
using AXSharp.Connector.ValueTypes;
using System;
using System.Globalization;

namespace AXOpen.Components.Festo.Drives
{
    public partial class AxoCmmtAsView : AxoComponentViewBase<AxoCmmtAs>
    {
        private static readonly string UnknownValue = "--";

        private eAxoDriveState? CurrentDriveState => Component is null
            ? null
            : (eAxoDriveState)Component.DriveState.Cyclic;

        private eAxoMotionTaskId? CurrentMotionTask => Component?.DriveStatus is null
            ? null
            : (eAxoMotionTaskId)Component.DriveStatus.CurrentMotionTaskId.Cyclic;

        public string DriveStateLabel => CurrentDriveState?.ToString() ?? "Unknown";

        public string CurrentMotionTaskLabel => CurrentMotionTask?.ToString() ?? "No task";

        public string DriveStateBadgeClass => CurrentDriveState switch
        {
            eAxoDriveState.Disabled => "badge-secondary",
            eAxoDriveState.Stopping => "badge-warning",
            eAxoDriveState.Homing => "badge-warning",
            eAxoDriveState.DiscreteMotion => "badge-primary",
            eAxoDriveState.ContinuousMotion => "badge-info",
            eAxoDriveState.Errorstop => "badge-danger",
            eAxoDriveState.Standstill => "badge-success",
            _ => "badge-secondary"
        };

        public string PositionUnit => (eAxoDriveAxisType)Component.AxisType.Cyclic switch
        {
            eAxoDriveAxisType.Linear => "mm",
            eAxoDriveAxisType.Rotary => "deg",
            eAxoDriveAxisType.Error => "!!!",
            eAxoDriveAxisType.Undefined => "???",
            _ => "???"
        };

        public string VelocityUnit => (eAxoDriveAxisType)Component.AxisType.Cyclic switch
        {
            eAxoDriveAxisType.Linear => "mm/s",
            eAxoDriveAxisType.Rotary => "deg/s",
            eAxoDriveAxisType.Error => "!!!",
            eAxoDriveAxisType.Undefined => "???",
            _ => "???"
        };

        public string FormattedPosition => FormatValue(Component?.ActualPosition, PositionUnit);

        public string FormattedVelocity => FormatValue(Component?.ActualVelocity, VelocityUnit);

        public string FormattedTorque => FormatValue(Component?.ActualTorque, "Nm");

        private static string FormatValue(OnlinerLReal? value, string unit)
        {
            if (value is null)
            {
                return UnknownValue;
            }

            var numeric = value.Cyclic;
            return double.IsFinite(numeric)
                ? FormattableString.Invariant($"{numeric:0.###} {unit}")
                : UnknownValue;
        }

        public override void ConfigurePolling()
        {
            if (Component is null)
            {
                return;
            }

            this.StartPolling(Component.DriveState, 250);
            this.StartPolling(Component.ActualPosition, 250);
            this.StartPolling(Component.ActualVelocity, 250);
            this.StartPolling(Component.ActualTorque, 250);
            this.StartPolling(Component.DriveStatus.CurrentMotionTaskId, 500);
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
}

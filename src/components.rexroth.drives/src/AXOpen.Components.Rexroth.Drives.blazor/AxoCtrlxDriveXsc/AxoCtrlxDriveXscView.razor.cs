using AXOpen.Components.Abstractions.Drives;
using AXOpen.Components.Drives;
using AXOpen.Core.Blazor;
using AXSharp.Connector.ValueTypes;
using System;
using System.Globalization;

namespace AXOpen.Components.Rexroth.Drives.v_6_x_x
{
    public partial class AxoCtrlxDriveXscView : AxoComponentViewBase<AxoCtrlxDriveXsc>
    {
        private static readonly string UnknownValue = "--";

        private eAxoDriveState? CurrentDriveState => Component is null
            ? null
            : (eAxoDriveState)Component.DriveState.Cyclic;

        public string DriveStateLabel => CurrentDriveState?.ToString() ?? "Unknown";

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

        public string FormattedPosition => FormatValue(Component?.ActualPosition);

        public string FormattedVelocity => FormatValue(Component?.ActualVelocity);

        public string FormattedTorque => FormatValue(Component?.ActualTorque, "Nm");

        private static string FormatValue(OnlinerLReal? value, string unit = "")
        {
            if (value is null)
            {
                return UnknownValue;
            }

            var numeric = value.Cyclic;
            if (!double.IsFinite(numeric))
            {
                return UnknownValue;
            }

            return string.IsNullOrEmpty(unit)
                ? FormattableString.Invariant($"{numeric:0.###}")
                : FormattableString.Invariant($"{numeric:0.###} {unit}");
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
        }
    }

    public class AxoCtrlxDriveXscStatusView : AxoCtrlxDriveXscView
    {
        public AxoCtrlxDriveXscStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    public class AxoCtrlxDriveXscCommandView : AxoCtrlxDriveXscView
    {
        public AxoCtrlxDriveXscCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    public class AxoCtrlxDriveXscSpotView : AxoCtrlxDriveXscView
    {
        public AxoCtrlxDriveXscSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }
}

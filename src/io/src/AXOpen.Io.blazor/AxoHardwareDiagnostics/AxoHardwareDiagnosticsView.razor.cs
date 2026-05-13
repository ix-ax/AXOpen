using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Io
{
    public partial class AxoHardwareDiagnosticsView : RenderableComplexComponentBase<AxoHardwareDiagnostics>, IDisposable
    {
        public override void ConfigurePolling()
        {
            this.StartPolling(Component.Status, 250);
            this.StartPolling(Component.hardwareID);
            this.StartPolling(Component.GetDiagnosticsReturnCode);

            // Hardware component state flags
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.HardwareComponentState.NoAdditionalInformation);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.HardwareComponentState.TransferNotPermitted);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.HardwareComponentState.DiagnosticsAvailable);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.HardwareComponentState.MaintenanceRequired);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.HardwareComponentState.MaintenanceDemanded);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.HardwareComponentState.Error);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.HardwareComponentState.ComponentAvailability);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.HardwareComponentState.ReplacementState);

            // PLC state flags
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.PlcState.ModuleDisabled);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.PlcState.ConfigurationInRunActive);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.PlcState.InputNotAvailable);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.PlcState.OutputNotAvailable);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.PlcState.DiagnosticsBufferOverflow);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.PlcState.DiagnosticsNotAvailable);
            this.StartPolling(Component.diagnosticDetails.ComponentStateDetail.PlcState.PartialDeviceFailure);

            // IO state flags
            this.StartPolling(Component.diagnosticDetails.IOState.Good);
            this.StartPolling(Component.diagnosticDetails.IOState.Disabled);
            this.StartPolling(Component.diagnosticDetails.IOState.MaintenanceRequired);
            this.StartPolling(Component.diagnosticDetails.IOState.MaintenanceDemanded);
            this.StartPolling(Component.diagnosticDetails.IOState.Error);
            this.StartPolling(Component.diagnosticDetails.IOState.NotAccessible);
            this.StartPolling(Component.diagnosticDetails.IOState.DiagnosticsAvailable);
            this.StartPolling(Component.diagnosticDetails.IOState.IODataNotAvailable);
            this.StartPolling(Component.diagnosticDetails.IOState.NetworkError);
            this.StartPolling(Component.diagnosticDetails.IOState.HardwareError);

            // Component / operating state
            this.StartPolling(Component.diagnosticDetails.ComponentState);
            this.StartPolling(Component.diagnosticDetails.OperatingState);
        }
    }

    // Back-compat derivatives. AxoHardwareDiagnostics is an AxoTask, not an AxoComponent,
    // so view selection uses subclass type, not eViewType.
    public class AxoHardwareDiagnosticsCommandView : AxoHardwareDiagnosticsView { }
    public class AxoHardwareDiagnosticsControlView : AxoHardwareDiagnosticsView { }
    public class AxoHardwareDiagnosticsStatusView : AxoHardwareDiagnosticsView { }
    public class AxoHardwareDiagnosticsDisplayView : AxoHardwareDiagnosticsView { }
}

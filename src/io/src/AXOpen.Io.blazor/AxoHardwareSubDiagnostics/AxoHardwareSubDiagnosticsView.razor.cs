using System.Globalization;
using System.IO;
using System.Net.Http.Headers;
using System.Reflection;
using System.Security.Principal;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Io
{
    public partial class AxoHardwareSubDiagnosticsView : RenderableComplexComponentBase<AxoHardwareSubDiagnostics>, IDisposable
    {
        protected override void OnInitialized()
        {
            base.OnInitialized();
        }

        public override void ConfigurePolling()
        {
            this.StartPolling(Component);
        }
    }

    public class AxoHardwareSubDiagnosticsCommandView : AxoHardwareSubDiagnosticsView
    {
        public AxoHardwareSubDiagnosticsCommandView()
        {
        }
    }
    public class AxoHardwareSubDiagnosticsControlView : AxoHardwareSubDiagnosticsView
    {
        public AxoHardwareSubDiagnosticsControlView()
        {
        }
    }

    public class AxoHardwareSubDiagnosticsStatusView : AxoHardwareSubDiagnosticsView
    {
        public AxoHardwareSubDiagnosticsStatusView()
        {
        }
    }

    public class AxoHardwareSubDiagnosticsDisplayView : AxoHardwareSubDiagnosticsView
    {
        public AxoHardwareSubDiagnosticsDisplayView()
        {
        }
    }
}
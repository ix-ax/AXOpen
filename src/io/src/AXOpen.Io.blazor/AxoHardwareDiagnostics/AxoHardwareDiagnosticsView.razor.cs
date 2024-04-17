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
    public partial class AxoHardwareDiagnosticsView : RenderableComplexComponentBase<AxoHardwareDiagnostics>, IDisposable
    {
        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component);
        }
    }

    public class AxoHardwareDiagnosticsCommandView : AxoHardwareDiagnosticsView
    {
        public AxoHardwareDiagnosticsCommandView()
        {
        }
    }
    public class AxoHardwareDiagnosticsControlView : AxoHardwareDiagnosticsView
    {
        public AxoHardwareDiagnosticsControlView()
        {
        }
    }

    public class AxoHardwareDiagnosticsStatusView : AxoHardwareDiagnosticsView
    {
        public AxoHardwareDiagnosticsStatusView()
        {
        }
    }

    public class AxoHardwareDiagnosticsDisplayView : AxoHardwareDiagnosticsView
    {
        public AxoHardwareDiagnosticsDisplayView()
        {
        }
    }
}
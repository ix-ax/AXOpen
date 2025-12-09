using AXOpen.Core.Blazor;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using System;
using System.Collections.Generic;
using System.Text;

namespace AXOpen.Io
{
    /// <summary>
    /// Main view for AxoHwDiag component - Hardware Diagnostics for PLC and connected I/O systems.
    /// This view provides comprehensive diagnostics information for PLC, IO System, Station, Module, and Sub Module levels.
    /// </summary>
    /// <typeparam name="THwIdEnum">The application-specific enum type that represents the Hardware IDs configured in the PLC project.</typeparam>
    public partial class AxoHwDiagView<THwIdEnum> : AxoComponentViewBase<AxoHwDiag> where THwIdEnum : struct, Enum
    {
    }

    /// <summary>
    /// Status view for AxoHwDiag component (read-only display mode).
    /// Used when the component is not manually controllable.
    /// </summary>
    /// <typeparam name="THwIdEnum">The application-specific enum type that represents the Hardware IDs.</typeparam>
    public class AxoHwDiagStatusView<THwIdEnum> : AxoHwDiagView<THwIdEnum> where THwIdEnum : struct, Enum
    {
        public AxoHwDiagStatusView()
        {
            this.ViewType = eViewType.Status;
        }
    }

    /// <summary>
    /// Command view for AxoHwDiag component (interactive control mode).
    /// Used when the component is manually controllable, allowing operator interaction.
    /// </summary>
    /// <typeparam name="THwIdEnum">The application-specific enum type that represents the Hardware IDs.</typeparam>
    public class AxoHwDiagCommandView<THwIdEnum> : AxoHwDiagView<THwIdEnum> where THwIdEnum : struct, Enum
    {
        public AxoHwDiagCommandView()
        {
            this.ViewType = eViewType.Command;
        }
    }

    /// <summary>
    /// Spot view for AxoHwDiag component (minimal/compact display).
    /// Used for overview layouts and quick status checks.
    /// Provides a minimalistic representation focusing on key health indicators.
    /// </summary>
    /// <typeparam name="THwIdEnum">The application-specific enum type that represents the Hardware IDs.</typeparam>
    public class AxoHwDiagSpotView<THwIdEnum> : AxoHwDiagView<THwIdEnum> where THwIdEnum : struct, Enum
    {
        public AxoHwDiagSpotView()
        {
            this.ViewType = eViewType.Spot;
        }
    }

    #region Non-generic versions (for backward compatibility or when enum is not needed)
    
    /// <summary>
    /// Default Hardware ID placeholder enum for cases where no application-specific enum is provided.
    /// </summary>
    public enum DefaultHwId
    {
        Unknown = 0
    }

    /// <summary>
    /// Non-generic version of AxoHwDiagView. Uses DefaultHwId enum (shows numeric values only).
    /// For full Hardware ID name resolution, use AxoHwDiagView&lt;THwIdEnum&gt; with your application-specific enum.
    /// </summary>
    public class AxoHwDiagView : AxoHwDiagView<DefaultHwId>
    {
    }

    /// <summary>
    /// Non-generic version of AxoHwDiagStatusView.
    /// </summary>
    public class AxoHwDiagStatusView : AxoHwDiagStatusView<DefaultHwId>
    {
    }

    /// <summary>
    /// Non-generic version of AxoHwDiagCommandView.
    /// </summary>
    public class AxoHwDiagCommandView : AxoHwDiagCommandView<DefaultHwId>
    {
    }

    /// <summary>
    /// Non-generic version of AxoHwDiagSpotView.
    /// </summary>
    public class AxoHwDiagSpotView : AxoHwDiagSpotView<DefaultHwId>
    {
    }

    #endregion
}

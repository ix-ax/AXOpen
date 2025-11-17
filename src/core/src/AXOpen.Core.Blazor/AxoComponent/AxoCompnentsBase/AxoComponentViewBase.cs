using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using System;
using System.Collections.Generic;
using System.Text;

namespace AXOpen.Core.Blazor
{
    /// <summary>
    /// Base class for AXOpen components views.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class AxoComponentViewBase<T> : RenderableComplexComponentBase<T>, IAxoComponentViewBase where T : AXOpen.Core.AxoComponent
    {
        public eViewType ViewType { get; set; } = eViewType.Status;
    }

    public interface IAxoComponentViewBase
    {
        eViewType ViewType { get; }
        
        object RccContainer { get; }
    }
}

using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System.ComponentModel;
using System.Reflection.Metadata.Ecma335;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using AXOpen.Core.Blazor.Culture;
using System.Globalization;
using AXSharp.Connector.Localizations;

namespace AXOpen.Core
{
    public partial class AxoStepView : RenderableComplexComponentBase<AxoStep>
    {
        [Parameter]
        public string? Class { get; set; }

        [Parameter]
        public bool IsControllable { get; set; }

        private bool _isActive => Component.IsActive.Cyclic == true;

        private eStepState _stepState =>
            (eAxoTaskState)this.Component.Status.LastValue switch
                {
                    eAxoTaskState.Busy => eStepState.Active,
                    eAxoTaskState.Done => eStepState.Done,
                    eAxoTaskState.Error => eStepState.Error,
                    eAxoTaskState.Ready => eStepState.Ready,
                    _ => eStepState.Idle
                };

        private string _description => string.IsNullOrEmpty(Component.Descr?.GetCyclic()) ? Component.Translate(Component.AttributeName, CultureInfo.CurrentUICulture) : Component.Descr?.GetCyclic(CultureInfo.CurrentUICulture);

        private string _durationText
        {
            get
            {
                var duration = Component.Duration.Cyclic;
                if (duration.TotalHours >= 1)
                    return duration.ToString(@"h\:mm\:ss");
                else if (duration.TotalMinutes >= 1)
                    return duration.ToString(@"m\:ss");
                else
                    return duration.ToString(@"s\.ff\s");
            }
        }

        private string _timestampText
        {
            get
            {
                var timestamp = Component.StartTimeStamp.Cyclic;
                if (timestamp == DateTime.MinValue)
                    return string.Empty;

                try
                {
                    return Humanizer.DateHumanizeExtensions.Humanize(timestamp, culture: CultureExtensions.Culture);
                }
                catch
                {
                    return timestamp.ToString("HH:mm:ss");
                }
            }
        }

        public override void ConfigurePolling()
        {
            this.StartPolling(Component.Descr, 750);
            this.StartPolling(Component.Status, 750);
            this.StartPolling(Component.Duration, 750);
        }
    }

    public enum eStepState
    {
        Idle,
        Ready,
        Active,
        Done,
        Error
    }

    public class AxoStepCommandView : AxoStepView
    {
        public AxoStepCommandView()
        {
            IsControllable = true;
        }
    }

    public class AxoStepStatusView : AxoStepView
    {
        public AxoStepStatusView()
        {
            IsControllable = false;
        }
    }
}

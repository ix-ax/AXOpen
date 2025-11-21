using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXOpen.VisualComposer.Components.VisualComposerItem;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Text;

namespace AXOpen.Core.Blazor
{
    public enum eViewType
    {
        Spot,
        Command,
        Status
    }

    public partial class AxoComponentContainerView : RenderableComponentBase
    {
        public override void ConfigurePolling()
        {
            this.StartPolling(Component?._isManuallyControllable, 350);
            MessageProvider?.InitializeUpdate(this.StartPolling);
        }       

        [Parameter]
        public required AxoComponent? Component { get; set; }
                    
        private AxoMessageProvider? _messageProvider;
        public AxoMessageProvider? MessageProvider
        {
            get
            {
                if (_messageProvider == null && Component != null)
                {
                    _messageProvider = AxoMessageProvider.Create(new[] { Component });
                }

                return _messageProvider;
            }
        }
    
        public bool HeaderActive { get; set; }

        public bool DetailsActive { get; set; }

        public bool CommandsActive { get; set; }

        public bool StateActive { get; set; }

        public bool SpotActive { get; set; }

        public bool ServiceViewActive { get; set; }

        // Properties referenced in the markup        
        public int ActiveAlarmCount { get { return _alarmCount; } }
        public string AlarmBadgeClass => _alarmLevel switch
        {
            eAlarmLevel.NoAlarms => "",
            eAlarmLevel.Unacknowledged => "animate-pulse-danger badge-warning",
            eAlarmLevel.ActiveInfo => "animate-pulse-danger badge-info",
            eAlarmLevel.ActiveWarnings => "animate-pulse-danger badge-warning",
            eAlarmLevel.ActiveErrors => "animate-pulse-danger badge-danger",
            _ => ""
        };

        public void ToggleServiceView()
        {
            ServiceViewActive = !ServiceViewActive;
            StateHasChanged();
        }

        // Methods referenced in the markup
        public void ToggleDetails()
        {
            DetailsActive = !DetailsActive;
            CommandsActive = !CommandsActive;
            StateActive = !StateActive;
            StateHasChanged();
        }
        
        public void ToggleMessages()
        {
            this.AlarmsActive = !this.AlarmsActive;
            StateHasChanged();
        }

        public bool HasActiveMessages => _alarmCount > 0;

        private int _alarmCount => _messageProvider?.Messengers.Count(a => a.State != eAxoMessengerState.Idle) ?? 0;

        private eAlarmLevel _alarmLevel
        {
            get
            {
                var messengers = _messageProvider?.Messengers;
                if (messengers == null) return eAlarmLevel.NoAlarms;

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
                else if (messengers.Any(p => p.State > eAxoMessengerState.InactiveWaitingForAcknowledge))
                {
                    return eAlarmLevel.Unacknowledged;
                }

                return eAlarmLevel.NoAlarms;
            }
        }

        public string AlarmBorderClass =>
            _alarmLevel switch
            {
                eAlarmLevel.NoAlarms => "",
                eAlarmLevel.Unacknowledged => "border-warning",
                eAlarmLevel.ActiveInfo => "border-info",
                eAlarmLevel.ActiveWarnings => "border-warning/20! shadow-glow-warning",
                eAlarmLevel.ActiveErrors => "border-danger/20! shadow-glow-danger",
                _ => ""
            };

        public string AlarmBackgroundClass =>
           _alarmLevel switch
           {
               eAlarmLevel.NoAlarms => "",
               eAlarmLevel.Unacknowledged => "bg-warning",
               eAlarmLevel.ActiveInfo => "bg-info",
               eAlarmLevel.ActiveWarnings => "bg-warning/20! shadow-glow-warning",
               eAlarmLevel.ActiveErrors => "bg-danger/20! shadow-glow-danger",
               _ => ""
           };

        public string LabelBackgroundClass =>
           _alarmLevel switch
           {
               eAlarmLevel.NoAlarms => "bg-background/80",
               eAlarmLevel.Unacknowledged => "bg-warning",
               eAlarmLevel.ActiveInfo => "bg-info",
               eAlarmLevel.ActiveWarnings => "bg-warning/20! shadow-glow-warning",
               eAlarmLevel.ActiveErrors => "bg-danger/20! shadow-glow-danger",
               _ => "bg-background/80"
           };

        public bool AlarmsActive { get; private set; }

        public void SetView(eViewType? viewType)
        {
            switch (viewType)
            {
                case eViewType.Spot:
                    MakeSpotView();
                    break;
                case eViewType.Command:
                    MakeCommandView();
                    break;
                case eViewType.Status:
                    MakeStatusView();
                    break;
                default:
                    MakeStatusView();
                    break;
            }
        }
        
        public void MakeSpotView()
        {
           HeaderActive = false;
           DetailsActive = false;
           CommandsActive = false;
           StateActive = false;
           SpotActive = true;
           ServiceViewActive = false;
           StateHasChanged();
        }

        public void MakeCommandView()
        {
            HeaderActive = true;
            DetailsActive = false;
            CommandsActive = true;
            StateActive = false;
            ServiceViewActive = false;
            StateHasChanged();
        }

        public void MakeStatusView()
        {
            HeaderActive = true;
            DetailsActive = false;
            CommandsActive = true;           
            StateActive = true;
            ServiceViewActive = false;
            StateHasChanged();
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            this.SetView(ParentReference.ViewType);
        }

        public async Task OpenModal()
        {
            if (this.ParentReference.ViewType == eViewType.Spot)
            {
                await OpenDetails();
            }
        }

        // Z-Index management for Visual Composer
        private int? OriginalZIndex;

        /// <summary>
        /// Brings the component to the foreground by setting z-index to maximum.
        /// Called on mouse enter.
        /// </summary>
        private void BringToForeGround()
        {
            var visualItem = GetVisualItemContainer();
            if (visualItem?.Origin != null)
            {
                var container = visualItem?.Parent;
                if (container != null && !container.IsDesign)
                {
                    OriginalZIndex = visualItem.Origin.ZIndex;
                    visualItem.Origin.ZIndex = int.MaxValue;
                }
            }
        }

        public string MainContainerClasses => this.SpotActive ? "" : $"flex flex-col gap-4 p-4 border rounded-lg bg-background/70 {AlarmBorderClass}";

        /// <summary>
        /// Restores the original z-index of the component.
        /// Called on mouse leave.
        /// </summary>
        private void BringToZIndexBack()
        {
            var visualItem = GetVisualItemContainer();
            if (visualItem?.Origin != null && OriginalZIndex != null)
            {
                var container = visualItem?.Parent;
                if (container != null && !container.IsDesign)
                {
                    visualItem.Origin.ZIndex = OriginalZIndex.Value;
                    OriginalZIndex = null;
                }
            }
        }

        /// <summary>
        /// Gets the Visual Composer container item if the component is rendered inside Visual Composer.
        /// </summary>
        private VisualComposerItem? GetVisualItemContainer()
        {
            var rcc = this.ParentReference?.RccContainer as RenderableContentControl;
            var retVal = rcc?.ParentContainer as VisualComposerItem;
            return retVal;
        }

        protected async Task OpenDetails(string presentationType = "Status-Display")
        {
            if (ParentReference.RccContainer is RenderableContentControl rccContainer)
            {
                if (rccContainer.ParentContainer is VisualComposerItem composerItem)
                {
                    if (!composerItem.InDesign)
                    {
                        //composerItem.Parent.OpenDetails(this.HeaderContent, this.CommandsContent);
                        composerItem.Parent.OpenDetails(this.Component, presentationType); // Updated to use presentationType                        
                    }
                }
            }
        }
    }
}


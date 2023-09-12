using AXOpen.Messaging;
using AXOpen.Messaging.Static;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using Microsoft.AspNetCore.Components;
using Pocos.AXOpen.Core;
using Serilog;

namespace AXOpen.Core
{

    public partial class AxoComponentView : IDisposable
    {
        private bool areDetailsCollapsed = true;
        private bool areAlarmsCollapsed = true;
        private string currentPresentation = "Status-Display";
        private bool containsHeaderAttribute;
        private bool containsDetailsAttribute;
        private IEnumerable<string> tabNames = new List<string>();

        [Parameter]
        public bool IsControllable { get; set; }

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            if (element is AxoComponent axoComponent)
            {
                axoComponent._isManuallyControllable.StartPolling(pollingInterval, this);
                PolledElements.Add(axoComponent._isManuallyControllable);
            }

            Messengers?.Select(p => p.IsActive).ToList().ForEach(messenger =>
            {
                messenger.StartPolling(1500, this);
                PolledElements.Add(messenger);
            });

            Messengers?.Select(p => p.WaitingForAcknowledge).ToList().ForEach(messenger =>
            {
                messenger.StartPolling(1500, this);
                PolledElements.Add(messenger);
            });
        }

        private IEnumerable<string> GetAllTabNames(ITwinObject twinObject)
        {
            return twinObject.GetKids().Where(p => p.GetAttribute<ComponentDetailsAttribute>() != null)
                .Select(p => p.GetAttribute<ComponentDetailsAttribute>().TabName)
                .Distinct()
                .Where(p => !string.IsNullOrEmpty(p));
        }

        private IEnumerable<ITwinElement> GetAllKidsWithComponentDetailsAttribute(ITwinObject twinObject)
        {
            return twinObject.GetKids().Where(p => p.GetAttribute<ComponentDetailsAttribute>() != null);
        }

        private ITwinObject Header
        {
            get
            {
                return new ComponentGroupContext(this.Component, this.Component.GetKids().Where(p => p.GetAttribute<ComponentHeaderAttribute>() != null).ToList());
            }
        }
        private IEnumerable<ITwinObject> DetailsTabs => CreateDetailsTabs();

        private IEnumerable<ITwinObject> CreateDetailsTabs()
        {
            IList<ITwinObject> _detailsTabs = new List<ITwinObject>();

            foreach (string tabName in tabNames)
            {
                List<ITwinElement> currentTabElements = this.Component.GetKids()
                    .Where(p =>
                    {
                        var attr = p.GetAttribute<ComponentDetailsAttribute>();
                        return attr != null && !string.IsNullOrEmpty(attr.TabName) && attr.TabName.Equals(tabName);
                    }).ToList();

                ITwinObject _detailsTab = new ComponentGroupContext(this.Component, currentTabElements, tabName);
                _detailsTabs.Add(_detailsTab);
            }

            List<ITwinElement> notNamedTabElements = this.Component.GetKids()
                .Where(p => p.GetAttribute<ComponentDetailsAttribute>() != null
                            && string.IsNullOrEmpty(p.GetAttribute<ComponentDetailsAttribute>().TabName)).ToList();

            if (notNamedTabElements.Count() > 0)
            {
                ITwinObject _notNamedTab = new ComponentGroupContext(this.Component, notNamedTabElements, "Tab name not defined");
                _detailsTabs.Add(_notNamedTab);
            }

            return _detailsTabs;
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            containsHeaderAttribute = this.Header.GetKids().Count() != 0;
            tabNames = GetAllTabNames(this.Component);
            containsDetailsAttribute = this.DetailsTabs.Count() != 0;
            UpdateValuesOnChange(Component);

           
        }

        protected override async Task OnInitializedAsync()
        {
            var a = Messengers?.SelectMany(p => new ITwinPrimitive[] { p.Category, p.IsActive, p.WaitingForAcknowledge });
            var connector = Messengers?.FirstOrDefault()?.GetConnector();
            await connector?.ReadBatchAsync(a)!;

            await base.OnInitializedAsync();
        }

        private IEnumerable<AxoMessenger>? Messengers => this.Component?.GetChildren().OfType<AxoMessenger>();

       
        private eAlarmLevel AlarmLevel
        {
            get
            {

                var _messengers = Messengers?.ToList();
                if (_messengers == null) { return eAlarmLevel.NoAlarms; }
                
                if (_messengers.Any(p => p.IsActive.Cyclic))
                {
                                     
                    var seriousness = (eAxoMessageCategory)_messengers.Max(p => p.Category.LastValue);

                    if(seriousness <= eAxoMessageCategory.Info)
                        return eAlarmLevel.ActiveInfo;
                    else if (seriousness <= eAxoMessageCategory.Warning)
                        return eAlarmLevel.ActiveWarnings;
                    else if (seriousness <= eAxoMessageCategory.Error)
                        return eAlarmLevel.ActiveErrors;
                }
                else if (_messengers.Any(p => p.WaitingForAcknowledge.LastValue))
                {
                    return eAlarmLevel.Unacknowledged;
                }
                
                return eAlarmLevel.NoAlarms;
            }
        }

        public enum eAlarmLevel
        {
            NoAlarms,
            Unacknowledged,
            ActiveInfo,
            ActiveWarnings,
            ActiveErrors
        }

        private void ToggleCollapseDetails()
        {
            areDetailsCollapsed = !areDetailsCollapsed;
        }

        private void ToggleAlarmsDetails()
        {
            areAlarmsCollapsed = !areAlarmsCollapsed;
        }
    }

    public class AxoComponentCommandView : AxoComponentView
    {
        public AxoComponentCommandView()
        {
            IsControllable = true;
        }
    }

    public class AxoComponentStatusView : AxoComponentView
    {
        public AxoComponentStatusView()
        {
            IsControllable = false;
        }
    }   
}


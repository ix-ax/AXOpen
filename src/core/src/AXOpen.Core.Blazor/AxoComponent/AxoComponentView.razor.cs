using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace AXOpen.Core
{

    public partial class AxoComponentView : IDisposable
    {
        private bool isCollapsed = true;
        private string currentPresentation = "Status-Display";
        private bool containsHeaderAttribute;
        private bool containsDetailsAttribute;
        private IEnumerable<string> tabNames = new List<string>();
        private bool isControllable;

        [Parameter]
        public bool IsControllable
        {
            get
            {
                return isControllable;
            }
            set
            {
                isControllable = value;
            }
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
                return new DetailsContext(this.Component, this.Component.GetKids().Where(p => p.GetAttribute<ComponentHeaderAttribute>() != null).ToList());
            }
        }
        private IEnumerable<ITwinObject> DetailsTabs
        {
            get
            {
                return CreateDetailsTabs();
            }
        }
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

                ITwinObject _detailsTab = new DetailsContext(this.Component, currentTabElements, tabName);
                _detailsTabs.Add(_detailsTab);
            }

            List<ITwinElement> notNamedTabElements = this.Component.GetKids()
                .Where(p => p.GetAttribute<ComponentDetailsAttribute>() != null
                            && string.IsNullOrEmpty(p.GetAttribute<ComponentDetailsAttribute>().TabName)).ToList();

            if (notNamedTabElements.Count() > 0)
            {
                ITwinObject _notNamedTab = new DetailsContext(this.Component, notNamedTabElements, "Tab name not defined");
                _detailsTabs.Add(_notNamedTab);
            }

            return _detailsTabs;
        }

        private void UpdateServiceMode(object sender, EventArgs e)
        {
            if (IsControllable && this.Component._isManuallyControllable.Cyclic)
            {
                currentPresentation = "Command-Control";
            }
            else
            {
                currentPresentation = "Status-Display";
            }
        }

        protected override void OnInitialized()
        {
            containsHeaderAttribute = this.Header.GetKids().Count() != 0;
            tabNames = GetAllTabNames(this.Component);
            containsDetailsAttribute = this.DetailsTabs.Count() != 0;
            UpdateValuesOnChange(Component);
            UpdateServiceMode(this, new EventArgs());
            Component._isManuallyControllable.PropertyChanged += UpdateServiceMode;
        }

        private void Collapse()
        {
            isCollapsed = !isCollapsed;
        }

        public void Dispose()
        {
            Component._isManuallyControllable.PropertyChanged -= UpdateServiceMode;
            Component.StopPolling();
        }
    }
}


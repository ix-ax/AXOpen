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

        [Parameter]
        public bool IsControllable { get; set; }

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

        private void Collapse()
        {
            isCollapsed = !isCollapsed;
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


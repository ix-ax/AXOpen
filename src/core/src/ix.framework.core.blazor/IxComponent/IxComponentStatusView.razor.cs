using Ix.Connector;
using Ix.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;

namespace ix.framework.core
{

    public partial class IxComponentStatusView : IDisposable
    {
        private bool isCollapsed = true;
        private bool ContainsHeaderAttribute;
        private bool ContainsDetailsAttribute;
        private IEnumerable<string> tabNames = new List<string>();

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
     
        protected ITwinObject Header
        {
            get
            {
                return new DetailsContext(this.Component, this.Component.GetKids().Where(p => p.GetAttribute<ComponentHeaderAttribute>() != null).ToList());
            }
        }

        protected IEnumerable<ITwinObject> DetailsTabs
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
                    
        protected override void OnInitialized()
        {
            ContainsHeaderAttribute = this.Header.GetKids().Count() != 0;
            tabNames = GetAllTabNames(this.Component);
            ContainsDetailsAttribute = this.DetailsTabs.Count() != 0;
            UpdateValuesOnChange(Component);
        }

        private void Collapse()
        {
            isCollapsed = !isCollapsed;
        }

        public void Dispose()
        {
            Component.StopPolling();            
        }
    }
}


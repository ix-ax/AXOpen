using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls.RenderableContent;

namespace AXOpen.Core
{
    public partial class AxoTextListView : RenderableComplexComponentBase<AxoTextList>
    {
        private uint _warningLevel => this.Component.GetAttribute<WarningLevelAttribute>() != null ? this.Component.GetAttribute<WarningLevelAttribute>().Level : 0;
        private uint _errorLevel => this.Component.GetAttribute<ErrorLevelAttribute>() != null ? this.Component.GetAttribute<ErrorLevelAttribute>().Level : 0;

        private string _cardClass
        {
            get
            {
                if(_warningLevel>0 && _errorLevel > _warningLevel)
                {
                    if (Component.Id.Cyclic < _warningLevel)
                        return "card bg-primary text-light mb-1";
                    else if (Component.Id.Cyclic >= _errorLevel)
                        return "card bg-danger text-white mb-1";
                    else
                        return "card bg-warning text-black mb-1";
                }
                else
                    return "card bg-primary text-light mb-1";


            }
        }

        public override void AddToPolling(ITwinElement element, int pollingInterval = 250)
        {
            base.AddToPolling(Component?.Id);
            //base.AddToPolling(element, pollingInterval);
        }


        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component.Id);            
        }

        // Attribute name contains interpolation from twin object.
        private string _text => string.IsNullOrEmpty(Component.AttributeName) ? Component.GetSymbolTail() : Component.AttributeName;


    }

    public class AxoTextListCommandView : AxoTextListView
    {
        public AxoTextListCommandView()
        {
        }
    }
    public class AxoTextListControlView : AxoTextListView
    {
        public AxoTextListControlView()
        {
        }
    }

    public class AxoTextListStatusView : AxoTextListView
    {
        public AxoTextListStatusView()
        {
        }
    }
    public class AxoTextListDisplayView : AxoTextListView
    {
        public AxoTextListDisplayView()
        {
        }
    }
}

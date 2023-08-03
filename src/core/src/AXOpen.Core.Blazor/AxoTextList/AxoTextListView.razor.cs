namespace AXOpen.Core
{
    public partial class AxoTextListView : IDisposable
    {

        private string _cardClass
        {
            get
            {
                if (Component.Id.Cyclic < (int)Messaging.eAxoMessageCategory.Warning)
                    return "card bg-primary text-light mb-1";
                else if (Component.Id.Cyclic >= (int)Messaging.eAxoMessageCategory.Error)
                    return "card bg-danger text-white mb-1";
                else
                    return "card bg-warning text-black mb-1";
            }
        }

        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component);
        }

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

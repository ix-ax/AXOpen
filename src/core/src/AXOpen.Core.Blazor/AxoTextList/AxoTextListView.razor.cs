using System.Net.Http.Headers;
using System.Security.Principal;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;

namespace AXOpen.Core
{
    public partial class AxoTextListView : IDisposable
    {


        private string _btnClass
        {
            get
            {
                if (Component.Id.Cyclic < (int)AXOpen.Messaging.eAxoMessageCategory.Warning)
                    return "btn-info";
                else if(Component.Id.Cyclic >= (int)AXOpen.Messaging.eAxoMessageCategory.Error)
                    return "btn-danger";
                else
                    return "btn-warning";
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

    public class AxoTextListStatusView : AxoTextListView
    {
        public AxoTextListStatusView()
        {
        }
    }
}

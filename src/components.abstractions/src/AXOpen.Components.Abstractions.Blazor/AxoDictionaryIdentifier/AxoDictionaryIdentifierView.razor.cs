using System.Net.Http.Headers;
using System.Security.Principal;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;

namespace AXOpen.Components.Abstractions
{
    public partial class AxoDictionaryIdentifierView : IDisposable
    {
        protected override void OnInitialized()
        {
            base.OnInitialized();
            UpdateValuesOnChange(Component);
        }

        public string Description => Component.AttributeName;
    }

    public class AxoDictionaryIdentifierCommandView : AxoDictionaryIdentifierView
    {
        public AxoDictionaryIdentifierCommandView()
        {
            ;
        }
    }

    public class AxoDictionaryIdentifierControlView : AxoDictionaryIdentifierView
    {
        public AxoDictionaryIdentifierControlView()
        {
            ;
        }
    }

    public class AxoDictionaryIdentifierStatusView : AxoDictionaryIdentifierView
    {
        public AxoDictionaryIdentifierStatusView()
        {
            ;
        }
    }
    public class AxoDictionaryIdentifierDisplayView : AxoDictionaryIdentifierView
    {
        public AxoDictionaryIdentifierDisplayView()
        {
            ;
        }
    }
}

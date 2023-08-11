using System.IO;
using System.Net.Http.Headers;
using System.Reflection;
using System.Security.Principal;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;


namespace AXOpen.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoByteArray255View
    {

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            base.OnInitialized();
        }
    }

    public class AxoByteArray255CommandView : AxoByteArray255View
    {
        public AxoByteArray255CommandView()
        {
        }
    }

    public class AxoByteArray255StatusView : AxoByteArray255View
    {
        public AxoByteArray255StatusView()
        {
        }
    }
}

using System.IO;
using System.Net.Http.Headers;
using System.Reflection;
using System.Security.Principal;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;


namespace AXOpen.Cognex.Vision.v_6_0_0_0
{
    public partial class AxoBoolArray8View
    {

        protected override void OnInitialized()
        {
            UpdateValuesOnChange(Component);
            base.OnInitialized();
        }
    }

    public class AxoBoolArray8CommandView : AxoBoolArray8View
    {
        public AxoBoolArray8CommandView()
        {
        }
    }

    public class AxoBoolArray8StatusView : AxoBoolArray8View
    {
        public AxoBoolArray8StatusView()
        {
        }
    }
}

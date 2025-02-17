using AngleSharp.Dom;
using AXOpen.Data;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Reflection.Emit;

namespace AXOpen.Data
{
    public partial class PathFilterBuilder : IDisposable
    {
        [Parameter]
        public PlainPathObjectBuilder builder { get; set; }

        public Guid ViewGuid { get; } = new Guid();

        protected override void OnInitialized()
        {
        }

        public string SelectedProperty { set; get; }

        public void Dispose()
        {
            ;
        }
    }
}
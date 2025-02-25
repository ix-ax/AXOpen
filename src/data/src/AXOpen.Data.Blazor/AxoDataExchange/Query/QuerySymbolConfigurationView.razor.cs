using AngleSharp.Dom;
using AXOpen.Data;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Reflection.Emit;

namespace AXOpen.Data.Query
{
    public partial class QuerySymbolConfigurationView : IDisposable
    {
        [Parameter, EditorRequired]
        public QuerySymbolConfiguration SymbolConfiguration { get; set; }

        [Parameter]
        public bool HideDescripion { get; set; }

        public void Dispose()
        {
            ;
        }
    }
}
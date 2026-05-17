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
        public string HiddenPrefix { get; set; } = "";

        [Parameter]
        public bool HideDescription { get; set; }


        [Parameter] 
        public EventCallback SymbolConfigurationChanged { get; set; }

        public object MinOrValue
        {
            get => SymbolConfiguration.MinOrValue;
            set
            {
                if (SymbolConfiguration.MinOrValue != value)
                {
                    SymbolConfiguration.MinOrValue = value;
                    this.OnAnyValueChange();
                }
            }
        }

        public object Max
        {
            get => SymbolConfiguration.Max;
            set
            {
                if (SymbolConfiguration.Max != value)
                {
                    SymbolConfiguration.Max = value;
                    this.OnAnyValueChange();
                }
            }
        }

        public string Operation
        {
            get => SymbolConfiguration.Operation;
            set
            {
                if (SymbolConfiguration.Operation != value)
                {
                    SymbolConfiguration.Operation = value;
                    this.OnAnyValueChange();
                }
            }
        }

        protected void OnAnyValueChange()
        {
            SymbolConfigurationChanged.InvokeAsync().Wait();
        }

        public void Dispose()
        {
            ;
        }
    }
}

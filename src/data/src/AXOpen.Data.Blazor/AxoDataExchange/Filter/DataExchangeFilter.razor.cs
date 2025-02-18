using AngleSharp.Dom;
using AXOpen.Data;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Reflection.Emit;

namespace AXOpen.Data
{
    public partial class DataExchangeFilter : IDisposable
    {
        [Parameter]
        public DataExchangeViewModel Vm { get; set; }

        public IAxoDataExchange exchange;
        public Guid ViewGuid { get; } = new Guid();

        protected override void OnInitialized()
        {
            exchange = (IAxoDataExchange)Vm.Model;
            InitializePropertySelector();
        }

        private string _SelectedRoot = "";

        
        public PlainPathObjectBuilder SelectedBuilder { set; get; }

        public List<PlainPathObjectBuilder> Roots = new();

        protected void InitializePropertySelector()
        {
            foreach (var rootType in exchange.GetPlainObjectType())
            {
                Roots.Add(new PlainPathObjectBuilder(rootType));
            }
        }
       
        public Task<bool> AddFilterBuilderForType(string rootName)
        {
            this.SelectedBuilder = null;

            if (string.IsNullOrEmpty(rootName) || !Roots.Any(p => p.Name == rootName))
            {
             //   this.StateHasChanged();
                return Task.FromResult(false);
            }

            SelectedBuilder = Roots.Where(p => p.Name == rootName).First();
            SelectedBuilder.Clean();
            //this.StateHasChanged();

            return Task.FromResult(true);
        }

        public List<String> GetRootNames()
        {
            List<string> rootnames = new();

            rootnames.Add("SELECT");

            foreach (var r in this.Roots)
            {
                rootnames.Add(r.Name);
            }

            return rootnames;
        }

        public void Dispose()
        {
            ;
        }
    }
}
using AngleSharp.Dom;
using AXOpen.Data;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Reflection.Emit;

namespace AXOpen.Data
{
    public partial class DataExchangeFilter : IDisposable
    {
        [Parameter]
        public DataExchangeViewModel Vm { get; set; }

        public IAxoDataExchange exchange;
        public Guid ViewGuid { get; } = new Guid();

        public Dictionary<Type, List<string>> TypePropList = new();

        public Dictionary<string, Type> roots = new();

        private string _SelectedProperty;
        public string SelectedProperty
        {
            set
            {
                _SelectedProperty = value;
                CurrentPath = $"{CurrentPath}.{_SelectedProperty}";

            }

            get
            {
                return _SelectedProperty;
            }
        }


        public string CurrentPath { set; get; }

        public Type CurrentObjPath;

        public List<string> CurrentLevelProperties { set; get; }



        public string UserInput { get; set; }

        protected override void OnInitialized()
        {
            exchange = (IAxoDataExchange)Vm.Model;

            if (exchange is AxoDataFragmentExchange)
            {
                var s = (AxoDataFragmentExchange)exchange;
            }

            foreach (var rootType in exchange.GetPlainObjectType())
            {
                roots.Add(rootType.Name, rootType);

                CollectProperties(rootType, true);
            }
        }

        private void CollectProperties(Type type, bool isRoot)
        {
            if (TypePropList.ContainsKey(type)) return; // Prevent infinite loops

            var propertyNames = new List<string>();

            foreach (var prop in type.GetProperties())
            {
                propertyNames.Add(prop.Name);

                if (typeof(IPlain).IsAssignableFrom(prop.PropertyType))
                {
                    CollectProperties(prop.PropertyType, false);
                }
            }

            if (isRoot) // remove not presentable fields
            {
                propertyNames.Remove("Hash");
                propertyNames.Remove("Changes");
                propertyNames.Remove("RecordId");
            }

            if (propertyNames.Count > 0)
            {
                TypePropList[type] = propertyNames;
            }
        }


        protected bool FillSelectedProperty() // return true if exist 
        {
            if (CurrentObjPath == null) // fill up roots
            {
                this.CurrentLevelProperties.Clear();

                this.CurrentLevelProperties.AddRange(this.roots.Keys);
                return true;
            }
            else
            {
                this.CurrentLevelProperties.Clear();

                if (TypePropList.ContainsKey(CurrentObjPath))
                {
                    var innerProps = TypePropList[CurrentObjPath];

                    this.CurrentLevelProperties.AddRange(innerProps);
                    return true;
                }

            }
            return false;
        }


        private Task<bool> AddAndValidate()
        {
            return Task.FromResult(true);
        }

        public void Dispose()
        {
            ;
        }
    }
}
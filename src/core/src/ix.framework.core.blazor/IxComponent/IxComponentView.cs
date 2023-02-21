using Ix.Connector;
using Ix.Presentation.Blazor.Controls.Layouts.TabControlComponents;
using Ix.Presentation.Blazor.Controls.RenderableContent;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;

namespace ix.framework.core
{
    public partial class IxComponentView 
    {
        public PropertyInfo GetPropertyViaSymbol(ITwinElement twinObject)
        {
            if (twinObject == null) return null;
            var propertyName = string.Join("", twinObject.GetSymbolTail().TakeWhile(p => !p.Equals('.')));

            if (twinObject.Symbol == null)
                return null;

            if (twinObject.Symbol.EndsWith("]"))
            {
                propertyName = propertyName?.Substring(0, propertyName.IndexOf('[') - 1);
            }

            var propertyInfo = twinObject?.GetParent()?.GetType().GetProperty(propertyName);

            return propertyInfo;
        }

        public T GetAttribute<T>(ITwinElement twinObject) where T : Attribute
        {
            if (twinObject == null) return null;

            try
            {
                var propertyInfo = GetPropertyViaSymbol(twinObject);
                if (propertyInfo != null)
                {                    
                    if (propertyInfo.GetCustomAttributes().FirstOrDefault(p => p is T) is T propertyAttribute)
                    {                       
                        return propertyAttribute;
                    }
                }

                if(twinObject
                    .GetType()
                    .GetCustomAttributes(true)
                    .FirstOrDefault(p => p is T) is T typeAttribute)                 
                {
                   return typeAttribute;
                }
            }
            catch (Exception)
            {
                //throw;
            }

            return null; 
        }
        public IEnumerable<string> GetAllTabNames(ITwinObject twinObject)
        {
            return twinObject.GetKids().Where(p => GetAttribute<ComponentDetailsAttribute>(p) != null)
                .Select(p => GetAttribute<ComponentDetailsAttribute>(p).TabName)
                .Distinct()
                .Where(p => !string.IsNullOrEmpty(p));
        }
        public IEnumerable<ITwinElement> GetAllKidsWithComponentDetailsAttribute(ITwinObject twinObject)
        {
            return twinObject.GetKids().Where(p => GetAttribute<ComponentDetailsAttribute>(p) != null);
        }

        public class DetailsContext : ITwinObject
        {
            public DetailsContext(ITwinObject parent, IList<ITwinElement> kids)
            {
                this._parent = parent;
                this._symbolTail = this._parent.GetSymbolTail();
                _kids = kids;
            }
            public DetailsContext(ITwinObject parent, IList<ITwinElement> kids, string tabName)
            {
                this._parent = parent;
                this._symbolTail = this._parent.GetSymbolTail();
                _kids = kids;
                HumanReadable = tabName;
            }
            public string TabName { get; set; } = string.Empty;

            public string Symbol { get; } = string.Empty;

            public string AttributeName { get; } = string.Empty;

            public string HumanReadable { get; set; } = string.Empty;

            private readonly ITwinObject _parent;

            public ITwinObject GetParent()
            {
                return this._parent;
            }

            private readonly string _symbolTail;

            public string GetSymbolTail()
            {
                return _symbolTail;
            }

            private IList<ITwinObject> _children = new List<ITwinObject>();

            public IEnumerable<ITwinObject> GetChildren()
            {
                return _children;
            }

            private readonly IList<ITwinElement> _kids = new List<ITwinElement>();

            public IEnumerable<ITwinElement> GetKids()
            {
                return _kids;
            }

            private readonly IList<ITwinPrimitive> _primitive = new List<ITwinPrimitive>();

            public IEnumerable<ITwinPrimitive> GetValueTags()
            {
                return _primitive;
            }

            public void AddChild(ITwinObject twinObject)
            {
                _children.Add(twinObject);
            }

            public void AddValueTag(ITwinPrimitive twinPrimitive)
            {
                _primitive.Add(twinPrimitive);
            }

            public void AddKid(ITwinElement kid)
            {
                _kids.Add(kid);
            }

            public Connector GetConnector()
            {
               return this.GetParent()?.GetConnector();
            }

            public void Poll()
            {
                
            }
        }
        public ITwinObject Header 
        {
            get 
            {
                return new DetailsContext(this.Component, this.Component.GetKids().Where(p => GetAttribute<ComponentHeaderAttribute>(p) != null).ToList());                
            }
        }

        public IEnumerable<ITwinObject> DetailsTabs
        {
            get
            {
                IList<ITwinObject> _detailsTabs = new List<ITwinObject>();

                foreach (string tabName in tabNames)
                {
                    List<ITwinElement> currentTabElements = this.Component.GetKids()
                        .Where(p => GetAttribute<ComponentDetailsAttribute>(p) != null)
                        .Where(p => !string.IsNullOrEmpty(GetAttribute<ComponentDetailsAttribute>(p).TabName))
                        .Where(p => GetAttribute<ComponentDetailsAttribute>(p).TabName.Equals(tabName)).ToList();

                    ITwinObject _detailsTab = new DetailsContext(this.Component, currentTabElements,tabName);
                    _detailsTabs.Add(_detailsTab);
                }
                List<ITwinElement> notNamedTabElements = this.Component.GetKids()
                    .Where(p => GetAttribute<ComponentDetailsAttribute>(p) != null)
                    .Where(p => string.IsNullOrEmpty(GetAttribute<ComponentDetailsAttribute>(p).TabName)).ToList();

                if (notNamedTabElements.Count()>0)
                {
                    ITwinObject _notNamedTab = new DetailsContext(this.Component, notNamedTabElements, "Tab name not defined");
                    _detailsTabs.Add(_notNamedTab);
                }

                return _detailsTabs;
            }
        }

    }
}


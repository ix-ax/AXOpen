using AXOpen.Data;
using AXOpen.Base.Data;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXSharp.Connector;
using Microsoft.AspNetCore.Routing;

namespace AXOpen.Data
{
    public class PlainPathObjectBuilder
    {
        public PlainPathObjectBuilder(Type root, string name = "")
        {

            this.Name = name;
            if (string.IsNullOrEmpty(name))
            {
                this.Name = root.Name;
            }

            this.RootType = root;
            CollectProperties(root, true);
        }

        protected string SelectedProperty { set; get; }

        public Dictionary<Type, List<FilterVariable>> TypeDictionary = new();

        public List<FilterVariable> ObjPath = new();

        protected Type RootType { private set; get; }

        public string Name { get; private set; }

        private void CollectProperties(Type type, bool isRoot)
        {
            if (TypeDictionary.ContainsKey(type)) return; // Prevent infinite loops

            var objectProperties = new List<FilterVariable>();

            foreach (var prop in type.GetProperties())
            {
                if (isRoot) // remove not presentable fields
                {
                    if (prop.Name == ("Hash") || prop.Name == "Changes" || prop.Name == "RecordId")
                    {
                        continue;
                    }
                }

                objectProperties.Add(new FilterVariable(prop.Name, prop.PropertyType));

                if (typeof(IPlain).IsAssignableFrom(prop.PropertyType))
                {
                    CollectProperties(prop.PropertyType, false);
                }
            }

            if (objectProperties.Count > 0)
            {
                TypeDictionary[type] = objectProperties;
            }
        }

        public string GetCurrentPath()
        {
            string path = "";

            for (int i = 0; i < ObjPath.Count; i++)
            {
                if (i == 0)
                {
                    path = $"{Name}.{ObjPath[i].Name}";
                }
                else
                {
                    path = $"{path}.{ObjPath[i].Name}";
                }
            }

            return path;
        }

        public Task<bool> SelectedPropertyChanged(string propertyName)
        {

            if (string.IsNullOrEmpty(propertyName)) return Task.FromResult(false);

            this.SelectedProperty = propertyName;

            if (ObjPath.Count == 0) // root prop
            {
                SelectPropertyOnObject(this.RootType, this.SelectedProperty);
                return Task.FromResult(true);
            }
            else if (ObjPath.Count > 0)
            {

                var last = ObjPath.Last();

                SelectPropertyOnObject(last.VariableType, this.SelectedProperty);

                return Task.FromResult(true);
            }

            return Task.FromResult(false);
        }

        protected void SelectPropertyOnObject(Type newObj, string propName)
        {
            if (string.IsNullOrWhiteSpace(propName)) // can be root
            {
                //todo fix root name
                ObjPath.Add(new FilterVariable(newObj.Name, newObj));
            }

            if (!TypeDictionary.ContainsKey(newObj)) return; // must by in dictionary

            var prop = TypeDictionary[newObj];

            if (!prop.Any(x => x.Name == propName)) return; // prop must by in list

            var targetProp = prop.Where(x => x.Name == propName).First();

            // add property to target path
            ObjPath.Add(new FilterVariable(targetProp.Name, targetProp.VariableType));
        }

        public List<string> GetCurrentObjProperties()
        {
            var propNames = new List<string>();

            propNames.Add("SELECT ANY OPTION");

            if (ObjPath.Count == 0)
            {
                var inRoot = this.TypeDictionary[RootType];

                foreach (var item in inRoot)
                {
                    propNames.Add(item.Name);
                }
            }
            if (ObjPath.Count > 0)
            {
                var lastPartElement = ObjPath.Last();

                if (lastPartElement != null)
                {
                    if (TypeDictionary.ContainsKey(lastPartElement.VariableType))
                    {
                        var vars = TypeDictionary[lastPartElement.VariableType];

                        foreach (var v in vars)
                        {
                            propNames.Add(v.Name);
                        }
                    }
                }
            }

            return propNames;
        }

        internal void Clean()
        {
            ObjPath.Clear();
            SelectedProperty = "";
        }
    }
}
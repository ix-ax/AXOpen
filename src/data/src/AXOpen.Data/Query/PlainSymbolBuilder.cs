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

namespace AXOpen.Data.Query
{
    public class PlainSymbolBuilder
    {
        public PlainSymbolBuilder(Type rootType)
        {
            this.RootType = rootType;
            CollectProperties(rootType, true);
        }

        public Dictionary<Type, List<PlainFilterVariable>> TypeDictionary = new();

        public Type RootType { get; private set; }

        public string RootTypeName { get => RootType.Name; } // presentable reason
        public string RootFullTypeName { get => RootType.FullName; } // filterring

        private void CollectProperties(Type type, bool isRoot)
        {
            if (TypeDictionary.ContainsKey(type)) return; // Prevent infinite loops

            var objectProperties = new List<PlainFilterVariable>();

            foreach (var prop in type.GetProperties())
            {
                if (isRoot) // remove not presentable fields
                {
                    if (prop.Name == ("Hash") || prop.Name == "Changes" || prop.Name == "RecordId")
                    {
                        continue;
                    }
                }

               
                var isNullableType = Nullable.GetUnderlyingType(prop.PropertyType) != null;
                var isPlainType = typeof(IPlain).IsAssignableFrom(prop.PropertyType);

                var p = new PlainFilterVariable(prop.Name, prop.PropertyType, isPlainType);

                if (isNullableType && !isPlainType)
                {
                    continue;
                }

                objectProperties.Add(p);

                if (isPlainType)
                {
                    CollectProperties(prop.PropertyType, false);
                }
            }

            if (objectProperties.Count > 0)
            {
                TypeDictionary[type] = objectProperties;
            }
        }

        public List<string> GetSymbols()
        {
            var symbols = new List<string>();

            if (RootType == null || !TypeDictionary.ContainsKey(RootType))
                return symbols;

            CollectSymbols(RootType, this.RootTypeName, symbols);

            return symbols;
        }

        private void CollectSymbols(Type type, string currentPath, List<string> symbols)
        {
            if (!TypeDictionary.TryGetValue(type, out var properties))
                return;

            foreach (var prop in properties)
            {
                string newPath = $"{currentPath}.{prop.Name}";

                if (!prop.IsPlainType)
                {
                    symbols.Add(newPath);
                }
                else
                {
                    CollectSymbols(prop.VariableType, newPath, symbols);
                }
            }
        }

        public Type? GetSymbolType(string result)
        {
            if (string.IsNullOrWhiteSpace(result))
                return null;

            var parts = result.Split('.');
            Type currentType = RootType;

            if (parts[0] != this.RootTypeName)
                throw new Exception("Symbol has different rootType name!");

            foreach (var part in parts.Skip(1)) // Skip root name
            {
                if (!TypeDictionary.ContainsKey(currentType))
                    return null;

                var prop = TypeDictionary[currentType].FirstOrDefault(p => p.Name == part);

                if (prop == null)
                    return null;

                currentType = prop.VariableType;
            }

            return currentType;
        }
    }
}
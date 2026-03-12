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

        internal static readonly Dictionary<Type, List<string>> IgnoreInterfacesProperty = new();
        internal static readonly HashSet<Type> IgnoredInterfaceTypes = new(); // speed up

        internal static readonly Dictionary<Type, List<string>> IgnoredTypesProperty = new();
        internal static readonly HashSet<Type> IgnoredTypes = new();

        internal static readonly List<string> IgnoredRootTypeProperties = new List<string>() { "Hash", "Changes", "RecordId" };
        internal static readonly List<Type> IgnoredAttributes = new List<Type>() { typeof(PlainSymbolIgnoreAttribute) };

        public static void ClearStaticConfiguration()
        {
            IgnoredRootTypeProperties.Clear();
            IgnoredRootTypeProperties.AddRange(new List<string>() { "Hash", "Changes", "RecordId" });

            IgnoreInterfacesProperty.Clear();
            IgnoredInterfaceTypes.Clear();

            IgnoredTypesProperty.Clear();
            IgnoredTypes.Clear();

            IgnoredAttributes.Clear();
            IgnoredAttributes.Add(typeof(PlainSymbolIgnoreAttribute));
        }

        public static void IgnoreProperty(Type inType, string propertyName)
        {
            var targetDict = inType.IsInterface ? IgnoreInterfacesProperty : IgnoredTypesProperty;

            if (!targetDict.TryGetValue(inType, out var list))
                targetDict[inType] = list = [];

            if (!list.Contains(propertyName))
                list.Add(propertyName);

            // Rebuild lookup sets
            IgnoredInterfaceTypes.Clear();
            IgnoredInterfaceTypes.UnionWith(IgnoreInterfacesProperty.Keys);

            IgnoredTypes.Clear();
            IgnoredTypes.UnionWith(IgnoredTypesProperty.Keys);
        }

        public static void IgnoreRootProperty(string propertyName)
        {
            if (!IgnoredRootTypeProperties.Contains(propertyName))
            {
                IgnoredRootTypeProperties.Add(propertyName);
            }
        }

        public static void IgnoreAttribute(Type attributeType)
        {
            if (!typeof(Attribute).IsAssignableFrom(attributeType))
            {
                throw new ArgumentException($"Type '{attributeType.FullName}' is not an Attribute.", nameof(attributeType));
            }

            if (!IgnoredAttributes.Contains(attributeType))
            {
                IgnoredAttributes.Add(attributeType);
            }
        }


        public Dictionary<Type, List<PlainFilterVariable>> TypeDictionary = new();

        public Type RootType { get; private set; }

        public string RootTypeName { get => RootType.FullName; } // presentable reason

        private void CollectProperties(Type type, bool isRoot)
        {
            if (TypeDictionary.ContainsKey(type)) return; // Prevent infinite loops

            var objectProperties = new List<PlainFilterVariable>();

            List<string> localIgnoredProps = new List<string>();

            // ignore property from interfaces
            if (IgnoredTypes.Any())
            {
                foreach (var ignoredType in IgnoredTypes)
                {
                    if (ignoredType.IsAssignableFrom(type))
                    {
                        foreach (var property in IgnoredTypesProperty[ignoredType])
                        {
                            localIgnoredProps.Add(property);
                        }
                    }
                }
            }

            // ignore property from types/classes
            if (IgnoredInterfaceTypes.Any())
            {
                foreach (var itf in type.GetInterfaces().Where(i => IgnoredInterfaceTypes.Contains(i)))
                {
                    foreach (var ignoredProperty in IgnoreInterfacesProperty[itf])
                    {
                        localIgnoredProps.Add(ignoredProperty);
                    }
                }
            }


            foreach (var prop in type.GetProperties())
            {
                if (isRoot) // remove not presentable fields
                {
                    if (IgnoredRootTypeProperties.Contains(prop.Name))
                    {
                        continue;
                    }
                }

                if (localIgnoredProps.Any()) // remove not presentable fields
                {
                    if (localIgnoredProps.Contains(prop.Name))
                    {
                        continue;
                    }
                }

                if (IgnoredAttributes.Any(attr => Attribute.IsDefined(prop, attr)))
                {
                    continue;
                }

                var isNullableType = Nullable.GetUnderlyingType(prop.PropertyType) != null;
                var actualType =   prop.PropertyType;
                var isPlainType = typeof(IPlain).IsAssignableFrom(actualType);

                if (isNullableType && isPlainType)
                {
                    // Skip nullable IPlain objects to avoid circular references
                    continue;
                }

                var p = new PlainFilterVariable(prop.Name, actualType, isPlainType, isNullableType);

                objectProperties.Add(p);

                if (isPlainType)
                {
                    CollectProperties(actualType, false);
                }
            }

            if (objectProperties.Count > 0)
            {
                TypeDictionary[type] = objectProperties;
            }
        }
        private void CollectSymbols(Type type, string currentPath, List<string> symbols)
        {
            if (!TypeDictionary.TryGetValue(type, out var properties))
                return;

            foreach (var prop in properties)
            {
                string newPath = string.IsNullOrEmpty(currentPath) ?  prop.Name : $"{currentPath}.{prop.Name}";

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

        /// <summary>
        /// Builds all leaf symbol paths for the current <see cref="RootType"/>.
        /// Returned paths are relative to the root type and do not include root type name.
        /// Example: <c>vInt</c>, <c>NestObj.vString</c>.
        /// </summary>
        /// <returns>List of discoverable symbol paths.</returns>
        public List<string> GetSymbols( )
        {
            var symbols = new List<string>();

            if (RootType == null || !TypeDictionary.ContainsKey(RootType))
                return symbols;


            CollectSymbols(RootType,"", symbols);

            return symbols;
        }

        /// <summary>
        /// Resolves CLR type of a symbol path relative to <see cref="RootType"/>.
        /// The path must use the same format as <see cref="GetSymbols"/> output,
        /// i.e. without root type prefix.
        /// </summary>
        /// <param name="symbolPath">Relative symbol path, for example <c>vInt</c> or <c>NestObj.vInt</c>.</param>
        /// <returns>
        /// Final property type when path is valid; otherwise <see langword="null"/>.
        /// </returns>
        public Type? GetSymbolType(string symbolPath)
        {
            if (string.IsNullOrWhiteSpace(symbolPath))
                return null;

            var parts = symbolPath.Split('.');

            Type currentType = RootType;

            foreach (var part in parts) 
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

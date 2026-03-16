namespace AXOpen.Data.Query
{
    public class PlainSymbolBuilder
    {
        /// <summary>
        /// Initializes a new instance of <see cref="PlainSymbolBuilder"/> and collects all properties from the specified root type.
        /// </summary>
        /// <param name="rootType">The root type to inspect for building symbol paths.</param>
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

        /// <summary>
        /// Resets all static ignore configurations to their defaults (only <c>Hash</c>, <c>Changes</c>, <c>RecordId</c> and <see cref="PlainSymbolIgnoreAttribute"/>).
        /// </summary>
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

        /// <summary>
        /// Registers a property to be excluded from symbol collection for the given type or interface.
        /// </summary>
        /// <param name="inType">The type or interface that owns the property to ignore.</param>
        /// <param name="propertyName">The name of the property to ignore.</param>
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

        /// <summary>
        /// Adds a property name to the list of properties ignored on every root type.
        /// </summary>
        /// <param name="propertyName">The root-level property name to ignore.</param>
        public static void IgnoreRootProperty(string propertyName)
        {
            if (!IgnoredRootTypeProperties.Contains(propertyName))
            {
                IgnoredRootTypeProperties.Add(propertyName);
            }
        }

        /// <summary>
        /// Registers an attribute type so that any property decorated with it is excluded from symbol collection.
        /// </summary>
        /// <param name="attributeType">The attribute type to ignore. Must derive from <see cref="Attribute"/>.</param>
        /// <exception cref="ArgumentException">Thrown when <paramref name="attributeType"/> is not an <see cref="Attribute"/>.</exception>
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
                var actualType = prop.PropertyType;
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

        private void CollectSymbolPaths(Type type, string currentPath, List<string> symbols)
        {
            if (!TypeDictionary.TryGetValue(type, out var properties))
                return;

            foreach (var prop in properties)
            {
                string newPath = string.IsNullOrEmpty(currentPath) ? prop.Name : $"{currentPath}.{prop.Name}";

                if (!prop.IsPlainType)
                {
                    symbols.Add(newPath);
                }
                else
                {
                    CollectSymbolPaths(prop.VariableType, newPath, symbols);
                }
            }
        }

        /// <summary>
        /// Returns all leaf symbol paths as <see cref="Symbol"/> instances, each associated with the root type name.
        /// </summary>
        public List<AXOpen.Data.Query.Symbol> GetSymbols()
        {
            var symbols = new List<AXOpen.Data.Query.Symbol>();
            symbols.AddRange(GetSymbolPaths().Select(p => new AXOpen.Data.Query.Symbol(RootTypeName, p)));
            return symbols;
        }

        /// <summary>
        /// Returns the dot-separated paths to all leaf (non-<see cref="IPlain"/>) properties reachable from the root type.
        /// </summary>
        public List<string> GetSymbolPaths()
        {
            var plainSymbolPaths = new List<string>();

            if (RootType == null || !TypeDictionary.ContainsKey(RootType))
                return plainSymbolPaths;

            CollectSymbolPaths(RootType, "", plainSymbolPaths);

            return plainSymbolPaths;
        }

        /// <summary>
        /// Resolves the CLR type of a property identified by a dot-separated symbol path.
        /// </summary>
        /// <param name="symbolPath">Dot-separated path (e.g. <c>"Nested.Value"</c>).</param>
        /// <returns>The <see cref="Type"/> of the target property, or <c>null</c> if the path is invalid.</returns>
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

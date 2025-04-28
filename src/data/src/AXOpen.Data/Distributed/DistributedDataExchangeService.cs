using AXSharp.Connector;
using System;
using System.Reflection;

namespace AXOpen.Data
{
    /// <summary>
    /// Provides a service for collecting, grouping, and sorting distributed data exchanges
    /// that implement the <see cref="IAxoDataExchange"/> interface.
    /// </summary>
    public class DistributedDataExchangeService : IDistributedDataExchangeService
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DistributedDataExchangeService"/> class.
        /// </summary>
        public DistributedDataExchangeService()
        {
        }

        private Dictionary<string, List<IAxoDataExchange>> _Exchanges = new();

        /// <summary>
        /// Gets the internal dictionary of data exchanges, grouped by group name.
        /// </summary>
        internal Dictionary<string, List<IAxoDataExchange>> Exchanges => _Exchanges;

        private List<string> _ExistingGroupNames = new();

        /// <summary>
        /// Gets the list of existing group names that have registered exchanges.
        /// </summary>
        public List<string> ExistingGroupNames
        {
            get => _ExistingGroupNames;
        }

        private List<Type> _PrioritizedTypes = new();

        /// <summary>
        /// Gets the list of types that are prioritized when sorting exchanges within groups.
        /// </summary>
        internal List<Type> PrioritizedTypes => _PrioritizedTypes;

        /// <summary>
        /// Adds a data exchange instance to the specified groups.
        /// If no group is specified, the exchange is added to the "default" group.
        /// </summary>
        /// <param name="exchange">The data exchange to add.</param>
        /// <param name="groups">The list of group names to which the exchange should be added.</param>
        public void Add(IAxoDataExchange exchange, List<string> groups = null)
        {
            ArgumentNullException.ThrowIfNull(exchange);

            if (groups == null)
            {
                groups = new List<string>() { "default" };
            }

            if (exchange is IAxoDataExchange)
            {
                foreach (var group in groups)
                {
                    if (_Exchanges.ContainsKey(group))
                    {
                        _Exchanges[group].Add(exchange as IAxoDataExchange);
                    }
                    else
                    {
                        var collection = new List<IAxoDataExchange> { exchange as IAxoDataExchange };
                        _Exchanges.Add(group, collection);
                        this.ExistingGroupNames.Add(group);
                    }
                }
            }
        }

        /// <summary>
        /// Automatically collects all <see cref="IAxoDataExchange"/> instances from the children
        /// of the specified <see cref="ITwinObject"/>, and adds them to groups defined in their attributes.
        /// </summary>
        /// <param name="target">The Twin object to inspect.</param>
        public void CollectAxoDataExchanges(ITwinObject target, HashSet<ITwinObject>? visited = null, IEnumerable<string>? parentGroups = null)
        {
            visited ??= new HashSet<ITwinObject>();

            if (visited.Contains(target))
                return;

            visited.Add(target);

            // Skip if target is a simple IAxoDataExchange but not AxoDataFragmentExchange
            if (target is IAxoDataExchange && target is not AxoDataFragmentExchange)
                return;

            foreach (var item in target.GetChildren().OfType<ITwinObject>())
            {
                // Exclude known types early
                if (item is AXOpen.Core.AxoTask
                    || item is AXOpen.Messaging.Static.AxoMessenger
                    || item is AXOpen.Messaging.Static.AxoMessageProvider
                    || item is AXOpen.Data.AxoDataLocalExchange)
                {
                    visited.Add(item);
                    continue;
                }

                var property = target.GetType().GetProperty(item.GetSymbolTail());
                if (property == null)
                    continue;

                var hasAttribute = property.GetCustomAttribute<DistributedDataAttribute>();
                IEnumerable<string> groups = Enumerable.Empty<string>();

                if (hasAttribute != null)
                {
                    groups = hasAttribute.GetType()
                        .GetProperty("Groups", BindingFlags.Public | BindingFlags.Instance)?
                        .GetValue(hasAttribute) as IEnumerable<string> ?? Enumerable.Empty<string>();

                    // Merge parent groups if any
                    if (parentGroups != null)
                    {
                        groups = groups.Concat(parentGroups);
                    }
                }
                else if (parentGroups != null)
                {
                    groups = parentGroups;
                }

                // Now decide based on the type
                if (item is AxoDataFragmentExchange)
                {
                    CollectAxoDataExchanges(item, visited, groups);
                }
                else if (item is IAxoDataExchange axoDataExchange)
                {
                    this.Add(axoDataExchange, groups.ToList());
                }
                else
                {
                    CollectAxoDataExchanges(item, visited, groups);
                }
            }
        }


        /// <summary>
        /// Adds the specified type to the list of prioritized types for sorting.
        /// </summary>
        /// <param name="exchangePocoType">The POCO type to prioritize.</param>
        public void SetPrioritizedType(Type exchangePocoType)
        {
            if (!_PrioritizedTypes.Contains(exchangePocoType))
                _PrioritizedTypes.Add(exchangePocoType);
        }

        /// <summary>
        /// Sorts the exchanges within each group so that prioritized types appear first,
        /// followed by other types ordered by <see cref="IAxoDataExchange.ManagerDataTypeName"/>.
        /// </summary>
        public void SortGroupsByPriorizedTypes()
        {
            foreach (var key in _Exchanges.Keys.ToList())
            {
                var sortedList = _Exchanges[key]
                    .OrderBy(p =>
                    {
                        int index = _PrioritizedTypes
                            .Select((type, idx) => new { type, idx })
                            .FirstOrDefault(t => t.type.FullName == p.ManagerDataTypeName)?.idx
                            ?? int.MaxValue;

                        return index - _PrioritizedTypes.Count;
                    })
                    .ThenBy(p => p.ManagerDataTypeName)
                    .ToList();

                _Exchanges[key] = sortedList;
            }
        }

        /// <summary>
        /// Determines whether a group with the specified name exists.
        /// </summary>
        /// <param name="groupName">The name of the group to check.</param>
        /// <returns><c>true</c> if the group exists; otherwise, <c>false</c>.</returns>
        public bool IsExistGroup(string groupName)
        {
            return ExistingGroupNames.Any(t => t == groupName);
        }

        /// <summary>
        /// Retrieves a list of data exchanges for the specified group.
        /// Optionally limits the result to one exchange per unique type.
        /// </summary>
        /// <param name="groupName">The name of the group to retrieve.</param>
        /// <param name="onlyOnePerType">
        /// If set to <c>true</c>, only one exchange per type will be included.
        /// If <c>false</c>, all exchanges are returned.
        /// </param>
        /// <returns>A list of <see cref="IAxoDataExchange"/> objects.</returns>
        public List<IAxoDataExchange> GetExchanges(string groupName, bool onlyOnePerType = true)
        {
            var exchangeList = new List<IAxoDataExchange>();

            if (Exchanges.ContainsKey(groupName))
            {
                var groups = Exchanges[groupName].GroupBy(p => p.ManagerDataTypeName);

                foreach (var groupList in groups)
                {
                    if (onlyOnePerType)
                    {
                        exchangeList.Add(groupList.First());
                    }
                    else
                    {
                        exchangeList.AddRange(groupList);
                    }
                }
            }
            return exchangeList;
        }
    }
}
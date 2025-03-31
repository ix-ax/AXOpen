using AXSharp.Connector;
using System.Reflection;

namespace AXOpen.Data
{
    public class DistributedDataExchangeService : IDistributedDataExchangeService
    {
        public DistributedDataExchangeService()
        {
        }

        private Dictionary<string, List<IAxoDataExchange>> _Exchanges = new();

        public Dictionary<string, List<IAxoDataExchange>> Exchanges
        {
            get
            {
                return _Exchanges;
            }
        }

        private List<string> _ExistingGroupNames = new();

        public List<string> ExistingGroupNames
        {
            get { return _ExistingGroupNames; }
            set { _ExistingGroupNames = value; }
        }

        public List<IAxoDataExchange> GetMangersForGroup(string groupName, bool onlyOnePerType = true)
        {
            var managerList = new List<IAxoDataExchange>();

            if (Exchanges.ContainsKey(groupName))
            {
                var groups = Exchanges[groupName].GroupBy((p) => p.ManagerDataTypeName);

                foreach (var groupList in groups)
                {
                    if (onlyOnePerType)
                    {
                        managerList.Add(groupList.First());
                    }
                    else
                    {
                        foreach (var manager in groupList)
                        {
                            managerList.Add(manager);
                        }
                    }
                }
            }

            managerList = managerList.OrderBy(p => p.ManagerDataTypeName).ToList();

            return managerList;
        }

        public bool IsExistManagerGroup(string groupName)
        {
            return ExistingGroupNames.Any(t => t == groupName);
        }

        public void Add(IAxoDataExchange exchange, List<string> groups = null)
        {
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
                        var collection = new List<IAxoDataExchange>();
                        collection.Add(exchange as IAxoDataExchange);
                        _Exchanges.Add(group, collection);

                        this.ExistingGroupNames.Add(group);
                    }
                }
            }
        }

        public void CollectAxoDataExchanges(object target)
        {
            CollectAxoDataExchangesRecursive(target, new HashSet<object>());
        }

        private void CollectAxoDataExchangesRecursive(object target, HashSet<object> visited)
        {
            if (target == null || visited.Contains(target))
                return;

            visited.Add(target);

            var type = target.GetType();

            var properties = type.GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)
                                 .Where(p => p.GetIndexParameters().Length == 0 && p.CanRead
                                             && typeof(ITwinObject).IsAssignableFrom(p.PropertyType)
                                             && !typeof(AXSharp.Connector.Connector).IsAssignableFrom(p.PropertyType)
                                             );

            foreach (var property in properties)
            {
                var propertyValue = property.GetValue(target);

                if (propertyValue is IAxoDataExchange axoDataExchange)
                {
                    var attribute = property.GetCustomAttribute<DistributedDataAttribute>();
                    var groups = attribute?.GetType()
                                           .GetProperty("Groups", BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Instance)?
                                           .GetValue(attribute) as IEnumerable<string> ?? Enumerable.Empty<string>();

                    this.Add(axoDataExchange, groups.ToList());
                }

                if (propertyValue is ITwinObject)
                {
                    CollectAxoDataExchangesRecursive(propertyValue, visited);
                }
            }
        }

    }
}
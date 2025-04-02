using AXSharp.Connector;
using System;
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
                        var collection = new List<IAxoDataExchange>();
                        collection.Add(exchange as IAxoDataExchange);
                        _Exchanges.Add(group, collection);

                        this.ExistingGroupNames.Add(group);
                    }
                }
            }
        }

        public void CollectAxoDataExchanges(ITwinObject target)
        {
            var dataEx = target.GetChildren().Where(p => p is IAxoDataExchange);

            foreach (var item in dataEx)
            {
                DistributedDataAttribute? hasAttribute = target.GetType()
                    .GetProperty(item.GetSymbolTail())?
                    .GetCustomAttribute<DistributedDataAttribute>();


                if (hasAttribute != null)
                {
                    var groups = hasAttribute?.GetType()
                           .GetProperty("Groups", BindingFlags.Public | BindingFlags.Instance)?
                           .GetValue(hasAttribute) as IEnumerable<string> ?? Enumerable.Empty<string>();

                    this.Add((item as IAxoDataExchange), groups.ToList());
                }
            }
        }


    }
}
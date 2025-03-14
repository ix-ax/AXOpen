namespace AXOpen.Data
{
    public interface IDistributedDataExchangeService
    {
        Dictionary<string, List<IAxoDataExchange>> Exchanges { get; }

        List<string> ExistingGroupNames { get; }

        void Add(IAxoDataExchange exchange, List<string> groupNames = null);

        bool IsExistManagerGroup(string groupName);

        List<IAxoDataExchange> GetMangersForGroup(string groupName, bool onlyOnePerType = true);
    }
}
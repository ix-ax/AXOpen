namespace AXOpen.Data
{
    public interface IDistributedDataExchangeService
    {
        Dictionary<string, List<IAxoDataExchange>> DataManagers { get; }

        List<string> DataManagerGroupNames { get; }

        void Add(IAxoDataExchange crudManager, List<string> groups = null);

        bool IsExistManagerGroup(string groupName);

        List<IAxoDataExchange> GetMangersForGroup(string groupName, bool onlyOnePerType = true);
    }
}
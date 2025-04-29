using AXSharp.Connector;

namespace AXOpen.Data
{
    /// <summary>
    /// Defines a contract for managing distributed data exchanges grouped by logical group names.
    /// Supports registration, collection from Twin objects, prioritization, and retrieval.
    /// </summary>
    public interface IDistributedDataExchangeService
    {
        /// <summary>
        /// Adds a data exchange instance to one or more logical groups.
        /// If no groups are specified, the exchange is added to a default group.
        /// </summary>
        /// <param name="exchange">The data exchange instance to add.</param>
        /// <param name="groupNames">The group names to which the exchange belongs. If null, "default" is used.</param>
        void Add(IAxoDataExchange exchange, List<string> groupNames = null);

        /// <summary>
        /// Collects all <see cref="IAxoDataExchange"/> instances from the children of the specified Twin object,
        /// and registers them into groups defined by <see cref="DistributedDataAttribute"/>.
        /// </summary>
        /// <param name="target">The Twin object containing child exchanges.</param>
        void CollectAxoDataExchanges(ITwinObject target, HashSet<ITwinObject>? visited = null, IEnumerable<string> parentGroups = null);

        /// <summary>
        /// Sorts exchanges within each group by prioritizing types added via <c>SetPrioritizedType</c>.
        /// Prioritized types appear first, followed by others ordered by <c>ManagerDataTypeName</c>.
        /// </summary>
        void SortGroupsByPriorizedTypes();

        /// <summary>
        /// Gets the list of all registered group names.
        /// </summary>
        List<string> ExistingGroupNames { get; }

        /// <summary>
        /// Checks if a group with the specified name exists.
        /// </summary>
        /// <param name="groupName">The name of the group to check.</param>
        /// <returns><c>true</c> if the group exists; otherwise, <c>false</c>.</returns>
        bool IsExistGroup(string groupName);

        /// <summary>
        /// Retrieves all exchanges in the specified group.
        /// </summary>
        /// <param name="groupName">The group name to retrieve exchanges from.</param>
        /// <param name="onlyOnePerType">
        /// If <c>true</c>, returns only one exchange per unique type (by <c>ManagerDataTypeName</c>).
        /// If <c>false</c>, returns all matching exchanges.
        /// </param>
        /// <returns>A list of <see cref="IAxoDataExchange"/> instances.</returns>
        List<IAxoDataExchange> GetExchanges(string groupName, bool onlyOnePerType = true);
        
    }

}
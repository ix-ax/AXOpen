namespace AXOpen.Data
{
    /// <summary>
    ///     An interface which grants access to certain operations in DataExchange viewmodel, 
    ///     like searching by id, invoking search or filling the search box
    /// </summary>
    public interface IDataExchangeOperations
    {
        object SelectedRecord { get; }
        string FilterByID { get; set; }
        void InvokeSearch();
    }
}
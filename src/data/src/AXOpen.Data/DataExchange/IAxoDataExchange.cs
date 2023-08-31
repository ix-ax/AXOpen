using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using System.Linq.Expressions;
using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Principal;

namespace AXOpen.Data
{
    public partial interface IAxoDataExchange
    {
        /// <summary>
        /// Gets repository associated with this <see cref="IAxoDataExchange"/> object.
        /// </summary>
        IRepository? Repository { get; }

        /// <summary>
        /// Gets data of this AxoDataExchange object for automated UI generation.
        /// </summary>
        ITwinObject RefUIData { get; }

        bool VerifyHash { get; set; }

        /// <summary>
        /// Stop observing changes of the data object with changeTracker.
        /// </summary>
        void ChangeTrackerStopObservingChanges();

        /// <summary>
        /// Start observing changes of the data object with changeTracker.
        /// </summary>
        /// <param name="authenticationState">Authentication state of current logged user.</param>
        void ChangeTrackerStartObservingChanges(AuthenticationState authenticationState);

        /// <summary>
        /// Saves observed changes from changeTracker to object.
        /// </summary>
        /// <param name="plainObject"></param>
        void ChangeTrackerSaveObservedChanges(IBrowsableDataObject plainObject);

        /// <summary>
        /// Sets changes to changeTracker.
        /// </summary>
        /// <param name="entity">Entity from which is set data.</param>
        void ChangeTrackerSetChanges();

        /// <summary>
        /// Get object which locked this repository.
        /// </summary>
        /// <returns></returns>
        object? GetLockedBy();

        /// <summary>
        /// Set object which locked this repository.
        /// </summary>
        /// <param name="by"></param>
        void SetLockedBy(object by);

        bool IsHashCorrect(IIdentity identity);

        /// <summary>
        /// Gets changes from changeTracker.
        /// </summary>
        /// <returns>List of ValueChangeItem that contains changes.</returns>
        List<ValueChangeItem> ChangeTrackerGetChanges();

        /// <summary>
        /// Gets the list of available exporters.
        /// </summary>
        /// returns>Dictionary of exporters.</returns>
        Dictionary<string, Type> Exporters { get; }

        /// <summary>
        /// Copies the data from the repository(ies) to shadows of this twin object.
        /// </summary>
        /// <param name="entity">Data entity object.</param>
        Task FromRepositoryToShadowsAsync(IBrowsableDataObject entity);

        /// <summary>
        /// Updates data form shadows of this object to respective record in the repository.
        /// </summary>
        /// <returns>Task</returns>
        Task UpdateFromShadowsAsync();

        /// <summary>
        /// Loads data from respective record of the repository into the controller.
        /// </summary>
        /// <param name="entity">Entity to be loaded into the controller.</param>
        /// <returns></returns>
        Task FromRepositoryToControllerAsync(IBrowsableDataObject entity);

        /// <summary>
        /// Load data from controller and creates new record in the repository.
        /// </summary>
        /// <param name="recordId"></param>
        /// <returns></returns>
        Task CreateDataFromControllerAsync(string recordId);

        /// <summary>
        /// Deletes record from the repository.
        /// </summary>
        /// <param name="identifier">Id of the record.</param>
        /// <returns>Task</returns>
        Task Delete(string identifier);

        /// <summary>
        /// Creates new record in the repository.
        /// </summary>
        /// <param name="identifier">Id of the record.</param>
        /// <returns>Task</returns>
        Task CreateNewAsync(string identifier);

        /// <summary>
        /// Check if record exists in the repository.
        /// </summary>
        /// <param name="identifier">Id of the record.</param>
        /// <returns>Task</returns>
        Task<bool> ExistsAsync(string identifier);

        /// <summary>
        /// Create or update record in the repository.
        /// </summary>
        /// <param name="identifier">Id of the record.</param>
        /// <returns>Task</returns>
        Task CreateOrUpdate(string identifier);

        /// <summary>
        /// Create new record of the current data present in the shadows of this object in the repository.
        /// </summary>
        /// <param name="identifier">Id of the new record</param>
        /// <returns></returns>
        Task CreateCopyCurrentShadowsAsync(string identifier);
        
        /// <summary>
        /// Provides handler for remote (controller's) request to create new data entry in the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>
        /// </summary>
        /// <param name="identifier">Record identifier.</param>
        /// <returns>True when success</returns>
        bool RemoteCreate(string identifier);

        /// <summary>
        /// Provides handler for remote (controller's) request to read data from the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>
        /// </summary>
        /// <param name="identifier">Record identifier.</param>
        /// <returns>True when success</returns>
        bool RemoteRead(string identifier);

        /// <summary>
        /// Provides handler for remote (controller's) request to update data in the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>
        /// </summary>
        /// <param name="identifier">Record identifier.</param>
        /// <returns>True when success</returns>
        bool RemoteUpdate(string identifier);

        /// <summary>
        /// Provides handler for remote (controller's) request to delete data from the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>
        /// </summary>
        /// <param name="identifier">Record identifier.</param>
        /// <returns>True when success</returns>
        bool RemoteDelete(string identifier);

        /// <summary>
        /// Provides handler for remote (controller's) request to check if data exists in the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>
        /// </summary>
        /// <param name="identifier">Record identifier.</param>
        /// <returns>True when success</returns>
        bool RemoteEntityExist(string identifier);

        /// <summary>
        /// Provides handler for remote (controller's) request to create or update data in the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>
        /// </summary>
        /// <param name="identifier">Record identifier.</param>
        /// <returns>True when success</returns>
        bool RemoteCreateOrUpdate(string identifier);

        /// <summary>
        /// Gets records meeting criteria from the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>
        /// </summary>
        /// <param name="identifier">Record identifier. Use of '*' will provide no filter to the query. <see cref="Pocos.AXOpen.Data.IAxoDataEntity.DataEntityId"/></param>
        /// <param name="limit">Limits number of entries</param>
        /// <param name="skip">Skips number of entries.</param>
        /// <param name="searchMode">Set the search mode fot his query. <seealso cref="eSearchMode"/></param>
        /// <returns>Records from the associated repository meeting criteria.</returns>
        IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip,
            eSearchMode searchMode);

        /// <summary>
        /// Gets record meeting criteria from the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/> where the data entity id matches exactly the argument.
        /// </summary>
        /// <param name="identifier">Record identifier. Use of '*' will provide no filter to the query. <see cref="Pocos.AXOpen.Data.IAxoDataEntity.DataEntityId"/></param>
        /// <returns>Record from the associated repository meeting criteria.</returns>
        IEnumerable<IBrowsableDataObject> GetRecords(string identifier);

        /// <summary>
        /// Export data from the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>.
        /// </summary>
        /// <param name="path">Path to exported file.</param>
        /// <param name="separator">Separator for individual records.</param>
        void ExportData(string path, Dictionary<string, ExportData> customExportData = null, eExportMode exportMode = eExportMode.First, int firstNumber = 50, int secondNumber = 100, string exportFileType = "CSV", char separator = ';');

        /// <summary>
        /// Import data from file to the <see cref="Repository"/> associated with this <see cref="IAxoDataExchange"/>.
        /// </summary>
        /// <param name="path">Path to imported file.</param>
        /// <param name="crudDataObject">Object type of the imported records.</param>
        /// <param name="separator">Separator for individual records.</param>
        void ImportData(string path, AuthenticationState authenticationState, ITwinObject crudDataObject = null, string exportFileType = "CSV", char separator = ';');

        /// <summary>
        /// Clear directory of temporary files.
        /// </summary>
        /// <param name="path">Path to temp file.</param>
        static void CleanUp(string path = "wwwroot/Temp")
        {
            if (Directory.Exists(path))
                Directory.Delete(path, true);
        }
    }
}

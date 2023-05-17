using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;

namespace AXOpen.Data
{
    public partial interface IAxoDataExchange
    {
        /// <summary>
        /// Gets repository associated with this <see cref="IAxoDataExchange"/> object.
        /// </summary>
        IRepository? Repository { get; }

        /// <summary>
        /// Gets data of this AxoDataExchange object.
        /// </summary>
        ITwinObject Data { get; }


        void FromPlainsToShadows(IBrowsableDataObject entity);

        Task UpdateFromShadows();

        Task FromShadowsToController(IBrowsableDataObject selected);

        Task LoadFromPlc(string recordId);

        Task Delete(string recordId);

        Task CreateNew(string identifier);

        Task CreateCopy(string identifier);
        
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
    }
}

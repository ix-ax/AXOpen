using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components.Authorization;

namespace AXOpen.Data
{
    public partial class AxoDataLocalExchange
    {
        public ITwinObject CloneDataObject()
        {
            throw new NotImplementedException();
        }

        public ITwinObject DataExchangeTwinObject { get; }
        public IRepository? Repository { get; }
        public bool ShouldVerifyHash { get; set; }
        public void ChangeTrackerStopObservingChanges(ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public void ChangeTrackerStartObservingChanges(AuthenticationState authenticationState, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public void ChangeTrackerSaveObservedChanges(IBrowsableDataObject plainObject, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public void ChangeTrackerSetChanges(ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public object? GetLockedBy()
        {
            throw new NotImplementedException();
        }

        public void SetLockedBy(object by)
        {
            throw new NotImplementedException();
        }

        public bool IsHashCorrect(IIdentity identity, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public List<ValueChangeItem> ChangeTrackerGetChanges()
        {
            throw new NotImplementedException();
        }

        public Dictionary<string, Type> Exporters { get; }
        public Task FromRepositoryToShadowsAsync(IBrowsableDataObject entity, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public Task UpdateFromShadowsAsync(ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public Task FromRepositoryToControllerAsync(IBrowsableDataObject entity, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public Task CreateDataFromControllerAsync(string recordId, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public Task Delete(string identifier)
        {
            throw new NotImplementedException();
        }

        public Task CreateNewAsync(string identifier, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public Task<bool> ExistsAsync(string identifier)
        {
            throw new NotImplementedException();
        }

        public Task CreateOrUpdate(string identifier, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public Task CreateCopyCurrentShadowsAsync(string identifier, ITwinObject dataObject)
        {
            throw new NotImplementedException();
        }

        public Task<bool> RemoteCreate(string identifier)
        {
            throw new NotImplementedException();
        }

        public Task<bool> RemoteRead(string identifier)
        {
            throw new NotImplementedException();
        }

        public Task<bool> RemoteUpdate(string identifier)
        {
            throw new NotImplementedException();
        }

        public Task<bool> RemoteDelete(string identifier)
        {
            throw new NotImplementedException();
        }

        public Task<bool> RemoteEntityExist(string identifier)
        {
            throw new NotImplementedException();
        }

        public Task<bool> RemoteCreateOrUpdate(string identifier)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip, eSearchMode searchMode, string sortExpression,
            bool sortAscending)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<IBrowsableDataObject> GetRecords(string identifier)
        {
            throw new NotImplementedException();
        }

        public void ExportData(string path, Dictionary<string, ExportData> customExportData = null, eExportMode exportMode = eExportMode.First,
            uint firstNumber = 50, uint secondNumber = 100, string exportFileType = "CSV", char separator = ';')
        {
            throw new NotImplementedException();
        }

        public void ImportData(string path, AuthenticationState authenticationState, ITwinObject crudDataObject = null,
            string exportFileType = "CSV", char separator = ';')
        {
            throw new NotImplementedException();
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components.Authorization;

namespace AXOpen.Data
{
    public partial class AxoDataLocalExchange
    {
        public string ManagerDataTypeName { get => GetPlainTypes().FirstOrDefault().FullName; }

        public ITwinObject CloneDataObject()
        {
            throw new NotSupportedException();
        }

        public IEnumerable<Type> GetPlainTypes()
        {
            throw new NotSupportedException();
        }

        public IEnumerable<Type> GetPlainObjectType()
        {
            throw new NotSupportedException();
        }

        public ITwinObject DataExchangeTwinObject { get; }
        public IRepository? Repository { get; }
        public bool ShouldVerifyHash { get; set; }
        public long LastFragmentQueryCount { get; set; }

        public void ChangeTrackerStopObservingChanges(ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public void ChangeTrackerStartObservingChanges(AuthenticationState authenticationState, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public void ChangeTrackerSaveObservedChanges(IBrowsableDataObject plainObject, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public void ChangeTrackerSetChanges(ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public object? GetLockedBy()
        {
            throw new NotSupportedException();
        }

        public void SetLockedBy(object by)
        {
            throw new NotSupportedException();
        }

        public bool IsHashCorrect(IIdentity identity, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public List<ValueChangeItem> ChangeTrackerGetChanges()
        {
            throw new NotSupportedException();
        }

        public Dictionary<string, Type> Exporters { get; }
        public Task FromRepositoryToShadowsAsync(IBrowsableDataObject entity, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public Task UpdateFromShadowsAsync(ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public Task FromRepositoryToControllerAsync(IBrowsableDataObject entity, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public Task CreateDataFromControllerAsync(string recordId, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public Task Delete(string identifier)
        {
            throw new NotSupportedException();
        }

        public Task CreateNewAsync(string identifier, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public Task<bool> ExistsAsync(string identifier)
        {
            throw new NotSupportedException();
        }

        public Task CreateOrUpdate(string identifier, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public Task CreateCopyCurrentShadowsAsync(string identifier, ITwinObject dataObject)
        {
            throw new NotSupportedException();
        }

        public Task<bool> RemoteCreate(string identifier)
        {
            throw new NotSupportedException();
        }

        public Task<bool> RemoteRead(string identifier)
        {
            throw new NotSupportedException();
        }

        public Task<bool> RemoteUpdate(string identifier)
        {
            throw new NotSupportedException();
        }

        public Task<bool> RemoteDelete(string identifier)
        {
            throw new NotSupportedException();
        }

        public Task<bool> RemoteEntityExist(string identifier)
        {
            throw new NotSupportedException();
        }

        public Task<bool> RemoteCreateOrUpdate(string identifier)
        {
            throw new NotSupportedException();
        }

        public IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip, eSearchMode searchMode, string sortExpression,
            bool sortAscending)
        {
            throw new NotSupportedException();
        }

        public IEnumerable<IBrowsableDataObject> GetRecords(PredicateContainer predicates, int limit, int skip)
        {
            throw new NotSupportedException();
        }

        public IEnumerable<string> GetEntityIds(PredicateContainer predicates)
        {
            throw new NotSupportedException();
        }

        public IEnumerable<IBrowsableDataObject> GetRecords(string identifier)
        {
            throw new NotSupportedException();
        }

        public IEnumerable<IBrowsableDataObject> GetRecords(IEnumerable<string> identifiers)
        {
            throw new NotSupportedException();
        }

        public void ExportData(string path, Dictionary<string, ExportData> customExportData = null, eExportMode exportMode = eExportMode.First,
            uint firstNumber = 50, uint secondNumber = 100, string exportFileType = "CSV", char separator = ';')
        {
            throw new NotSupportedException();
        }

        public void ImportData(string path, AuthenticationState authenticationState, ITwinObject crudDataObject = null,
            string exportFileType = "CSV", char separator = ';')
        {
            throw new NotSupportedException();
        }
    }
}

// axosimple
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/inxton/axsharp/blob/dev/notices.md

using System.Collections.Generic;
using System.IO.Compression;
using System.Linq;
using System.Reflection;
using System.Security.Principal;
using System.Xml;
using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using AXOpen.Data.Query;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components.Authorization;

namespace AXOpen.Data;

public partial class AxoDataFragmentExchange
{
    public string ManagerDataTypeName { get => GetPlainTypes().FirstOrDefault().FullName; }
    public string PresentableInstanceName { get => DataExchangeTwinObject.AttributeName; }

    /// <inheritdoc />
    public ITwinObject? DataExchangeTwinObject { get; private set; }

    private IRepository? _repository;
    protected IAxoDataExchange[] DataFragments { get; private set; }

    public long LastFragmentQueryCount { set; get; }

    /// <summary>
    /// Creates data fragments from properties annotated with <see cref="AxoDataFragmentAttribute" />
    /// and returns new instance of <see cref="AxoDataFragmentExchange"/>
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <returns>New instance of <see cref="AxoDataFragmentExchange"/></returns>
    public T? CreateDataFragments<T>() where T : AxoDataFragmentExchange
    {
        return CreateDataFragments() as T;
    }

    public IEnumerable<Type> GetPlainTypes()
    {
        var Plains = new List<Type>();

        foreach (var fragment in DataFragments)
        {
            Plains.AddRange(fragment.GetPlainTypes());
        }

        return Plains;
    }

    public bool ShouldVerifyHash { get; set; } = false;

    /// <summary>
    /// Creates data fragments from properties annotated with <see cref="AxoDataFragmentAttribute" />
    /// and returns new instance of <see cref="AxoDataFragmentExchange"/>
    /// </summary>
    /// <returns>New instance of AxoDataFragmentExchange</returns>
    public object CreateDataFragments()
    {
        DataFragments = GetDataSetProperty<AxoDataFragmentAttribute, IAxoDataExchange>().ToArray();
        DataExchangeTwinObject = new AxoFragmentedDataCompound(this, DataFragments.Select(p => p.DataExchangeTwinObject).Cast<ITwinElement>().ToList());
        Repository = new AxoCompoundRepository(DataFragments);

        foreach (var prop in this.GetType().GetProperties())
        {
            var attr = prop.GetCustomAttribute(typeof(AxoDataVerifyHashAttribute));
            if (attr != null)
            {
                DataFragments.First(p => p.GetType() == prop.PropertyType).ShouldVerifyHash = true;
            }
        }

        return this;
    }

    /// <summary>
    ///     Initializes data exchange between remote controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    public async Task InitializeRemoteDataExchange()
    {
        Operation.InitializeExclusively(Handle);
        await this.WriteAsync();
    }

    /// <summary>
    ///    Deinitializes data exchange between remote controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    /// <returns></returns>
    public async Task DeInitializeRemoteDataExchange()
    {
        Operation.DeInitialize();
        await this.WriteAsync();
    }

    private async Task Handle()
    {
        //await Operation.ReadAsync();
        var operation = (eCrudOperation)await Operation.CrudOperation.GetAsync();
        var identifier = await Operation.DataEntityIdentifier.GetAsync();

        switch (operation)
        {
            case eCrudOperation.Create:
                await this.RemoteCreate(identifier);
                break;

            case eCrudOperation.Read:
                await this.RemoteRead(identifier);
                break;

            case eCrudOperation.Update:
                await this.RemoteUpdate(identifier);
                break;

            case eCrudOperation.Delete:
                await this.RemoteDelete(identifier);
                break;

            case eCrudOperation.CreateOrUpdate:
                await this.RemoteCreateOrUpdate(identifier);
                break;

            case eCrudOperation.EntityExist:
                var result = await this.RemoteEntityExist(identifier);
                await Operation._exist.SetAsync(result);
                break;

            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    /// <summary>
    /// Repository for this data exchange.
    /// </summary>
    public IRepository? Repository
    {
        get => _repository ?? throw new RepositoryNotInitializedException(this.Symbol);
        private set => _repository = value;
    }

    /// <summary>
    /// Stop observing changes of the data object with changeTracker.
    /// </summary>
    /// <param name="dataObject">Data object</param>
    public void ChangeTrackerStopObservingChanges(ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            fragment.Manager.ChangeTrackerStopObservingChanges(fragment.Twin);
        }
    }

    /// <summary>
    /// Start observing changes of the data object with changeTracker.
    /// </summary>
    /// <param name="authenticationState">Authentication state of current logged user.</param>
    /// <param name="dataObject">Data object</param>
    public void ChangeTrackerStartObservingChanges(AuthenticationState authenticationState, ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            fragment.Manager.ChangeTrackerStartObservingChanges(authenticationState, fragment.Twin);
        }
    }

    /// <summary>
    /// Saves observed changes from changeTracker to object.
    /// </summary>
    /// <param name="plainObject">This object is used merely for record identification.</param>
    /// <param name="dataObject">Data Object</param>
    public void ChangeTrackerSaveObservedChanges(IBrowsableDataObject plainObject, ITwinObject dataObject)
    {
        throw new NotImplementedException();
    }

    /// <summary>
    /// Gets changes from changeTracker.
    /// </summary>
    /// <returns>List of ValueChangeItem that contains changes.</returns>
    public List<ValueChangeItem> ChangeTrackerGetChanges()
    {
        var changes = new List<ValueChangeItem>();
        foreach (var fragment in DataFragments)
        {
            changes = changes.Concat(fragment.ChangeTrackerGetChanges()).ToList();
        }
        return changes;
    }

    /// <summary>
    /// Get object which locked this repository.
    /// </summary>
    public object? GetLockedBy()
    {
        foreach (var fragment in DataFragments)
        {
            if (fragment.GetLockedBy() != null)
                return fragment.GetLockedBy();
        }
        return null;
    }

    /// <summary>
    /// Set object which locked this repository.
    /// </summary>
    /// <param name="by">Object that will lock this record.</param>
    public void SetLockedBy(object by)
    {
        foreach (var fragment in DataFragments)
        {
            fragment.SetLockedBy(by);
        }
    }

    //public async Task CreateNewAsync(string identifier)
    //{
    //    await Task.Run(() =>
    //    {
    //        foreach (var fragment in DataFragments)
    //        {
    //            CreateNewPocoInFragmentRepository(identifier, fragment);
    //        }

    //        DataFragments.First().Repository.Read(identifier);
    //    });
    //}

    private static void CreateNewPocoInFragmentRepository(string identifier, IAxoDataExchange fragment)
    {
        Pocos.AXOpen.Data.IAxoDataEntity poco = (Pocos.AXOpen.Data.IAxoDataEntity)fragment.DataExchangeTwinObject.CreatePoco();
        poco.DataEntityId = identifier;
        poco.Hash = HashHelper.CreateHash(poco);

        fragment?.Repository.Create(identifier, poco);
    }

    /// <summary>
    /// Deleted new record in all fragments.
    /// </summary>
    /// <param name="identifier">Id</param>
    /// <returns></returns>
    public async Task Delete(string identifier)
    {
        await Task.Run(() => { foreach (var fragment in DataFragments) { fragment.Repository.Delete(identifier); } });
    }

    /// <summary>
    /// Verifies that the record with given Id exists in all fragments.
    /// </summary>
    /// <param name="recordId">Id</param>
    /// <returns></returns>
    public async Task<bool> ExistsAsync(string recordId)
    {
        foreach (var fragment in DataFragments)
        {
            if (!fragment.Repository.Exists(recordId))
                return false;
        }
        return true;
    }

    #region

    private IEnumerable<(IAxoDataExchange Manager, IRepository Repository, ITwinObject Twin)> GetFragments(ITwinObject fragmentCompound)
    {
        if (fragmentCompound is not AxoFragmentedDataCompound)
        {
            throw new ArgumentException("The parent argument must be of type AxoFragmentedDataCompound.", nameof(fragmentCompound));
        }

        var interfaceFragments = (fragmentCompound as AxoFragmentedDataCompound)?.GetChildren().Select(p => p);

        foreach (var fragment in interfaceFragments)
        {
            var fr = DataFragments.FirstOrDefault(p => p.DataExchangeTwinObject.GetType() == fragment.GetType());
            yield return (fr, fr.Repository, fragment);
        }
    }

    /// <inheritdoc />
    public ITwinObject CloneDataObject()
    {
        return new AxoFragmentedDataCompound(this, DataFragments.Select(p => p.CloneDataObject()).Cast<ITwinElement>().ToList());
    }

    /// <inheritdoc />
    public void ChangeTrackerSetChanges(ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            fragment.Manager.ChangeTrackerSetChanges(fragment.Twin as ITwinObject);
        }
    }

    /// <inheritdoc />
    public bool IsHashCorrect(IIdentity identity, ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            if (!fragment.Manager.IsHashCorrect(identity, dataObject))
                return false;
        }

        return true;
    }

    /// <inheritdoc />
    public async Task FromRepositoryToShadowsAsync(IBrowsableDataObject entity, ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            var exist = fragment.Repository.Exists(entity.DataEntityId);

            if (exist)
            {
                var record = fragment.Repository.Read(entity.DataEntityId);
                await fragment.Twin.PlainToShadow(record);
                ((AxoDataEntity)fragment.Twin).Hash = record.Hash;
                ((AxoDataEntity)fragment.Twin).Changes = record.Changes;
            }
            else
            {
                CreateNewPocoInFragmentRepository(entity.DataEntityId, fragment.Manager);
            }
        }
    }

    /// <inheritdoc />
    public async Task UpdateFromShadowsAsync(ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            var plainer = await (fragment.Twin).ShadowToPlain<dynamic>();
            fragment.Manager.ChangeTrackerSaveObservedChanges(plainer, fragment.Twin);
            plainer.Hash = HashHelper.CreateHash(plainer);
            fragment.Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
        }
    }

    /// <inheritdoc />
    public async Task FromRepositoryToControllerAsync(IBrowsableDataObject entity, ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            await fragment.Twin.PlainToOnline(fragment.Repository.Read(entity.DataEntityId));
        }
    }

    /// <inheritdoc />
    public async Task CreateDataFromControllerAsync(string recordId, ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            var plainer = await fragment.Twin.OnlineToPlain<dynamic>();
            plainer.DataEntityId = recordId;
            plainer.Hash = HashHelper.CreateHash(plainer);
            fragment.Repository.Create(plainer.DataEntityId, plainer);
            var plain = fragment.Repository.Read(plainer.DataEntityId);
            fragment.Twin.PlainToShadow(plain);
        }
    }

    /// <inheritdoc />
    public async Task CreateNewAsync(string identifier, ITwinObject dataObject)
    {
        var fragments = GetFragments(dataObject);
        await Task.Run(() =>
        {
            foreach (var fragment in fragments)
            {
                CreateNewPocoInFragmentRepository(identifier, fragment.Manager);
            }
        });

        fragments.First().Repository.Read(identifier);
    }

    /// <inheritdoc />
    public async Task CreateOrUpdate(string identifier, ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            if (Repository.Exists(identifier))
            {
                var plainer = await (fragment.Twin).ShadowToPlain<dynamic>();
                fragment.Manager.ChangeTrackerSaveObservedChanges(plainer, fragment.Twin);
                plainer.Hash = HashHelper.CreateHash(plainer);
                fragment.Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
            }
            else
            {
                Pocos.AXOpen.Data.IAxoDataEntity poco = (Pocos.AXOpen.Data.IAxoDataEntity)fragment.Twin.CreatePoco();
                poco.DataEntityId = identifier;
                poco.Hash = HashHelper.CreateHash(poco);

                fragment.Repository.Create(identifier, poco);
            }
        }

        DataFragments.First().Repository.Read(identifier);
    }

    /// <inheritdoc />
    public async Task CreateCopyCurrentShadowsAsync(string identifier, ITwinObject dataObject)
    {
        foreach (var fragment in GetFragments(dataObject))
        {
            var source = (Pocos.AXOpen.Data.IAxoDataEntity)await fragment.Twin.ShadowToPlain<IBrowsableDataObject>();
            source.DataEntityId = identifier;
            source.Hash = HashHelper.CreateHash(source);
            fragment.Repository.Create(source.DataEntityId, source);
        }
    }

    #endregion

    /// <inheritdoc />
    public async Task<bool> RemoteCreate(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            await fragment?.RemoteCreate(identifier);
        }

        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteRead(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            await fragment?.RemoteRead(identifier);
        }

        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteUpdate(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            await fragment?.RemoteUpdate(identifier);
        }

        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteDelete(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            await fragment?.RemoteDelete(identifier);
        }

        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteEntityExist(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            if (!await fragment.RemoteEntityExist(identifier))
                return false;
        }

        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteCreateOrUpdate(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            await fragment?.RemoteCreateOrUpdate(identifier);
        }

        return true;
    }

    /// <inheritdoc />
    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier)
    {
        return ((dynamic)Repository).GetRecords(identifier);
    }

    /// <inheritdoc />
    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip, eSearchMode searchMode, string sortExpression, bool sortAscending)
    {
        return ((dynamic)Repository)?.GetRecords(identifier, limit, skip, searchMode, sortExpression, sortAscending);
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(PredicateContainer predicates,
        int limit, int skip)
    {
        List<List<string>> fragmentEntities = new();

        Parallel.ForEach(DataFragments.Where(fragment => predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
        {
            var ids = fragment.GetEntityIds(predicates).ToList();
            lock (fragmentEntities)
            {
                fragmentEntities.Add(ids);
            }
        });

        List<string> commonEntities = fragmentEntities.Count > 1
            ? fragmentEntities.Skip(1)
                .Aggregate(new HashSet<string>(fragmentEntities.First()), (common, next) =>
                {
                    common.IntersectWith(next);
                    return common;
                })
                .ToList()
            : fragmentEntities.FirstOrDefault() ?? new List<string>();

        this.LastFragmentQueryCount = commonEntities.Count;

        var toFind = commonEntities.Skip(skip).Take(limit).ToList();

        var records = GetRecords(toFind).ToList();

        var orderedRecords = records.OrderBy(record => toFind.IndexOf(record.DataEntityId))
            .ToList();

        return orderedRecords;
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(IEnumerable<string> identifiers, PredicateContainer sortingPredicates = null)
    {
        return ((dynamic)Repository).GetRecords(identifiers, sortingPredicates);
    }

    public IEnumerable<string> GetEntityIds(PredicateContainer predicates)
    {
        List<List<string>> fragmentEntities = new();

        Parallel.ForEach(DataFragments.Where(fragment => predicates.ContainsType(fragment.GetPlainTypes().First())), fragment =>
        {
            var ids = fragment.GetEntityIds(predicates).ToList();
            lock (fragmentEntities)
            {
                fragmentEntities.Add(ids);
            }
        });

        List<string> commonEntities = fragmentEntities.Count > 1
            ? fragmentEntities.Skip(1)
                .Aggregate(new HashSet<string>(fragmentEntities.First()), (common, next) =>
                {
                    common.IntersectWith(next);
                    return common;
                })
                .ToList()
            : fragmentEntities.FirstOrDefault() ?? new List<string>();

        this.LastFragmentQueryCount = commonEntities.Count;

        var toFind = commonEntities;

        this.LastFragmentQueryCount = commonEntities.Count();

        return commonEntities;
    }

    private IEnumerable<PropertyInfo>? GetDataSetPropertyInfo<TA>() where TA : Attribute
    {
        var properties = this.GetType().GetProperties();
        List<PropertyInfo>? DataPropertyInfo = new List<PropertyInfo>();

        // iterate properties and look for AxoDataEntityAttribute
        foreach (var prop in properties)
        {
            var attr = prop.GetCustomAttribute<TA>();
            if (attr != null)
            {
                DataPropertyInfo.Add(prop);
            }
        }

        if (!DataPropertyInfo.Any())
        {
            throw new Exception($"There is no member annotated with '{nameof(AxoDataEntityAttribute)}' in '{this.Symbol}'.");
        }

        return DataPropertyInfo;
    }

    private IEnumerable<TS>? GetDataSetProperty<TA, TS>() where TA : Attribute where TS : class
    {
        return this.GetDataSetPropertyInfo<TA>()?.Select(p => p.GetValue(this) as TS);
    }

    /// <inheritdoc />
    public Dictionary<string, Type> Exporters
    {
        get
        {
            return DataFragments.First().Exporters;
        }
    }

    public void ExportData(string path, Dictionary<string, ExportData> customExportData = null, eExportMode exportMode = eExportMode.First, uint firstNumber = 50, uint secondNumber = 100, string exportFileType = "CSV", char separator = ';')
    {
        if (Path.GetExtension(path).Equals(".zip", StringComparison.OrdinalIgnoreCase))
        {
            if (Directory.Exists(Path.GetDirectoryName(path) + "\\exportDataPrepare"))
                Directory.Delete(Path.GetDirectoryName(path) + "\\exportDataPrepare", true);

            Directory.CreateDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare");

            File.Delete(path);

            foreach (var fragment in DataFragments)
            {
                fragment?.ExportData(Path.GetDirectoryName(path) + "\\exportDataPrepare", customExportData, exportMode, firstNumber, secondNumber, exportFileType, separator);
            }
            ZipFile.CreateFromDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare", path);
        }
        else
        {
            foreach (var fragment in DataFragments)
            {
                fragment?.ExportData(Path.GetDirectoryName(path), customExportData, exportMode, firstNumber, secondNumber, exportFileType, separator);
            }
        }
    }

    public void ImportData(string path, AuthenticationState authenticationState, ITwinObject crudDataObject = null, string exportFileType = "CSV", char separator = ';')
    {
        if (Path.GetExtension(path).Equals(".zip", StringComparison.OrdinalIgnoreCase))
        {
            if (Directory.Exists(Path.GetDirectoryName(path) + "\\importDataPrepare"))
                Directory.Delete(Path.GetDirectoryName(path) + "\\importDataPrepare", true);

            Directory.CreateDirectory(Path.GetDirectoryName(path) + "\\importDataPrepare");

            ZipFile.ExtractToDirectory(path, Path.GetDirectoryName(path) + "\\importDataPrepare");

            foreach (var fragment in DataFragments)
            {
                fragment?.ImportData(Path.GetDirectoryName(path) + "\\importDataPrepare", authenticationState, crudDataObject, exportFileType, separator);
            }

            if (Directory.Exists(Path.GetDirectoryName(path)))
                Directory.Delete(Path.GetDirectoryName(path), true);
        }
        else
        {
            foreach (var fragment in DataFragments)
            {
                fragment?.ImportData(Path.GetDirectoryName(path), authenticationState, crudDataObject, exportFileType, separator);
            }
        }
    }
}
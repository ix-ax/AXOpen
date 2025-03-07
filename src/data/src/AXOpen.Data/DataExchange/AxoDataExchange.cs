// inxton_axopen_data
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/inxton/axsharp/blob/dev/notices.md

using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO.Compression;
using System.Linq;
using System.Linq.Expressions;
using System.Numerics;
using System.Reflection;
using System.Security.Claims;
using System.Security.Principal;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using AXOpen.Base.Data.Query;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components.Authorization;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AXOpen.Data;

/// <summary>
///     Provides mechanism for structured data exchange between the controller and an arbitrary repository.
/// </summary>
/// <typeparam name="TOnline">Online data twin object of <see cref="AxoDataEntity" /></typeparam>
/// <typeparam name="TPlain">POCO twin of <see cref="Pocos.AXOpen.Data.AxoDataEntity" /></typeparam>
public partial class AxoDataExchange<TOnline, TPlain> where TOnline : IAxoDataEntity
    where TPlain : Pocos.AXOpen.Data.IAxoDataEntity, new()
{
    /// <inheritdoc />
    public ITwinObject? DataExchangeTwinObject => DataEntity as ITwinObject;

    private TOnline _dataEntity;
    public long LastFragmentQueryCount { set; get; }

    public IEnumerable<Type> GetPlainTypes()
    {
        return new List<Type>() { typeof(TPlain) };
    }

    /// <summary>
    /// Creates new instance of class that contains data managed by an external entity in this <see cref="AxoDataExchange{TOnline,TPlain}"/> class./>.
    /// </summary>
    /// <returns>Data object of this AxoDataExchange.</returns>
    public ITwinObject CloneDataObject()
    {
        var de = (DataEntity as ITwinObject);
        return (ITwinObject)Activator.CreateInstance(typeof(TOnline), de.GetParent(), de.GetAttributeName(CultureInfo.InvariantCulture), de.GetSymbolTail());
    }

    /// <summary>
    ///     Gets <see cref="AxoDataEntity" /> associated with this <see cref="AxoDataExchange{TOnline,TPlain}" />.
    /// </summary>
    public TOnline DataEntity
    {
        get
        {
            if (_dataEntity == null) _dataEntity = (TOnline)GetDataSetProperty<AxoDataEntityAttribute>();

            return _dataEntity;
        }
    }

    /// <summary>
    ///    Gets <see cref="ICrudDataObject" /> associated with this <see cref="AxoDataExchange{TOnline,TPlain}" />.
    ///    Provides access to data changes.
    /// </summary>
    public ICrudDataObject? CrudDataObject
    {
        get
        {
            return ((dynamic)DataEntity) as ICrudDataObject;
        }
    }

    private bool? _verifyHash = null;

    /// <summary>
    /// Gets or sets a value indicating whether to verify the hash.
    /// </summary>
    public bool ShouldVerifyHash
    {
        get
        {
            if (_verifyHash != null)
                return (bool)_verifyHash;
            else
            {
                if (this.GetType().GetCustomAttribute(typeof(AxoDataVerifyHashAttribute)) != null)
                {
                    _verifyHash = true;
                    return true;
                }
                _verifyHash = false;
            }
            return false;
        }
        set
        {
            _verifyHash = value;
        }
    }

    /// <summary>
    /// Stop observing changes of the data object with changeTracker.
    /// </summary>
    /// <param name="dataObject">Data object on which to stop observing the changes.</param>
    public void ChangeTrackerStopObservingChanges(ITwinObject dataObject)
    {
        (dataObject as ICrudDataObject)?.ChangeTracker.StopObservingChanges();
    }

    /// <summary>
    /// Start observing changes of the data object with changeTracker.
    /// </summary>
    /// <param name="authenticationState">Authentication state of current logged user.</param>
    /// <param name="dataObject">Data object on which to start observing the changes.</param>
    public void ChangeTrackerStartObservingChanges(AuthenticationState authenticationState, ITwinObject dataObject)
    {
        (dataObject as ICrudDataObject)?.ChangeTracker.StartObservingChanges(authenticationState);
    }

    /// <summary>
    /// Saves observed changes from changeTracker to object.
    /// </summary>
    /// <param name="plainObject"></param>
    /// <param name="dataObject">Data object from which the observed changes will be saved.</param>
    public void ChangeTrackerSaveObservedChanges(IBrowsableDataObject plainObject, ITwinObject dataObject)
    {
        (dataObject as ICrudDataObject)?.ChangeTracker.SaveObservedChanges(plainObject);
    }

    /// <summary>
    /// Sets changes to changeTracker.
    /// </summary>
    /// <param name="dataObject">Entity from which is set data.</param>
    public void ChangeTrackerSetChanges(ITwinObject dataObject)
    {
        CrudDataObject.Changes = ((AxoDataEntity)dataObject).Changes;
    }

    /// <summary>
    /// Gets changes from changeTracker.
    /// </summary>
    /// <returns>List of ValueChangeItem that contains changes.</returns>
    public List<ValueChangeItem> ChangeTrackerGetChanges()
    {
        return CrudDataObject?.Changes ?? new List<ValueChangeItem>();
    }

    /// <summary>
    /// Get object which locked this repository.
    /// </summary>
    public object? GetLockedBy()
    {
        return DataEntity.LockedBy;
    }

    /// <summary>
    /// Set object which locked this repository.
    /// </summary>
    /// <param name="by">Object by which the document/record is locked.</param>
    public void SetLockedBy(object by)
    {
        DataEntity.LockedBy = by;
    }

    /// <summary>
    /// Verifies that the hash of the data object is correct.
    /// </summary>
    /// <param name="identity">Identity of the verifier.</param>
    /// <param name="dataObject">Data object of which identity will verified.</param>
    /// <returns></returns>
    public bool IsHashCorrect(IIdentity identity, ITwinObject dataObject)
    {
        if (!ShouldVerifyHash)
            return true;

        var poco = dataObject.CreatePoco().ShadowToPlain1<TPlain>(dataObject);

        poco.Changes = ((AxoDataEntity)dataObject).Changes;
        poco.Hash = ((AxoDataEntity)dataObject).Hash;

        return HashHelper.VerifyHash(poco, identity);
    }

    /// <summary>
    ///     Get strongly typed repository associated with this <see cref="AxoDataExchange{TOnline,TPlain}" />.
    /// </summary>
    public IRepository<TPlain> DataRepository { get; private set; }

    /// <inheritdoc />
    public IRepository? Repository => DataRepository as IRepository;

    /// <inheritdoc />
    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip,
        eSearchMode searchMode, string sortExpression, bool sortAscending)
    {
        return DataRepository.GetRecords(identifier, limit, skip, searchMode, sortExpression, sortAscending).Cast<IBrowsableDataObject>();
    }

    /// <inheritdoc />
    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier)
    {
        return DataRepository.GetRecords(identifier).Cast<IBrowsableDataObject>();
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(
        PredicateContainer predicates, int limit, int skip)
    {
        return DataRepository.GetRecords(predicates, limit, skip).Cast<IBrowsableDataObject>();
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(IEnumerable<string> identifiers)
    {
        return DataRepository.GetRecords(identifiers).Cast<IBrowsableDataObject>();
    }

    public IEnumerable<string> GetEntityIds(PredicateContainer predicates)
    {
        return DataRepository.GetEntityIds(predicates).ToList();
    }

    private Stopwatch sw = new Stopwatch();

    /// <inheritdoc />
    public async Task<bool> RemoteCreate(string identifier)
    {
        sw.Restart();
        //await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);
        var cloned = await ((ITwinObject)DataEntity).OnlineToPlain<TPlain>();
        Repository.Create(identifier, cloned);
        sw.Stop();
        AxoApplication.Current.Logger.Information($"Record '{identifier}' created in '{this.Symbol}' in '{sw.ElapsedMilliseconds} ms'", this, AxoApplication.Current.ControllerIdentity);
        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteRead(string identifier)
    {
        try
        {
            sw.Restart();
            //await Operation.ReadAsync();
            var record = Repository.Read(identifier);
            await ((ITwinObject)DataEntity).PlainToOnline(record);
            sw.Stop();
            AxoApplication.Current.Logger.Information($"Record '{identifier}' read from '{this.Symbol}' in '{sw.ElapsedMilliseconds} ms'", this, AxoApplication.Current.ControllerIdentity);
            return true;
        }
        catch (Exception exception)
        {
            throw;
        }
    }

    /// <inheritdoc />
    public async Task<bool> RemoteUpdate(string identifier)
    {
        sw.Restart();
        //await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);

        var cloned = await ((ITwinObject)DataEntity).OnlineToPlain<TPlain>();

        cloned.Hash = HashHelper.CreateHash(cloned);
        Repository.Update(identifier, cloned);
        sw.Stop();
        AxoApplication.Current.Logger.Information($"Record '{identifier}' updated in '{this.Symbol}' in '{sw.ElapsedMilliseconds} ms'", this, AxoApplication.Current.ControllerIdentity);
        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteDelete(string identifier)
    {
        sw.Restart();
        //await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);
        Repository.Delete(identifier);
        sw.Stop();
        AxoApplication.Current.Logger.Information($"Record '{identifier}' deleted in '{this.Symbol}' in '{sw.ElapsedMilliseconds} ms'", this, AxoApplication.Current.ControllerIdentity);
        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteEntityExist(string identifier)
    {
        sw.Restart();
        //await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);
        var retVal = Repository.Exists(identifier);
        sw.Stop();
        AxoApplication.Current.Logger.Information($"Information about record '{identifier}' existence in '{this.Symbol}' retrieved in '{sw.ElapsedMilliseconds} ms'", this, AxoApplication.Current.ControllerIdentity);
        return retVal;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteCreateOrUpdate(string identifier)
    {
        sw.Restart();
       // await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);

        var cloned = await ((ITwinObject)DataEntity).OnlineToPlain<TPlain>();

        cloned.Hash = HashHelper.CreateHash(cloned);

        if (Repository.Exists(identifier))
        {
            Repository.Update(identifier, cloned);
        }
        else
        {
            Repository.Create(identifier, cloned);
        }

        sw.Stop();
        AxoApplication.Current.Logger.Information($"Record '{identifier}' created in '{this.Symbol}' in '{sw.ElapsedMilliseconds} ms' using `Create or update` function.", this, AxoApplication.Current.ControllerIdentity);

        return true;
    }

    private PropertyInfo? GetDataSetPropertyInfo<TA>() where TA : Attribute
    {
        var properties = GetType().GetProperties();
        PropertyInfo? DataPropertyInfo = null;

        // iterate properties and look for AxoDataEntityAttribute
        foreach (var prop in properties)
        {
            var attr = prop.GetCustomAttribute<TA>();
            if (attr != null)
            {
                //if already set, that means multiple data attributes are present, we want to throw error
                if (DataPropertyInfo != null)
                    throw new MultipleDataEntityAttributeException(
                        $"{GetType()} contains multiple {nameof(TA)}s! Make sure it contains only one.");
                DataPropertyInfo = prop;
                break;
            }
        }

        if (DataPropertyInfo == null)
            throw new Exception($"There is no member annotated with '{nameof(AxoDataEntityAttribute)}' in '{Symbol}'.");

        return DataPropertyInfo;
    }

    private ICrudDataObject? GetDataSetProperty<TA>() where TA : Attribute
    {
        var dataObjectPropertyInfo = GetDataSetPropertyInfo<TA>();
        var dataObject = dataObjectPropertyInfo?.GetValue(this) as AxoDataEntity;
        if (dataObject == null)
            throw new Exception(
                $"Data member annotated with '{nameof(TA)}' in '{Symbol}'  does not inherit from '{nameof(AxoDataEntity)}'");

        return dataObject;
    }

    /// <summary>
    ///     Sets repository for this instance of <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    /// <param name="repository"></param>
    public void SetRepository(IRepository<TPlain> repository)
    {
        DataRepository = repository;
    }

    /// <summary>
    ///     Initializes data exchange between remote controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    public async Task InitializeRemoteDataExchange()
    {
        Operation.InitializeExclusively(Handle);
        await this.WriteAsync();
        //_idExistsTask.InitializeExclusively(Exists);
        //_createOrUpdateTask.Initialize(CreateOrUpdate);
    }

    /// <summary>
    ///     Initializes data exchange between remote controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    /// <param name="repository">Repository to be associated with this <see cref="AxoDataExchange{TOnline,TPlain}" /></param>
    public async Task InitializeRemoteDataExchange(IRepository<TPlain> repository)
    {
        SetRepository(repository);
        await InitializeRemoteDataExchange();
    }

    /// <summary>
    ///     Terminates data exchange between controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    public async Task DeInitializeRemoteDataExchange()
    {
        Operation.DeInitialize();
        await this.WriteAsync();
        //_idExistsTask.InitializeExclusively(Exists);
        //_createOrUpdateTask.Initialize(CreateOrUpdate);
    }

    private async Task Handle()
    {
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

    private async Task<bool> RemoteCreate()
    {
        var Identifier = await Operation.DataEntityIdentifier.GetAsync();
        return await RemoteCreate(Identifier);
    }

    private async Task<bool> RemoteRead()
    {
        var Identifier = await Operation.DataEntityIdentifier.GetAsync();
        return await RemoteRead(Identifier);
    }

    /// <summary>
    ///    Creates new record in the repository.
    /// </summary>
    /// <param name="identifier">Unique identifier</param>
    /// <param name="plainDataObject">Data object from which the record will be created.</param>
    /// <returns></returns>
    public async Task CreateAsync(string identifier, TPlain plainDataObject)
    {
        await Task.Run(() => Repository?.Create(identifier, plainDataObject));
    }

    /// <summary>
    ///   Reads record from the repository.
    /// </summary>
    /// <param name="identifier">Unique identifier</param>
    /// <returns>Plain data object retrieved from the repository.</returns>
    public async Task<TPlain> ReadAsync(string identifier)
    {
        return await Task.Run(() => DataRepository.Read(identifier));
    }

    /// <summary>
    ///  Updates record in the repository.
    ///  >[!IMPORTANT]
    ///  > In most scenarios all data from the data object will be updated.
    ///  > Verify the specific repository behaviour to prevent data loss.
    /// </summary>
    /// <param name="identifier">Identifier of the document/record to update.</param>
    /// <param name="plainDataObject">Data object from which the data will be updated.</param>
    /// <returns></returns>
    public async Task UpdateAsync(string identifier, TPlain plainDataObject)
    {
        await Task.Run(() => Repository.Update(identifier, plainDataObject));
    }

    /// <summary>
    /// Deletes record from the repository.
    /// </summary>
    /// <param name="identifier">Identifier of the record/document to be deleted.</param>
    /// <returns></returns>
    public async Task DeleteAsync(string identifier)
    {
        await Task.Run(() => Repository.Delete(identifier));
    }

    /// <summary>
    /// Checks if the record exists in the repository.
    /// </summary>
    /// <param name="identifier">Identifier of the record/document.</param>
    /// <returns>True if the record was found.</returns>
    public async Task<bool> EntityExistAsync(string identifier)
    {
        return await Task.Run(() => Repository.Exists(identifier));
    }

    /// <summary>
    /// Creates or updates new record in the repository.
    /// </summary>
    /// <param name="identifier">Document/Record identifier.</param>
    /// <param name="plainDataObject">Data object from which the data will be retrieved.</param>
    /// <returns></returns>
    public async Task CreateOrUpdateAsync(string identifier, TPlain plainDataObject)
    {
        await Task.Run(() =>
        {
            if (Repository.Exists(identifier))
            {
                Repository.Update(identifier, plainDataObject);
            }
            else
            {
                Repository.Create(identifier, plainDataObject);
            }
        });
    }

    /// <inheritdoc />
    public async Task CreateNewAsync(string identifier, ITwinObject dataObject)
    {
        Pocos.AXOpen.Data.IAxoDataEntity poco = (Pocos.AXOpen.Data.IAxoDataEntity)dataObject.CreatePoco();
        poco.DataEntityId = identifier;
        poco.Hash = HashHelper.CreateHash(poco);

        this.Repository.Create(identifier, poco);

        var plain = Repository.Read(identifier);
        dataObject.PlainToShadow(plain);
    }

    /// <inheritdoc />
    public async Task FromRepositoryToShadowsAsync(IBrowsableDataObject entity, ITwinObject dataObject)
    {
        var record = Repository.Read(entity.DataEntityId);
        await dataObject.PlainToShadow(record);
        ((AxoDataEntity)dataObject).Hash = record.Hash;
        ((AxoDataEntity)dataObject).Changes = record.Changes;
    }

    /// <inheritdoc />
    public async Task UpdateFromShadowsAsync(ITwinObject dataObject)
    {
        var plainer = await ((ITwinObject)dataObject).ShadowToPlain<dynamic>();
        ChangeTrackerSaveObservedChanges(plainer, dataObject);
        plainer.Hash = HashHelper.CreateHash(plainer);
        Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
    }

    /// <inheritdoc />
    public async Task FromRepositoryToControllerAsync(IBrowsableDataObject selected, ITwinObject dataObject)
    {
        await dataObject.PlainToOnline(Repository.Read(selected.DataEntityId));
    }

    /// <inheritdoc />
    public async Task CreateDataFromControllerAsync(string recordId, ITwinObject dataObject)
    {
        var plainer = await dataObject.OnlineToPlain<dynamic>();
        plainer.DataEntityId = recordId;
        plainer.Hash = HashHelper.CreateHash(plainer);
        Repository.Create(plainer.DataEntityId, plainer);
        var plain = Repository.Read(plainer.DataEntityId);
        dataObject.PlainToShadow(plain);
    }

    /// <inheritdoc />
    public async Task Delete(string identifier)
    {
        Repository.Delete(identifier);
    }

    /// <inheritdoc />
    public async Task CreateCopyCurrentShadowsAsync(string recordId, ITwinObject dataObject)
    {
        var source = (Pocos.AXOpen.Data.IAxoDataEntity)await dataObject.ShadowToPlain<IBrowsableDataObject>();
        source.DataEntityId = recordId;
        source.Hash = HashHelper.CreateHash(source);
        Repository.Create(source.DataEntityId, source);
    }

    private Dictionary<string, Type> _exporters;

    /// <inheritdoc />
    public Dictionary<string, Type> Exporters
    {
        get
        {
            if (_exporters == null)
                _exporters = FindAllExporters();
            return _exporters;
        }
    }

    private Dictionary<string, Type> FindAllExporters()
    {
        var dictionary = new Dictionary<string, Type>();

        List<Type> types = new List<Type>();

        // Some reflection on some assemblies may produce
        foreach (var assembly in LoadAssemblies())
        {
            try
            {
                foreach (var tp in assembly.GetTypes())
                {
                    try
                    {
                        if (tp.GetInterfaces().Where(i => i.Name.Contains(typeof(IDataExporter<TPlain, TOnline>).Name)).Any())
                        {
                            types.Add(tp);
                        }
                    }
                    catch (ReflectionTypeLoadException ex)
                    {
                        // Swallow
                    }
                }
            }
            catch (ReflectionTypeLoadException ex)
            {
                //Swallow
            }
        }

        //LoadAssemblies().ForEach(assembly =>
        //    types.AddRange(assembly.GetTypes()
        //        .Where(type => type.GetInterfaces().Where(i => i.Name.Contains(typeof(IDataExporter<TPlain, TOnline>).Name)).Any())));

        foreach (var type in types)
        {
            var value = "";
            var genericType = type.MakeGenericType(typeof(TPlain), typeof(TOnline));
            var methodInfo = genericType.GetMethod("GetName");
            if (methodInfo != null)
            {
                value = (string)methodInfo.Invoke(null, null);
            }
            if (value == "" || value == null)
            {
                value = genericType.Name.Substring(0, genericType.Name.IndexOf("Data"));
            }

            dictionary.TryAdd(value, genericType);
        }

        return dictionary;
    }

    private List<Assembly> LoadAssemblies()
    {
        var loadedAssemblies = AppDomain
            .CurrentDomain
            .GetAssemblies()
            .Prepend(Assembly.GetExecutingAssembly())
            .ToList();
        var loadedPaths = loadedAssemblies.Where(p => !p.IsDynamic).Select(a => a.Location).ToArray();
        var referencedPaths = Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll");
        var toLoad = referencedPaths.Where(r => !loadedPaths.Contains(r, StringComparer.InvariantCultureIgnoreCase)).ToList();
        toLoad.ForEach(path =>
        {
            try
            {
                loadedAssemblies.Add(AppDomain.CurrentDomain.Load(AssemblyName.GetAssemblyName(path)));
            }
            catch (System.BadImageFormatException)
            {
                // Ignore
            }
            catch (System.IO.FileLoadException)
            {
                // Ignore
            }
        });
        return loadedAssemblies;
    }

    /// <inheritdoc />
    public void ExportData(string path, Dictionary<string, ExportData>? customExportData = null, eExportMode exportMode = eExportMode.First, uint firstNumber = 50, uint secondNumber = 100, string exportFileType = "CSV", char separator = ';')
    {
        if (customExportData == null)
            customExportData = new Dictionary<string, ExportData>();

        IDataExporter<TPlain, TOnline> dataExporter = Activator.CreateInstance(Exporters[exportFileType]) as IDataExporter<TPlain, TOnline>;

        if (Path.GetExtension(path).Equals(".zip", StringComparison.OrdinalIgnoreCase))
        {
            if (Directory.Exists(Path.GetDirectoryName(path) + "\\exportDataPrepare"))
                Directory.Delete(Path.GetDirectoryName(path) + "\\exportDataPrepare", true);

            Directory.CreateDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare");

            File.Delete(path);

            ExportData exportData = customExportData.GetValueOrDefault(typeof(TOnline).ToString(), new ExportData(true, new Dictionary<string, bool>()));
            if (exportData.Exported)
                dataExporter.Export(DataRepository, Path.GetDirectoryName(path) + "\\exportDataPrepare", this.SymbolTail, p => true, exportData.Data, exportMode, firstNumber, secondNumber, separator);

            ZipFile.CreateFromDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare", path);
        }
        else
        {
            ExportData exportData = customExportData.GetValueOrDefault(typeof(TOnline).ToString(), new ExportData(true, new Dictionary<string, bool>()));
            if (exportData.Exported)
                dataExporter.Export(DataRepository, path, this.SymbolTail, p => true, exportData.Data, exportMode, firstNumber, secondNumber, separator);
        }
    }

    /// <inheritdoc />
    public void ImportData(string path, AuthenticationState authenticationState, ITwinObject crudDataObject = null, string exportFileType = "CSV", char separator = ';')
    {
        IDataExporter<TPlain, TOnline> dataExporter = Activator.CreateInstance(Exporters[exportFileType]) as IDataExporter<TPlain, TOnline>;

        if (Path.GetExtension(path).Equals(".zip", StringComparison.OrdinalIgnoreCase))
        {
            if (Directory.Exists(Path.GetDirectoryName(path) + "\\importDataPrepare"))
                Directory.Delete(Path.GetDirectoryName(path) + "\\importDataPrepare", true);

            Directory.CreateDirectory(Path.GetDirectoryName(path) + "\\importDataPrepare");

            ZipFile.ExtractToDirectory(path, Path.GetDirectoryName(path) + "\\importDataPrepare");

            dataExporter.Import(DataRepository, Path.GetDirectoryName(path) + "\\importDataPrepare", this.SymbolTail, authenticationState, crudDataObject, separator);

            if (Directory.Exists(Path.GetDirectoryName(path)))
                Directory.Delete(Path.GetDirectoryName(path), true);
        }
        else
        {
            dataExporter.Import(DataRepository, path, this.SymbolTail, authenticationState, crudDataObject, separator);
        }
    }

    /// <inheritdoc />
    public async Task<bool> ExistsAsync(string recordId)
    {
        return Repository.Exists(recordId);
    }

    /// <inheritdoc />
    public async Task CreateOrUpdate(string recordId, ITwinObject dataObject)
    {
        if (Repository.Exists(recordId))
        {
            var plainer = await ((ITwinObject)dataObject).ShadowToPlain<dynamic>();
            ChangeTrackerSaveObservedChanges(plainer, dataObject);
            plainer.Hash = HashHelper.CreateHash(plainer);
            Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
        }
        else
        {
            Pocos.AXOpen.Data.IAxoDataEntity poco = (Pocos.AXOpen.Data.IAxoDataEntity)dataObject.CreatePoco();
            poco.DataEntityId = recordId;
            poco.Hash = HashHelper.CreateHash(poco);

            this.Repository.Create(recordId, poco);
            var plain = Repository.Read(recordId);
            dataObject.PlainToShadow(plain);
        }
    }
}
// ix_ax_axopen_data
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using System.IO.Compression;
using System.Linq;
using System.Linq.Expressions;
using System.Numerics;
using System.Reflection;
using System.Security.Claims;
using System.Security.Principal;
using System.Threading.Tasks;
using AXOpen.Base.Data;
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
    private TOnline _dataEntity;

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

    public ICrudDataObject? CrudDataObject
    {
        get
        {
            return ((dynamic)DataEntity) as ICrudDataObject;
        }
    }

    private bool? _verifyHash = null;

    public bool VerifyHash
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
    public void ChangeTrackerStopObservingChanges()
    {
        CrudDataObject?.ChangeTracker.StopObservingChanges();
    }

    /// <summary>
    /// Start observing changes of the data object with changeTracker.
    /// </summary>
    /// <param name="authenticationState">Authentication state of current logged user.</param>
    public void ChangeTrackerStartObservingChanges(AuthenticationState authenticationState)
    {
        CrudDataObject?.ChangeTracker.StartObservingChanges(authenticationState);
    }

    /// <summary>
    /// Saves observed changes from changeTracker to object.
    /// </summary>
    /// <param name="plainObject"></param>
    public void ChangeTrackerSaveObservedChanges(IBrowsableDataObject plainObject)
    {
        CrudDataObject?.ChangeTracker.SaveObservedChanges(plainObject);
    }

    /// <summary>
    /// Sets changes to changeTracker.
    /// </summary>
    /// <param name="entity">Entity from which is set data.</param>
    public void ChangeTrackerSetChanges()
    {
        CrudDataObject.Changes = ((AxoDataEntity)RefUIData).Changes;
    }

    /// <summary>
    /// Gets changes from changeTracker.
    /// </summary>
    /// <returns>List of ValueChangeItem that contains changes.</returns>
    public List<ValueChangeItem> ChangeTrackerGetChanges()
    {
        return CrudDataObject.Changes;
    }

    /// <summary>
    /// Get object which locked this repository.
    /// </summary>
    /// <param name="by"></param>
    public object? GetLockedBy()
    {
        return DataEntity.LockedBy;
    }

    /// <summary>
    /// Set object which locked this repository.
    /// </summary>
    /// <param name="by"></param>
    public void SetLockedBy(object by)
    {
        DataEntity.LockedBy = by;
    }

    public bool IsHashCorrect(IIdentity identity)
    {
        if (!VerifyHash)
            return true;

        var poco = RefUIData.CreatePoco().ShadowToPlain1<TPlain>(RefUIData);

        poco.Changes = ((AxoDataEntity)RefUIData).Changes;
        poco.Hash = ((AxoDataEntity)RefUIData).Hash;

        return HashHelper.VerifyHash(poco, identity);
    }

    /// <summary>
    ///     Get strongly typed repository associated with this <see cref="AxoDataExchange{TOnline,TPlain}" />.
    /// </summary>
    public IRepository<TPlain> DataRepository { get; private set; }

    /// <summary>
    ///     Gets <see cref="AxoDataEntity" /> as <see cref="ITwinObject" /> that provides exchange mechanisms between this
    ///     <see cref="AxoDataExchange{TOnline,TPlain}" /> and controller.
    /// </summary>
    public ITwinObject RefUIData => DataEntity as ITwinObject;


    /// <inheritdoc />
    public IRepository? Repository => DataRepository as IRepository;

    /// <inheritdoc />
    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip,
        eSearchMode searchMode)
    {
        return DataRepository.GetRecords(identifier, limit, skip, searchMode).Cast<IBrowsableDataObject>();
    }

    /// <inheritdoc />
    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier)
    {
        return DataRepository.GetRecords(identifier).Cast<IBrowsableDataObject>();
    }

    /// <inheritdoc />
    public bool RemoteCreate(string identifier)
    {
        Operation.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        var cloned = ((ITwinObject)DataEntity).OnlineToPlain<TPlain>().Result;
        cloned.Hash = HashHelper.CreateHash(cloned);

        Repository.Create(identifier, cloned);
        return true;
    }

    /// <inheritdoc />
    public bool RemoteRead(string identifier)
    {
        try
        {
            Operation.ReadAsync().Wait();
            var record = Repository.Read(identifier);
            ((ITwinObject)DataEntity).PlainToOnline(record).Wait();
            return true;
        }
        catch (Exception exception)
        {
            throw;
        }
    }

    /// <inheritdoc />
    public bool RemoteUpdate(string identifier)
    {
        Operation.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        var cloned = ((ITwinObject)DataEntity).OnlineToPlain<TPlain>().Result;
        cloned.Hash = HashHelper.CreateHash(cloned);
        Repository.Update(identifier, cloned);
        return true;
    }

    /// <inheritdoc />
    public bool RemoteDelete(string identifier)
    {
        Operation.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        Repository.Delete(identifier);
        return true;
    }

    /// <inheritdoc />
    public bool RemoteEntityExist(string identifier)
    {
        Operation.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        return Repository.Exists(identifier);
    }

    /// <inheritdoc />
    public bool RemoteCreateOrUpdate(string identifier)
    {
        Operation.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        var cloned = ((ITwinObject)DataEntity).OnlineToPlain<TPlain>().Result;
        cloned.Hash = HashHelper.CreateHash(cloned);

        if (Repository.Exists(identifier))
        {
            Repository.Update(identifier, cloned);
        }
        else
        {
            Repository.Create(identifier, cloned);
        }
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
    public void InitializeRemoteDataExchange()
    {
        Operation.InitializeExclusively(Handle);
        this.WriteAsync().Wait();
        //_idExistsTask.InitializeExclusively(Exists);
        //_createOrUpdateTask.Initialize(CreateOrUpdate);
    }

    /// <summary>
    ///     Initializes data exchange between remote controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    /// <param name="repository">Repository to be associated with this <see cref="AxoDataExchange{TOnline,TPlain}" /></param>
    public void InitializeRemoteDataExchange(IRepository<TPlain> repository)
    {
        SetRepository(repository);
        InitializeRemoteDataExchange();
    }

    /// <summary>
    ///     Terminates data exchange between controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    public void DeInitializeRemoteDataExchange()
    {
        Operation.DeInitialize();
        this.WriteAsync().Wait();
        //_idExistsTask.InitializeExclusively(Exists);
        //_createOrUpdateTask.Initialize(CreateOrUpdate);
    }

    private async void Handle()
    {
        Operation.ReadAsync().Wait();
        var operation = (eCrudOperation)Operation.CrudOperation.LastValue;
        var identifier = Operation.DataEntityIdentifier.LastValue;

        switch (operation)
        {
            case eCrudOperation.Create:
                this.RemoteCreate(identifier);
                break;
            case eCrudOperation.Read:
                this.RemoteRead(identifier);
                break;
            case eCrudOperation.Update:
                this.RemoteUpdate(identifier);
                break;
            case eCrudOperation.Delete:
                this.RemoteDelete(identifier);
                break;
            case eCrudOperation.CreateOrUpdate:
                this.RemoteCreateOrUpdate(identifier);
                break;
            case eCrudOperation.EntityExist:
                var result = this.RemoteEntityExist(identifier);
                await Operation._exist.SetAsync(result);
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    private bool RemoteCreate()
    {
        return RemoteCreate(Operation.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteRead()
    {
        return RemoteRead(Operation.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteUpdate()
    {
        return RemoteUpdate(Operation.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteDelete()
    {
        return RemoteDelete(Operation.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteEntityExist()
    {
        return RemoteEntityExist(Operation.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteCreateOrUpdate()
    {
        return RemoteCreateOrUpdate(Operation.DataEntityIdentifier.GetAsync().Result);
    }

    public async Task CreateAsync(string identifier, TPlain plain)
    {
        await Task.Run(() => Repository?.Create(identifier, plain));
    }

    public async Task<TPlain> ReadAsync(string identifier)
    {
        return await Task.Run(() => DataRepository.Read(identifier));
    }

    public async Task UpdateAsync(string identifier, TPlain data)
    {
        await Task.Run(() => Repository.Update(identifier, data));
    }

    public async Task DeleteAsync(string identifier)
    {
        await Task.Run(() => Repository.Delete(identifier));
    }

    public async Task<bool> EntityExistAsync(string identifier)
    {
        return await Task.Run(() => Repository.Exists(identifier));
    }

    public async Task CreateOrUpdateAsync(string identifier, TPlain data)
    {
        await Task.Run(() =>
        {
            if (Repository.Exists(identifier))
            {
                Repository.Update(identifier, data);
            }
            else
            {
                Repository.Create(identifier, data);
            }
        });
    }

    /// <inheritdoc />
    public async Task CreateNewAsync(string identifier)
    {
        Pocos.AXOpen.Data.IAxoDataEntity poco = (Pocos.AXOpen.Data.IAxoDataEntity)this.RefUIData.CreatePoco();
        poco.DataEntityId = identifier;
        poco.Hash = HashHelper.CreateHash(poco);

        this.Repository.Create(identifier, poco);

        var plain = Repository.Read(identifier);
        RefUIData.PlainToShadow(plain);
    }

    /// <inheritdoc />
    public async Task FromRepositoryToShadowsAsync(IBrowsableDataObject entity)
    {
        var record = Repository.Read(entity.DataEntityId);
        await this.RefUIData.PlainToShadow(record);
        ((AxoDataEntity)this.RefUIData).Hash = record.Hash;
        ((AxoDataEntity)this.RefUIData).Changes = record.Changes;
    }

    /// <inheritdoc />
    public async Task UpdateFromShadowsAsync()
    {
        var plainer = await ((ITwinObject)RefUIData).ShadowToPlain<dynamic>();
        ChangeTrackerSaveObservedChanges(plainer);
        plainer.Hash = HashHelper.CreateHash(plainer);
        Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
    }

    /// <inheritdoc />
    public async Task FromRepositoryToControllerAsync(IBrowsableDataObject selected)
    {
        await RefUIData.PlainToOnline(Repository.Read(selected.DataEntityId));
    }

    /// <inheritdoc />
    public async Task CreateDataFromControllerAsync(string recordId)
    {
        var plainer = await RefUIData.OnlineToPlain<dynamic>();
        plainer.DataEntityId = recordId;
        plainer.Hash = HashHelper.CreateHash(plainer);
        Repository.Create(plainer.DataEntityId, plainer);
        var plain = Repository.Read(plainer.DataEntityId);
        RefUIData.PlainToShadow(plain);
    }

    /// <inheritdoc />
    public async Task Delete(string identifier)
    {
        Repository.Delete(identifier);
    }

    /// <inheritdoc />
    public async Task CreateCopyCurrentShadowsAsync(string recordId)
    {
        var source = (Pocos.AXOpen.Data.IAxoDataEntity)await RefUIData.ShadowToPlain<IBrowsableDataObject>();
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

        LoadAssemblies().ForEach(assembly => types.AddRange(assembly.GetTypes().Where(type => type.GetInterfaces().Where(i => i.Name.Contains(typeof(IDataExporter<TPlain, TOnline>).Name)).Any())));

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
    public void ExportData(string path, Dictionary<string, ExportData>? customExportData = null, eExportMode exportMode = eExportMode.First, int firstNumber = 50, int secondNumber = 100, string exportFileType = "CSV", char separator = ';')
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

            ExportData exportData = customExportData.GetValueOrDefault(RefUIData.ToString(), new ExportData(true, new Dictionary<string, bool>()));
            if (exportData.Exported)
                dataExporter.Export(DataRepository, Path.GetDirectoryName(path) + "\\exportDataPrepare", this.SymbolTail, p => true, exportData.Data, exportMode, firstNumber, secondNumber, separator);

            ZipFile.CreateFromDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare", path);
        }
        else
        {
            ExportData exportData = customExportData.GetValueOrDefault(RefUIData.ToString(), new ExportData(true, new Dictionary<string, bool>()));
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
    public async Task CreateOrUpdate(string recordId)
    {
        if (Repository.Exists(recordId))
        {
            var plainer = await ((ITwinObject)RefUIData).ShadowToPlain<dynamic>();
            ChangeTrackerSaveObservedChanges(plainer);
            plainer.Hash = HashHelper.CreateHash(plainer);
            Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
        }
        else
        {
            Pocos.AXOpen.Data.IAxoDataEntity poco = (Pocos.AXOpen.Data.IAxoDataEntity)this.RefUIData.CreatePoco();
            poco.DataEntityId = recordId;
            poco.Hash = HashHelper.CreateHash(poco);

            this.Repository.Create(recordId, poco);
            var plain = Repository.Read(recordId);
            RefUIData.PlainToShadow(plain);
        }
    }
}
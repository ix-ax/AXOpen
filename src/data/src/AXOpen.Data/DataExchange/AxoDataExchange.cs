// ix_ax_axopen_data
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using System.IO.Compression;
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
            if(_verifyHash != null)
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
    public void ChangeTrackerSetChanges(IBrowsableDataObject entity)
    {
        CrudDataObject.Changes = Repository.Read(entity.DataEntityId).Changes;
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

    public bool IsHashCorrect(IBrowsableDataObject entity, IIdentity identity)
    {
        if (!VerifyHash)
            return true;
        if (entity.DataEntityId == null)
            return false;
        return HashHelper.VerifyHash(Repository.Read(entity.DataEntityId), identity);
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
    public async Task<bool> RemoteCreate(string identifier)
    {
        await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);

        var cloned = await ((ITwinObject)DataEntity).OnlineToPlain<TPlain>();

        Repository.Create(identifier, cloned);

        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteRead(string identifier)
    {
        try
        {
            await Operation.ReadAsync();
            var record = Repository.Read(identifier);
            await ((ITwinObject)DataEntity).PlainToOnline(record);
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
        await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);
        
        var cloned = await ((ITwinObject)DataEntity).OnlineToPlain<TPlain>();

        cloned.Hash = HashHelper.CreateHash(cloned);
        Repository.Update(identifier, cloned);
        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteDelete(string identifier)
    {
        await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);
        Repository.Delete(identifier);
        return true;
    }

    /// <inheritdoc />
    public async Task<bool> RemoteEntityExist(string identifier)
    {
        await Operation.ReadAsync();
        await DataEntity.DataEntityId.SetAsync(identifier);
        return Repository.Exists(identifier);
    }

    /// <inheritdoc />
    public async Task<bool> RemoteCreateOrUpdate(string identifier)
    {
        await Operation.ReadAsync();
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
        await Operation.ReadAsync();
        var operation = (eCrudOperation)Operation.CrudOperation.LastValue;
        var identifier = Operation.DataEntityIdentifier.LastValue;

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
        return  await RemoteCreate(Identifier);
    }

    private async Task<bool> RemoteRead()
    {
        var Identifier = await Operation.DataEntityIdentifier.GetAsync();
        return await RemoteRead(Identifier);
    }

    private async Task<bool> RemoteUpdate()
    {
        var Identifier = await Operation.DataEntityIdentifier.GetAsync();
        return await RemoteUpdate(Identifier);
    }

    private async Task<bool> RemoteDelete()
    {
        var Identifier = await Operation.DataEntityIdentifier.GetAsync();
        return await RemoteDelete(Identifier);
    }

    private async Task<bool> RemoteEntityExist()
    {
        var Identifier = await Operation.DataEntityIdentifier.GetAsync();
        return await RemoteEntityExist(Identifier);
    }

    private async Task<bool> RemoteCreateOrUpdate()
    {
        var Identifier = await Operation.DataEntityIdentifier.GetAsync();
        return await RemoteCreateOrUpdate(Identifier);
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
        await this.RefUIData.PlainToShadow(Repository.Read(entity.DataEntityId));
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
        foreach (var type in Assembly.GetEntryAssembly().GetTypes().Concat(Assembly.GetExecutingAssembly().GetTypes()))
        {
            if (type.GetInterfaces().Where(i => i.Name.Contains(typeof(IDataExporter<TPlain, TOnline>).Name)).Any())
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

                dictionary.Add(value, genericType);
            }
        }

        return dictionary;
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
                dataExporter.Export(DataRepository, Path.GetDirectoryName(path) + "\\exportDataPrepare\\" + this.ToString(), p => true, exportData.Data, exportMode, firstNumber, secondNumber, separator);

            ZipFile.CreateFromDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare", path);
        }
        else
        {
            ExportData exportData = customExportData.GetValueOrDefault(RefUIData.ToString(), new ExportData(true, new Dictionary<string, bool>()));
            if (exportData.Exported)
                dataExporter.Export(DataRepository, path, p => true, exportData.Data, exportMode, firstNumber, secondNumber, separator);
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

            var files = Directory.GetFiles(Path.GetDirectoryName(path) + "\\importDataPrepare", this.ToString() + "*");

            if (files == null || files.Length == 0)
                return;

            dataExporter.Import(DataRepository, Path.GetDirectoryName(path) + "\\importDataPrepare\\" + this.ToString(), authenticationState, crudDataObject, separator);

            if (Directory.Exists(Path.GetDirectoryName(path)))
                Directory.Delete(Path.GetDirectoryName(path), true);
        }
        else
        {
            var files = Directory.GetFiles(Path.GetDirectoryName(path), this.ToString() + "*");

            if (files == null || files.Length == 0)
                return;

            dataExporter.Import(DataRepository, path, authenticationState, crudDataObject, separator);
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
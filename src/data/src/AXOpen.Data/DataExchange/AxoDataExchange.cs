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
using AXOpen.Base.Data;
using AXSharp.Connector;
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
        CreateTask.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        var cloned = ((ITwinObject)DataEntity).OnlineToPlain<TPlain>().Result;

        Repository.Create(identifier, cloned);
        return true;
    }

    /// <inheritdoc />
    public bool RemoteRead(string identifier)
    {
        try
        {
            ReadTask.ReadAsync().Wait();
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
        UpdateTask.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        var cloned = ((ITwinObject)DataEntity).OnlineToPlain<TPlain>().Result;
        Repository.Update(identifier, cloned);
        return true;
    }

    /// <inheritdoc />
    public bool RemoteDelete(string identifier)
    {
        DeleteTask.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        Repository.Delete(identifier);
        return true;
    }

    /// <inheritdoc />
    public bool RemoteEntityExist(string identifier)
    {
        EntityExistTask.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        return Repository.Exists(identifier);
    }

    /// <inheritdoc />
    public bool RemoteCreateOrUpdate(string identifier)
    {
        CreateOrUpdateTask.ReadAsync().Wait();
        DataEntity.DataEntityId.SetAsync(identifier).Wait();
        var cloned = ((ITwinObject)DataEntity).OnlineToPlain<TPlain>().Result;

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
        CreateTask.InitializeExclusively(RemoteCreate);
        ReadTask.InitializeExclusively(RemoteRead);
        UpdateTask.InitializeExclusively(RemoteUpdate);
        DeleteTask.InitializeExclusively(RemoteDelete);
        EntityExistTask.InitializeExclusively(RemoteEntityExist);
        CreateOrUpdateTask.InitializeExclusively(RemoteCreateOrUpdate);
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
        CreateTask.DeInitialize();
        ReadTask.DeInitialize();
        UpdateTask.DeInitialize();
        DeleteTask.DeInitialize();
        EntityExistTask.DeInitialize();
        CreateOrUpdateTask.DeInitialize();
        this.WriteAsync().Wait();
        //_idExistsTask.InitializeExclusively(Exists);
        //_createOrUpdateTask.Initialize(CreateOrUpdate);
    }

    private bool RemoteCreate()
    {
        return RemoteCreate(CreateTask.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteRead()
    {
        return RemoteRead(ReadTask.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteUpdate()
    {
        return RemoteUpdate(UpdateTask.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteDelete()
    {
        return RemoteDelete(DeleteTask.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteEntityExist()
    {
        return RemoteEntityExist(EntityExistTask.DataEntityIdentifier.GetAsync().Result);
    }

    private bool RemoteCreateOrUpdate()
    {
        return RemoteCreateOrUpdate(CreateOrUpdateTask.DataEntityIdentifier.GetAsync().Result);
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
        this.Repository.Create(identifier, this.RefUIData.CreatePoco());
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
        //CrudData.ChangeTracker.SaveObservedChanges(plainer);
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
        var source = await RefUIData.ShadowToPlain<IBrowsableDataObject>();
        source.DataEntityId = recordId;
        Repository.Create(source.DataEntityId, source);
    }

    /// <inheritdoc />
    public void ExportData(string path, char separator = ';')
    {
        if (Path.GetExtension(path).Equals(".zip", StringComparison.OrdinalIgnoreCase))
        {
            if (Directory.Exists(Path.GetDirectoryName(path) + "\\exportDataPrepare"))
                Directory.Delete(Path.GetDirectoryName(path) + "\\exportDataPrepare", true);

            Directory.CreateDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare");

            File.Delete(path);

            IDataExporter<TPlain, TOnline> dataExporter = new CSVDataExporter<TPlain, TOnline>();
            dataExporter.Export(DataRepository, Path.GetDirectoryName(path) + "\\exportDataPrepare\\" + this.ToString(), p => true, separator);

            ZipFile.CreateFromDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare", path);
        }
        else
        {
            IDataExporter<TPlain, TOnline> dataExporter = new CSVDataExporter<TPlain, TOnline>();
            dataExporter.Export(DataRepository, path, p => true, separator);
        }
    }

    /// <inheritdoc />
    public void ImportData(string path, ITwinObject crudDataObject = null, char separator = ';')
    {
        if (Path.GetExtension(path).Equals(".zip", StringComparison.OrdinalIgnoreCase))
        {
            if (Directory.Exists(Path.GetDirectoryName(path) + "\\importDataPrepare"))
                Directory.Delete(Path.GetDirectoryName(path) + "\\importDataPrepare", true);

            Directory.CreateDirectory(Path.GetDirectoryName(path) + "\\importDataPrepare");

            ZipFile.ExtractToDirectory(path, Path.GetDirectoryName(path) + "\\importDataPrepare");

            IDataExporter<TPlain, TOnline> dataExporter = new CSVDataExporter<TPlain, TOnline>();
            dataExporter.Import(DataRepository, Path.GetDirectoryName(path) + "\\importDataPrepare\\" + this.ToString(), crudDataObject, separator);

            if (Directory.Exists(Path.GetDirectoryName(path)))
                Directory.Delete(Path.GetDirectoryName(path), true);
        }
        else
        {
            IDataExporter<TPlain, TOnline> dataExporter = new CSVDataExporter<TPlain, TOnline>();
            dataExporter.Import(DataRepository, path, crudDataObject, separator);
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
            //CrudData.ChangeTracker.SaveObservedChanges(plainer);
            Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
        }
        else
        {
            this.Repository.Create(recordId, this.RefUIData.CreatePoco());
            var plain = Repository.Read(recordId);
            RefUIData.PlainToShadow(plain);
        }
    }
}
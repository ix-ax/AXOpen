// axosimple
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using System.Collections.Generic;
using System.IO.Compression;
using System.Linq.Expressions;
using System.Reflection;
using AXOpen.Base.Data;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes.Online;
using Microsoft.AspNetCore.Components.Authorization;

namespace AXOpen.Data;

public partial class AxoDataFragmentExchange
{
    protected IAxoDataExchange[] DataFragments { get; private set; }

    public T? CreateBuilder<T>() where T : AxoDataFragmentExchange
    {
        return CreateBuilder() as T;
    }

    public object CreateBuilder()
    {
        DataFragments = GetDataSetProperty<AxoDataFragmentAttribute, IAxoDataExchange>().ToArray();
        RefUIData = new AxoFragmentedDataCompound(this, DataFragments.Select(p => p.RefUIData).Cast<ITwinElement>().ToList());
        Repository = new AxoCompoundRepository(DataFragments);
        return this;
    }

    /// <summary>
    ///     Initializes data exchange between remote controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
    /// </summary>
    public void InitializeRemoteDataExchange()
    {
        Operation.InitializeExclusively(Handle);
        this.WriteAsync().Wait();
    }

    public void DeInitializeRemoteDataExchange()
    {
        Operation.DeInitialize();
        this.WriteAsync().Wait();
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

    public IRepository? Repository { get; private set; }

    public ITwinObject RefUIData { get; private set; }

    /// <summary>
    /// Stop observing changes of the data object with changeTracker.
    /// </summary>
    public void ChangeTrackerStopObservingChanges()
    {
        foreach (var fragment in DataFragments)
        {
            fragment.ChangeTrackerStopObservingChanges();
        }
    }

    /// <summary>
    /// Start observing changes of the data object with changeTracker.
    /// </summary>
    /// <param name="authenticationState">Authentication state of current logged user.</param>
    public void ChangeTrackerStartObservingChanges(AuthenticationState authenticationState)
    {
        foreach (var fragment in DataFragments)
        {
            fragment.ChangeTrackerStartObservingChanges(authenticationState);
        }
    }

    /// <summary>
    /// Saves observed changes from changeTracker to object.
    /// </summary>
    /// <param name="plainObject"></param>
    public void ChangeTrackerSaveObservedChanges(IBrowsableDataObject plainObject)
    {
        throw new NotImplementedException();
    }

    /// <summary>
    /// Sets changes to changeTracker.
    /// </summary>
    /// <param name="entity">Entity from which is set data.</param>
    public void ChangeTrackerSetChanges(IBrowsableDataObject entity)
    {
        foreach (var fragment in DataFragments)
        {
            fragment.ChangeTrackerSetChanges(entity);
        }
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
    /// <param name="by"></param>
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
    /// <param name="by"></param>
    public void SetLockedBy(object by)
    {
        foreach (var fragment in DataFragments)
        {
            fragment.SetLockedBy(by);
        }
    }

    public async Task CreateNewAsync(string identifier)
    {
        await Task.Run(() =>
        {
            foreach (var fragment in DataFragments)
            {
                fragment?.Repository.Create(identifier, fragment.RefUIData.CreatePoco());
            }

            DataFragments.First().Repository.Read(identifier);
        });
    }

    public async Task FromRepositoryToShadowsAsync(IBrowsableDataObject entity)
    {
        foreach (var fragment in DataFragments)
        {
            await fragment.RefUIData.PlainToShadow(fragment.Repository.Read(entity.DataEntityId));
        }
    }

    public async Task UpdateFromShadowsAsync()
    {
        foreach (var fragment in DataFragments)
        {
            var plainer = await (fragment.RefUIData).ShadowToPlain<dynamic>();
            fragment.ChangeTrackerSaveObservedChanges(plainer);
            fragment.Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
        }
    }

    public async Task FromRepositoryToControllerAsync(IBrowsableDataObject selected)
    {
        foreach (var fragment in DataFragments)
        {
            await fragment.RefUIData.PlainToOnline(fragment.Repository.Read(selected.DataEntityId));
        }
    }

    public async Task CreateDataFromControllerAsync(string recordId)
    {
        foreach (var fragment in DataFragments)
        {
            var plainer = await fragment.RefUIData.OnlineToPlain<dynamic>();
            plainer.DataEntityId = recordId;
            fragment.Repository.Create(plainer.DataEntityId, plainer);
            var plain = fragment.Repository.Read(plainer.DataEntityId);
            fragment.RefUIData.PlainToShadow(plain);
        }
    }

    public async Task Delete(string identifier)
    {
        await Task.Run(() => { foreach (var fragment in DataFragments) { fragment.Repository.Delete(identifier); } });
    }

    public async Task CreateCopyCurrentShadowsAsync(string recordId)
    {
        foreach (var fragment in DataFragments)
        {
            var source = await fragment.RefUIData.ShadowToPlain<IBrowsableDataObject>();
            source.DataEntityId = recordId;
            fragment.Repository.Create(source.DataEntityId, source);
        }
    }

    public async Task<bool> ExistsAsync(string recordId)
    {
        foreach (var fragment in DataFragments)
        {
            if (!fragment.Repository.Exists(recordId))
                return false;
        }
        return true;
    }

    public async Task CreateOrUpdate(string recordId)
    {
        foreach (var fragment in DataFragments)
        {
            if (Repository.Exists(recordId))
            {
                var plainer = await ((ITwinObject)RefUIData).ShadowToPlain<dynamic>();
                fragment.ChangeTrackerSaveObservedChanges(plainer);
                fragment.Repository.Update(((IBrowsableDataObject)plainer).DataEntityId, plainer);
            }
            else
            {
                fragment.Repository.Create(recordId, fragment.RefUIData.CreatePoco());
            }
        }

        DataFragments.First().Repository.Read(recordId);
    }

    public bool RemoteCreate(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            fragment?.RemoteCreate(identifier);
        }

        return true;
    }

    public bool RemoteRead(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            fragment?.RemoteRead(identifier);
        }

        return true;
    }

    public bool RemoteUpdate(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            fragment?.RemoteUpdate(identifier);
        }

        return true;
    }

    public bool RemoteDelete(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            fragment?.RemoteDelete(identifier);
        }

        return true;
    }

    public bool RemoteEntityExist(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            if (!fragment.RemoteEntityExist(identifier))
                return false;
        }

        return true;
    }

    public bool RemoteCreateOrUpdate(string identifier)
    {
        foreach (var fragment in DataFragments)
        {
            fragment?.RemoteCreateOrUpdate(identifier);
        }

        return true;
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier, int limit, int skip, eSearchMode searchMode)
    {
        return ((dynamic)Repository)?.GetRecords(identifier, limit, skip, searchMode);
    }

    public IEnumerable<IBrowsableDataObject> GetRecords(string identifier)
    {
        return ((dynamic)Repository).GetRecords(identifier);
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

    public void ExportData(string path, Dictionary<string, ExportData> customExportData = null, eExportMode exportMode = eExportMode.First, int firstNumber = 50, int secondNumber = 100, string exportFileType = "CSV", char separator = ';')
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
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

    private void Handle()
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
            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    public IRepository? Repository { get; private set; }

    public ITwinObject RefUIData { get; private set; }

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
            //CrudData.ChangeTracker.SaveObservedChanges(plainer);
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

    public void ExportData(string path, char separator = ';')
    {
        if (Path.GetExtension(path).Equals(".zip", StringComparison.OrdinalIgnoreCase))
        {
            if (Directory.Exists(Path.GetDirectoryName(path) + "\\exportDataPrepare"))
                Directory.Delete(Path.GetDirectoryName(path) + "\\exportDataPrepare", true);

            Directory.CreateDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare");

            File.Delete(path);


            foreach (var fragment in DataFragments)
            {
                fragment?.ExportData(Path.GetDirectoryName(path) + "\\exportDataPrepare\\" + fragment.ToString(), separator);
            }
            ZipFile.CreateFromDirectory(Path.GetDirectoryName(path) + "\\exportDataPrepare", path);
        }
        else
        {
            foreach (var fragment in DataFragments)
            {
                fragment?.ExportData(Path.GetDirectoryName(path) + "\\" + fragment.ToString(), separator);
            }
        }
    }

    public void ImportData(string path, ITwinObject crudDataObject = null, char separator = ';')
    {
        if (Path.GetExtension(path).Equals(".zip", StringComparison.OrdinalIgnoreCase))
        {
            if (Directory.Exists(Path.GetDirectoryName(path) + "\\importDataPrepare"))
                Directory.Delete(Path.GetDirectoryName(path) + "\\importDataPrepare", true);

            Directory.CreateDirectory(Path.GetDirectoryName(path) + "\\importDataPrepare");

            ZipFile.ExtractToDirectory(path, Path.GetDirectoryName(path) + "\\importDataPrepare");

            foreach (var fragment in DataFragments)
            {
                fragment?.ImportData(Path.GetDirectoryName(path) + "\\importDataPrepare\\" + fragment.ToString(), crudDataObject, separator);
            }

            Directory.Delete(Path.GetDirectoryName(path), true);
        }
        else
        {
            foreach (var fragment in DataFragments)
            {
                fragment?.ImportData(Path.GetDirectoryName(path) + "\\" + fragment.ToString(), crudDataObject, separator);
            }
        }
    }
}
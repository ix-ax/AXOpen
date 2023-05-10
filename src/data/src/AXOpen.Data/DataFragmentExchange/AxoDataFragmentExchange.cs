// axosimple
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using System.Reflection;
using AXOpen.Base.Data;
using AXSharp.Connector;

namespace AXOpen.Data;

[System.AttributeUsage(System.AttributeTargets.Property)]
public class AxoDataFragmentAttribute : Attribute
{

}

public partial class AxoDataFragmentExchange
{
    protected AxoDataExchange[] DataFragments { get; private set; }

    
    public T? Builder<T>() where T : AxoDataFragmentExchange
    {
        DataFragments = GetDataSetProperty<AxoDataFragmentAttribute, AxoDataExchange>().ToArray();
        Operation.InitializeExclusively(Handle);
        Operation.WriteAsync().Wait();
        return this as T;
    }

    private void Handle()
    {
        Operation.ReadAsync().Wait();
        var operation = (eCrudOperation)Operation.CrudOperation.LastValue;
        var identifier = Operation.DataEntityIdentifier.LastValue;

        switch (operation)
        {
            case eCrudOperation.Create:
                this.Create(identifier);
                break;
            case eCrudOperation.Read:
                this.Read(identifier);
                break;
            case eCrudOperation.Update:
                this.Update(identifier);
                break;
            case eCrudOperation.Delete:
                this.Delete(identifier);
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    private void Create(string identifier)
    {
        foreach (var framents in DataFragments)
        {
            framents?.CreateTask.DataEntityIdentifier.SetAsync(identifier).Wait();
            framents?.Create();
        }
    }

    private void Read(string identifier)
    {
        foreach (var framents in DataFragments)
        {
            framents?.ReadTask.DataEntityIdentifier.SetAsync(identifier).Wait();
            framents?.Read();
        }
    }

    private void Update(string identifier)
    {
        foreach (var framents in DataFragments)
        {
            framents?.UpdateTask.DataEntityIdentifier.SetAsync(identifier).Wait();
            framents?.Update();
        }
    }

    private void Delete(string identifier)
    {
        foreach (var framents in DataFragments)
        {
            framents?.DeleteTask.DataEntityIdentifier.SetAsync(identifier).Wait();
            framents?.Delete();
        }
    }

    public IEnumerable<PropertyInfo>? GetDataSetPropertyInfo<TA>() where TA : Attribute
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

    public IEnumerable<TS>? GetDataSetProperty<TA, TS>() where TA : Attribute where TS : class
    {
        return this.GetDataSetPropertyInfo<TA>()?.Select(p => p.GetValue(this) as TS);
    }
}
// ix_ax_axopen_data
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/axsharp/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/axsharp/blob/dev/LICENSE
// Third party licenses: https://github.com/ix-ax/axsharp/blob/dev/notices.md

using AXSharp.Connector;
using AXSharp.Connector.Localizations;

namespace AXOpen.Data;

[Container(Layout.Tabs)]
public class AxoFragmentedDataCompound : ITwinObject
{
    public AxoFragmentedDataCompound(ITwinObject parent, IList<ITwinElement> kids)
    {
        this._parent = parent;
        this._symbolTail = string.Empty;
        _kids = kids;
    }
    
    public string Symbol { get; } = string.Empty;

    public string AttributeName { get; } = string.Empty;

    public string HumanReadable { get; set; } = string.Empty;
    public Translator Interpreter => this._parent.Interpreter;

    private readonly ITwinObject _parent;

    public ITwinObject GetParent()
    {
        return this._parent;
    }

    private readonly string _symbolTail;

    public string GetSymbolTail()
    {
        return _symbolTail;
    }

    private IList<ITwinObject> _children = new List<ITwinObject>();

    public IEnumerable<ITwinObject> GetChildren()
    {
        return _kids.OfType<ITwinObject>();
    }

    private readonly IList<ITwinElement> _kids = new List<ITwinElement>();

    public IEnumerable<ITwinElement> GetKids()
    {
        return _kids;
    }

    private readonly IList<ITwinPrimitive> _primitive;

    public IEnumerable<ITwinPrimitive?> GetValueTags()
    {
        return _kids.OfType<ITwinPrimitive>();
    }

    public void AddChild(ITwinObject twinObject)
    {
        _children.Add(twinObject);
    }

    public void AddValueTag(ITwinPrimitive twinPrimitive)
    {
        _primitive.Add(twinPrimitive);
    }

    public void AddKid(ITwinElement kid)
    {
        _kids.Add(kid);
    }

    public Connector GetConnector()
    {
        throw new NotImplementedException();
    }

    public void Poll()
    {
        this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
    }

    public Task<T> OnlineToPlain<T>()
    {
        throw new NotImplementedException();
    }

    public Task PlainToOnline<T>(T plain)
    {
        throw new NotImplementedException();
    }

    public Task<T> ShadowToPlain<T>()
    {
        throw new NotImplementedException();
    }

    public Task PlainToShadow<T>(T plain)
    {
        throw new NotImplementedException();
    }
}
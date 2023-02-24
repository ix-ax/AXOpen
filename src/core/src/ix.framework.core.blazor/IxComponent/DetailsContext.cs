using Ix.Connector;

namespace ix.framework.core
{
    public class DetailsContext : ITwinObject
    {
        public DetailsContext(ITwinObject parent, IList<ITwinElement> kids)
        {
            this._parent = parent;
            this._symbolTail = this._parent.GetSymbolTail();
            _kids = kids;
        }
        public DetailsContext(ITwinObject parent, IList<ITwinElement> kids, string tabName)
        {
            this._parent = parent;
            this._symbolTail = this._parent.GetSymbolTail();
            _kids = kids;
            HumanReadable = tabName;
        }
        public string TabName { get; set; } = string.Empty;

        public string Symbol { get; } = string.Empty;

        public string AttributeName { get; } = string.Empty;

        public string HumanReadable { get; set; } = string.Empty;

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

        private readonly IList<ITwinPrimitive> _primitive = new List<ITwinPrimitive>();

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
            return this.GetParent()?.GetConnector();
        }

        public void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }
    }
}


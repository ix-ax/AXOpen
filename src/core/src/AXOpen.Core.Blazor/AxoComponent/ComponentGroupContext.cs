using System.Globalization;
using AXSharp.Connector;
using AXSharp.Connector.Localizations;

namespace AXOpen.Core
{
    public class ComponentGroupContext : ITwinObject
    {
        public ComponentGroupContext(ITwinObject parent, IList<ITwinElement> kids)
        {
            this._parent = parent;
            this._symbolTail = this._parent.GetSymbolTail();
            _kids = kids;
        }
        public ComponentGroupContext(ITwinObject parent, IList<ITwinElement> kids, string tabName)
        {
            this._parent = parent;
            this._symbolTail = this._parent.GetSymbolTail();
            _kids = kids;
            HumanReadable = tabName;
        }

        public ComponentGroupContext(ITwinObject parent, IList<ITwinElement> kids, string tabName, string roleName)
        {
            this._parent = parent;
            this._symbolTail = this._parent.GetSymbolTail();
            _kids = kids;
            HumanReadable = tabName;
            RoleName = roleName;
        }
        
        public string TabName { get; set; } = string.Empty;

        public string Symbol { get; } = string.Empty;

        public string AttributeName { get; } = string.Empty;

        public string HumanReadable { get; set; } = string.Empty;
        public string RoleName { get; set; } = string.Empty;
        public Translator Interpreter => this._parent.Interpreter;

        private readonly ITwinObject _parent;

        public string GetAttributeName(CultureInfo culture)
        {
            return this.Translate(AttributeName, culture);
        }

        public string GetHumanReadable(CultureInfo culture)
        {
            return this.Translate(HumanReadable, culture);
        }

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
            return this.GetParent()?.GetConnector();
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
}


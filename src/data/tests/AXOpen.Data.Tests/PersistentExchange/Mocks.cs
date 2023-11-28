using AXSharp.Connector.ValueTypes;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Data;
using AXSharp.Connector.Localizations;

namespace AxoDataPersistentExchangeExample
{
    public partial class PersistentRootObject : AXSharp.Connector.ITwinObject
    {
        public OnlinerBool NotPersistentVariable { get; }

        [Persistent()]
        public OnlinerInt PersistentVariable_1 { get; }

        [Persistent("default", "1")]
        public OnlinerInt PersistentVariable_2 { get; }

        [Container(Layout.Stack)]
        [Group(GroupLayout.GroupBox)]
        public AxoDataPersistentExchangeExample.ObjectWithPersistentMember PropertyWithPersistentMember { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public PersistentRootObject(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            this.@SymbolTail = symbolTail;
            this.@Connector = parent.GetConnector();
            this.@Parent = parent;
            HumanReadable = AXSharp.Connector.Connector.CreateHumanReadable(parent.HumanReadable, readableTail);
            PreConstruct(parent, readableTail, symbolTail);
            NotPersistentVariable = @Connector.ConnectorAdapter.AdapterFactory.CreateBOOL(this, "NotPersistentVariable", "NotPersistentVariable");
            PersistentVariable_1 = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "PersistentVariable_1 (default pg.))", "PersistentVariable_1");
            PersistentVariable_1.AttributeName = "PersistentVariable_1 (default pg.))";
            PersistentVariable_2 = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "PersistentVariable_2 (default & 1 pg.)", "PersistentVariable_2");
            PersistentVariable_2.AttributeName = "PersistentVariable_2 (default & 1 pg.)";
            PropertyWithPersistentMember = new AxoDataPersistentExchangeExample.ObjectWithPersistentMember(this, "PropertyWithPersistentMember", "PropertyWithPersistentMember");
            PropertyWithPersistentMember.AttributeName = "PropertyWithPersistentMember";
            parent.AddChild(this);
            parent.AddKid(this);
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async virtual Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public async Task<Pocos.AxoDataPersistentExchangeExample.PersistentRootObject> OnlineToPlainAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.PersistentRootObject plain = new Pocos.AxoDataPersistentExchangeExample.PersistentRootObject();
            await this.ReadAsync<IgnoreOnPocoOperation>();
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
            plain.PersistentVariable_1 = PersistentVariable_1.LastValue;
            plain.PersistentVariable_2 = PersistentVariable_2.LastValue;
#pragma warning disable CS0612
            plain.PropertyWithPersistentMember = await PropertyWithPersistentMember._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task<Pocos.AxoDataPersistentExchangeExample.PersistentRootObject> _OnlineToPlainNoacAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.PersistentRootObject plain = new Pocos.AxoDataPersistentExchangeExample.PersistentRootObject();
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
            plain.PersistentVariable_1 = PersistentVariable_1.LastValue;
            plain.PersistentVariable_2 = PersistentVariable_2.LastValue;
#pragma warning disable CS0612
            plain.PropertyWithPersistentMember = await PropertyWithPersistentMember._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<Pocos.AxoDataPersistentExchangeExample.PersistentRootObject> _OnlineToPlainNoacAsync(Pocos.AxoDataPersistentExchangeExample.PersistentRootObject plain)
        {
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
            plain.PersistentVariable_1 = PersistentVariable_1.LastValue;
            plain.PersistentVariable_2 = PersistentVariable_2.LastValue;
#pragma warning disable CS0612
            plain.PropertyWithPersistentMember = await PropertyWithPersistentMember._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async virtual Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(Pocos.AxoDataPersistentExchangeExample.PersistentRootObject plain)
        {
            NotPersistentVariable.Cyclic = plain.NotPersistentVariable;
            PersistentVariable_1.Cyclic = plain.PersistentVariable_1;
            PersistentVariable_2.Cyclic = plain.PersistentVariable_2;
#pragma warning disable CS0612
            await this.PropertyWithPersistentMember._PlainToOnlineNoacAsync(plain.PropertyWithPersistentMember);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(Pocos.AxoDataPersistentExchangeExample.PersistentRootObject plain)
        {
            NotPersistentVariable.Cyclic = plain.NotPersistentVariable;
            PersistentVariable_1.Cyclic = plain.PersistentVariable_1;
            PersistentVariable_2.Cyclic = plain.PersistentVariable_2;
#pragma warning disable CS0612
            await this.PropertyWithPersistentMember._PlainToOnlineNoacAsync(plain.PropertyWithPersistentMember);
#pragma warning restore CS0612
        }

        public async virtual Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public async Task<Pocos.AxoDataPersistentExchangeExample.PersistentRootObject> ShadowToPlainAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.PersistentRootObject plain = new Pocos.AxoDataPersistentExchangeExample.PersistentRootObject();
            plain.NotPersistentVariable = NotPersistentVariable.Shadow;
            plain.PersistentVariable_1 = PersistentVariable_1.Shadow;
            plain.PersistentVariable_2 = PersistentVariable_2.Shadow;
            plain.PropertyWithPersistentMember = await PropertyWithPersistentMember.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<Pocos.AxoDataPersistentExchangeExample.PersistentRootObject> ShadowToPlainAsync(Pocos.AxoDataPersistentExchangeExample.PersistentRootObject plain)
        {
            plain.NotPersistentVariable = NotPersistentVariable.Shadow;
            plain.PersistentVariable_1 = PersistentVariable_1.Shadow;
            plain.PersistentVariable_2 = PersistentVariable_2.Shadow;
            plain.PropertyWithPersistentMember = await PropertyWithPersistentMember.ShadowToPlainAsync();
            return plain;
        }

        public async virtual Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(Pocos.AxoDataPersistentExchangeExample.PersistentRootObject plain)
        {
            NotPersistentVariable.Shadow = plain.NotPersistentVariable;
            PersistentVariable_1.Shadow = plain.PersistentVariable_1;
            PersistentVariable_2.Shadow = plain.PersistentVariable_2;
            await this.PropertyWithPersistentMember.PlainToShadowAsync(plain.PropertyWithPersistentMember);
            return this.RetrievePrimitives();
        }

        public void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public Pocos.AxoDataPersistentExchangeExample.PersistentRootObject CreateEmptyPoco()
        {
            return new Pocos.AxoDataPersistentExchangeExample.PersistentRootObject();
        }

        private IList<AXSharp.Connector.ITwinObject> Children { get; } = new List<AXSharp.Connector.ITwinObject>();
        public IEnumerable<AXSharp.Connector.ITwinObject> GetChildren()
        {
            return Children;
        }

        private IList<AXSharp.Connector.ITwinElement> Kids { get; } = new List<AXSharp.Connector.ITwinElement>();
        public IEnumerable<AXSharp.Connector.ITwinElement> GetKids()
        {
            return Kids;
        }

        private IList<AXSharp.Connector.ITwinPrimitive> ValueTags { get; } = new List<AXSharp.Connector.ITwinPrimitive>();
        public IEnumerable<AXSharp.Connector.ITwinPrimitive> GetValueTags()
        {
            return ValueTags;
        }

        public void AddValueTag(AXSharp.Connector.ITwinPrimitive valueTag)
        {
            ValueTags.Add(valueTag);
        }

        public void AddKid(AXSharp.Connector.ITwinElement kid)
        {
            Kids.Add(kid);
        }

        public void AddChild(AXSharp.Connector.ITwinObject twinObject)
        {
            Children.Add(twinObject);
        }

        protected AXSharp.Connector.Connector @Connector { get; }

        public AXSharp.Connector.Connector GetConnector()
        {
            return this.@Connector;
        }

        public string GetSymbolTail()
        {
            return this.SymbolTail;
        }

        public AXSharp.Connector.ITwinObject GetParent()
        {
            return this.@Parent;
        }

        public string Symbol { get; protected set; }

        private string _attributeName;
        public System.String AttributeName { get => string.IsNullOrEmpty(_attributeName) ? SymbolTail : _attributeName.Interpolate(this).CleanUpLocalizationTokens(); set => _attributeName = value; }

        public System.String GetAttributeName(System.Globalization.CultureInfo culture)
        {
            return this.Translate(_attributeName, culture).Interpolate(this);
        }

        private string _humanReadable;
        public string HumanReadable { get => string.IsNullOrEmpty(_humanReadable) ? SymbolTail : _humanReadable.Interpolate(this).CleanUpLocalizationTokens(); set => _humanReadable = value; }

        public System.String GetHumanReadable(System.Globalization.CultureInfo culture)
        {
            return this.Translate(_humanReadable, culture);
        }

        protected System.String @SymbolTail { get; set; }

        protected AXSharp.Connector.ITwinObject @Parent { get; set; }

        public Translator Interpreter => throw new NotImplementedException();
    }

    public partial class ObjectWithPersistentMember : AXSharp.Connector.ITwinObject
    {
        public OnlinerInt NotPersistentVariable { get; }

        [Persistent("2")]
        [Container(Layout.Stack)]
        [Group(GroupLayout.GroupBox)]
        public AxoDataPersistentExchangeExample.InitializedPrimitives InitializedPrimitives { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public ObjectWithPersistentMember(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            this.@SymbolTail = symbolTail;
            this.@Connector = parent.GetConnector();
            this.@Parent = parent;
            HumanReadable = AXSharp.Connector.Connector.CreateHumanReadable(parent.HumanReadable, readableTail);
            PreConstruct(parent, readableTail, symbolTail);
            NotPersistentVariable = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "NotPersistentVariable", "NotPersistentVariable");
            InitializedPrimitives = new AxoDataPersistentExchangeExample.InitializedPrimitives(this, "InitializedPrimitives (2 pg.)", "InitializedPrimitives");
            InitializedPrimitives.AttributeName = "InitializedPrimitives (2 pg.)";
            parent.AddChild(this);
            parent.AddKid(this);
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async virtual Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public async Task<Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember> OnlineToPlainAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember plain = new Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember();
            await this.ReadAsync<IgnoreOnPocoOperation>();
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
#pragma warning disable CS0612
            plain.InitializedPrimitives = await InitializedPrimitives._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task<Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember> _OnlineToPlainNoacAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember plain = new Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember();
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
#pragma warning disable CS0612
            plain.InitializedPrimitives = await InitializedPrimitives._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember> _OnlineToPlainNoacAsync(Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember plain)
        {
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
#pragma warning disable CS0612
            plain.InitializedPrimitives = await InitializedPrimitives._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async virtual Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember plain)
        {
            NotPersistentVariable.Cyclic = plain.NotPersistentVariable;
#pragma warning disable CS0612
            await this.InitializedPrimitives._PlainToOnlineNoacAsync(plain.InitializedPrimitives);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember plain)
        {
            NotPersistentVariable.Cyclic = plain.NotPersistentVariable;
#pragma warning disable CS0612
            await this.InitializedPrimitives._PlainToOnlineNoacAsync(plain.InitializedPrimitives);
#pragma warning restore CS0612
        }

        public async virtual Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public async Task<Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember> ShadowToPlainAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember plain = new Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember();
            plain.NotPersistentVariable = NotPersistentVariable.Shadow;
            plain.InitializedPrimitives = await InitializedPrimitives.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember> ShadowToPlainAsync(Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember plain)
        {
            plain.NotPersistentVariable = NotPersistentVariable.Shadow;
            plain.InitializedPrimitives = await InitializedPrimitives.ShadowToPlainAsync();
            return plain;
        }

        public async virtual Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember plain)
        {
            NotPersistentVariable.Shadow = plain.NotPersistentVariable;
            await this.InitializedPrimitives.PlainToShadowAsync(plain.InitializedPrimitives);
            return this.RetrievePrimitives();
        }

        public void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember CreateEmptyPoco()
        {
            return new Pocos.AxoDataPersistentExchangeExample.ObjectWithPersistentMember();
        }

        private IList<AXSharp.Connector.ITwinObject> Children { get; } = new List<AXSharp.Connector.ITwinObject>();
        public IEnumerable<AXSharp.Connector.ITwinObject> GetChildren()
        {
            return Children;
        }

        private IList<AXSharp.Connector.ITwinElement> Kids { get; } = new List<AXSharp.Connector.ITwinElement>();
        public IEnumerable<AXSharp.Connector.ITwinElement> GetKids()
        {
            return Kids;
        }

        private IList<AXSharp.Connector.ITwinPrimitive> ValueTags { get; } = new List<AXSharp.Connector.ITwinPrimitive>();
        public IEnumerable<AXSharp.Connector.ITwinPrimitive> GetValueTags()
        {
            return ValueTags;
        }

        public void AddValueTag(AXSharp.Connector.ITwinPrimitive valueTag)
        {
            ValueTags.Add(valueTag);
        }

        public void AddKid(AXSharp.Connector.ITwinElement kid)
        {
            Kids.Add(kid);
        }

        public void AddChild(AXSharp.Connector.ITwinObject twinObject)
        {
            Children.Add(twinObject);
        }

        protected AXSharp.Connector.Connector @Connector { get; }

        public AXSharp.Connector.Connector GetConnector()
        {
            return this.@Connector;
        }

        public string GetSymbolTail()
        {
            return this.SymbolTail;
        }

        public AXSharp.Connector.ITwinObject GetParent()
        {
            return this.@Parent;
        }

        public string Symbol { get; protected set; }

        private string _attributeName;
        public System.String AttributeName { get => string.IsNullOrEmpty(_attributeName) ? SymbolTail : _attributeName.Interpolate(this).CleanUpLocalizationTokens(); set => _attributeName = value; }

        public System.String GetAttributeName(System.Globalization.CultureInfo culture)
        {
            return this.Translate(_attributeName, culture).Interpolate(this);
        }

        private string _humanReadable;
        public string HumanReadable { get => string.IsNullOrEmpty(_humanReadable) ? SymbolTail : _humanReadable.Interpolate(this).CleanUpLocalizationTokens(); set => _humanReadable = value; }

        public System.String GetHumanReadable(System.Globalization.CultureInfo culture)
        {
            return this.Translate(_humanReadable, culture);
        }

        protected System.String @SymbolTail { get; set; }

        protected AXSharp.Connector.ITwinObject @Parent { get; set; }

        public Translator Interpreter => throw new NotImplementedException();
    }

    public partial class InitializedPrimitives : AXSharp.Connector.ITwinObject
    {
        public OnlinerBool myBOOL { get; }

        public OnlinerByte myBYTE { get; }

        public OnlinerWord myWORD { get; }

        public OnlinerDWord myDWORD { get; }

        public OnlinerLWord myLWORD { get; }

        public OnlinerSInt mySINTMin { get; }

        public OnlinerSInt mySINTMax { get; }

        public OnlinerInt myINT { get; }

        public OnlinerDInt myDINT { get; }

        public OnlinerLInt myLINT { get; }

        public OnlinerUSInt myUSINT { get; }

        public OnlinerUInt myUINT { get; }

        public OnlinerUDInt myUDINT { get; }

        public OnlinerULInt myULINT { get; }

        public OnlinerReal myREAL { get; }

        public OnlinerLReal myLREAL { get; }

        public OnlinerTime myTIME { get; }

        public OnlinerLTime myLTIME { get; }

        public OnlinerDate myDATE { get; }

        public OnlinerDate myLDATE { get; }

        public OnlinerTimeOfDay myTIME_OF_DAY { get; }

        public OnlinerLTimeOfDay myLTIME_OF_DAY { get; }

        public OnlinerDateTime myDATE_AND_TIME { get; }

        public OnlinerLDateTime myLDATE_AND_TIME { get; }

        public OnlinerChar myCHAR { get; }

        public OnlinerWChar myWCHAR { get; }

        public OnlinerString mySTRING { get; }

        public OnlinerWString myWSTRING { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public InitializedPrimitives(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            this.@SymbolTail = symbolTail;
            this.@Connector = parent.GetConnector();
            this.@Parent = parent;
            HumanReadable = AXSharp.Connector.Connector.CreateHumanReadable(parent.HumanReadable, readableTail);
            PreConstruct(parent, readableTail, symbolTail);
            myBOOL = @Connector.ConnectorAdapter.AdapterFactory.CreateBOOL(this, "myBOOL", "myBOOL");
            myBYTE = @Connector.ConnectorAdapter.AdapterFactory.CreateBYTE(this, "myBYTE", "myBYTE");
            myWORD = @Connector.ConnectorAdapter.AdapterFactory.CreateWORD(this, "myWORD", "myWORD");
            myDWORD = @Connector.ConnectorAdapter.AdapterFactory.CreateDWORD(this, "myDWORD", "myDWORD");
            myLWORD = @Connector.ConnectorAdapter.AdapterFactory.CreateLWORD(this, "myLWORD", "myLWORD");
            mySINTMin = @Connector.ConnectorAdapter.AdapterFactory.CreateSINT(this, "mySINTMin", "mySINTMin");
            mySINTMax = @Connector.ConnectorAdapter.AdapterFactory.CreateSINT(this, "mySINTMax", "mySINTMax");
            myINT = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "myINT", "myINT");
            myDINT = @Connector.ConnectorAdapter.AdapterFactory.CreateDINT(this, "myDINT", "myDINT");
            myLINT = @Connector.ConnectorAdapter.AdapterFactory.CreateLINT(this, "myLINT", "myLINT");
            myUSINT = @Connector.ConnectorAdapter.AdapterFactory.CreateUSINT(this, "myUSINT", "myUSINT");
            myUINT = @Connector.ConnectorAdapter.AdapterFactory.CreateUINT(this, "myUINT", "myUINT");
            myUDINT = @Connector.ConnectorAdapter.AdapterFactory.CreateUDINT(this, "myUDINT", "myUDINT");
            myULINT = @Connector.ConnectorAdapter.AdapterFactory.CreateULINT(this, "myULINT", "myULINT");
            myREAL = @Connector.ConnectorAdapter.AdapterFactory.CreateREAL(this, "myREAL", "myREAL");
            myLREAL = @Connector.ConnectorAdapter.AdapterFactory.CreateLREAL(this, "myLREAL", "myLREAL");
            myTIME = @Connector.ConnectorAdapter.AdapterFactory.CreateTIME(this, "myTIME", "myTIME");
            myLTIME = @Connector.ConnectorAdapter.AdapterFactory.CreateLTIME(this, "myLTIME", "myLTIME");
            myDATE = @Connector.ConnectorAdapter.AdapterFactory.CreateDATE(this, "myDATE", "myDATE");
            myLDATE = @Connector.ConnectorAdapter.AdapterFactory.CreateLDATE(this, "myLDATE", "myLDATE");
            myTIME_OF_DAY = @Connector.ConnectorAdapter.AdapterFactory.CreateTIME_OF_DAY(this, "myTIME_OF_DAY", "myTIME_OF_DAY");
            myLTIME_OF_DAY = @Connector.ConnectorAdapter.AdapterFactory.CreateLTIME_OF_DAY(this, "myLTIME_OF_DAY", "myLTIME_OF_DAY");
            myDATE_AND_TIME = @Connector.ConnectorAdapter.AdapterFactory.CreateDATE_AND_TIME(this, "myDATE_AND_TIME", "myDATE_AND_TIME");
            myLDATE_AND_TIME = @Connector.ConnectorAdapter.AdapterFactory.CreateLDATE_AND_TIME(this, "myLDATE_AND_TIME", "myLDATE_AND_TIME");
            myCHAR = @Connector.ConnectorAdapter.AdapterFactory.CreateCHAR(this, "myCHAR", "myCHAR");
            myWCHAR = @Connector.ConnectorAdapter.AdapterFactory.CreateWCHAR(this, "myWCHAR", "myWCHAR");
            mySTRING = @Connector.ConnectorAdapter.AdapterFactory.CreateSTRING(this, "mySTRING", "mySTRING");
            myWSTRING = @Connector.ConnectorAdapter.AdapterFactory.CreateWSTRING(this, "myWSTRING", "myWSTRING");
            parent.AddChild(this);
            parent.AddKid(this);
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async virtual Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public async Task<Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives> OnlineToPlainAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives plain = new Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives();
            await this.ReadAsync<IgnoreOnPocoOperation>();
            plain.myBOOL = myBOOL.LastValue;
            plain.myBYTE = myBYTE.LastValue;
            plain.myWORD = myWORD.LastValue;
            plain.myDWORD = myDWORD.LastValue;
            plain.myLWORD = myLWORD.LastValue;
            plain.mySINTMin = mySINTMin.LastValue;
            plain.mySINTMax = mySINTMax.LastValue;
            plain.myINT = myINT.LastValue;
            plain.myDINT = myDINT.LastValue;
            plain.myLINT = myLINT.LastValue;
            plain.myUSINT = myUSINT.LastValue;
            plain.myUINT = myUINT.LastValue;
            plain.myUDINT = myUDINT.LastValue;
            plain.myULINT = myULINT.LastValue;
            plain.myREAL = myREAL.LastValue;
            plain.myLREAL = myLREAL.LastValue;
            plain.myTIME = myTIME.LastValue;
            plain.myLTIME = myLTIME.LastValue;
            plain.myDATE = myDATE.LastValue;
            plain.myLDATE = myLDATE.LastValue;
            plain.myTIME_OF_DAY = myTIME_OF_DAY.LastValue;
            plain.myLTIME_OF_DAY = myLTIME_OF_DAY.LastValue;
            plain.myDATE_AND_TIME = myDATE_AND_TIME.LastValue;
            plain.myLDATE_AND_TIME = myLDATE_AND_TIME.LastValue;
            plain.myCHAR = myCHAR.LastValue;
            plain.myWCHAR = myWCHAR.LastValue;
            plain.mySTRING = mySTRING.LastValue;
            plain.myWSTRING = myWSTRING.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task<Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives> _OnlineToPlainNoacAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives plain = new Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives();
            plain.myBOOL = myBOOL.LastValue;
            plain.myBYTE = myBYTE.LastValue;
            plain.myWORD = myWORD.LastValue;
            plain.myDWORD = myDWORD.LastValue;
            plain.myLWORD = myLWORD.LastValue;
            plain.mySINTMin = mySINTMin.LastValue;
            plain.mySINTMax = mySINTMax.LastValue;
            plain.myINT = myINT.LastValue;
            plain.myDINT = myDINT.LastValue;
            plain.myLINT = myLINT.LastValue;
            plain.myUSINT = myUSINT.LastValue;
            plain.myUINT = myUINT.LastValue;
            plain.myUDINT = myUDINT.LastValue;
            plain.myULINT = myULINT.LastValue;
            plain.myREAL = myREAL.LastValue;
            plain.myLREAL = myLREAL.LastValue;
            plain.myTIME = myTIME.LastValue;
            plain.myLTIME = myLTIME.LastValue;
            plain.myDATE = myDATE.LastValue;
            plain.myLDATE = myLDATE.LastValue;
            plain.myTIME_OF_DAY = myTIME_OF_DAY.LastValue;
            plain.myLTIME_OF_DAY = myLTIME_OF_DAY.LastValue;
            plain.myDATE_AND_TIME = myDATE_AND_TIME.LastValue;
            plain.myLDATE_AND_TIME = myLDATE_AND_TIME.LastValue;
            plain.myCHAR = myCHAR.LastValue;
            plain.myWCHAR = myWCHAR.LastValue;
            plain.mySTRING = mySTRING.LastValue;
            plain.myWSTRING = myWSTRING.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives> _OnlineToPlainNoacAsync(Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives plain)
        {
            plain.myBOOL = myBOOL.LastValue;
            plain.myBYTE = myBYTE.LastValue;
            plain.myWORD = myWORD.LastValue;
            plain.myDWORD = myDWORD.LastValue;
            plain.myLWORD = myLWORD.LastValue;
            plain.mySINTMin = mySINTMin.LastValue;
            plain.mySINTMax = mySINTMax.LastValue;
            plain.myINT = myINT.LastValue;
            plain.myDINT = myDINT.LastValue;
            plain.myLINT = myLINT.LastValue;
            plain.myUSINT = myUSINT.LastValue;
            plain.myUINT = myUINT.LastValue;
            plain.myUDINT = myUDINT.LastValue;
            plain.myULINT = myULINT.LastValue;
            plain.myREAL = myREAL.LastValue;
            plain.myLREAL = myLREAL.LastValue;
            plain.myTIME = myTIME.LastValue;
            plain.myLTIME = myLTIME.LastValue;
            plain.myDATE = myDATE.LastValue;
            plain.myLDATE = myLDATE.LastValue;
            plain.myTIME_OF_DAY = myTIME_OF_DAY.LastValue;
            plain.myLTIME_OF_DAY = myLTIME_OF_DAY.LastValue;
            plain.myDATE_AND_TIME = myDATE_AND_TIME.LastValue;
            plain.myLDATE_AND_TIME = myLDATE_AND_TIME.LastValue;
            plain.myCHAR = myCHAR.LastValue;
            plain.myWCHAR = myWCHAR.LastValue;
            plain.mySTRING = mySTRING.LastValue;
            plain.myWSTRING = myWSTRING.LastValue;
            return plain;
        }

        public async virtual Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives plain)
        {
            myBOOL.Cyclic = plain.myBOOL;
            myBYTE.Cyclic = plain.myBYTE;
            myWORD.Cyclic = plain.myWORD;
            myDWORD.Cyclic = plain.myDWORD;
            myLWORD.Cyclic = plain.myLWORD;
            mySINTMin.Cyclic = plain.mySINTMin;
            mySINTMax.Cyclic = plain.mySINTMax;
            myINT.Cyclic = plain.myINT;
            myDINT.Cyclic = plain.myDINT;
            myLINT.Cyclic = plain.myLINT;
            myUSINT.Cyclic = plain.myUSINT;
            myUINT.Cyclic = plain.myUINT;
            myUDINT.Cyclic = plain.myUDINT;
            myULINT.Cyclic = plain.myULINT;
            myREAL.Cyclic = plain.myREAL;
            myLREAL.Cyclic = plain.myLREAL;
            myTIME.Cyclic = plain.myTIME;
            myLTIME.Cyclic = plain.myLTIME;
            myDATE.Cyclic = plain.myDATE;
            myLDATE.Cyclic = plain.myLDATE;
            myTIME_OF_DAY.Cyclic = plain.myTIME_OF_DAY;
            myLTIME_OF_DAY.Cyclic = plain.myLTIME_OF_DAY;
            myDATE_AND_TIME.Cyclic = plain.myDATE_AND_TIME;
            myLDATE_AND_TIME.Cyclic = plain.myLDATE_AND_TIME;
            myCHAR.Cyclic = plain.myCHAR;
            myWCHAR.Cyclic = plain.myWCHAR;
            mySTRING.Cyclic = plain.mySTRING;
            myWSTRING.Cyclic = plain.myWSTRING;
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives plain)
        {
            myBOOL.Cyclic = plain.myBOOL;
            myBYTE.Cyclic = plain.myBYTE;
            myWORD.Cyclic = plain.myWORD;
            myDWORD.Cyclic = plain.myDWORD;
            myLWORD.Cyclic = plain.myLWORD;
            mySINTMin.Cyclic = plain.mySINTMin;
            mySINTMax.Cyclic = plain.mySINTMax;
            myINT.Cyclic = plain.myINT;
            myDINT.Cyclic = plain.myDINT;
            myLINT.Cyclic = plain.myLINT;
            myUSINT.Cyclic = plain.myUSINT;
            myUINT.Cyclic = plain.myUINT;
            myUDINT.Cyclic = plain.myUDINT;
            myULINT.Cyclic = plain.myULINT;
            myREAL.Cyclic = plain.myREAL;
            myLREAL.Cyclic = plain.myLREAL;
            myTIME.Cyclic = plain.myTIME;
            myLTIME.Cyclic = plain.myLTIME;
            myDATE.Cyclic = plain.myDATE;
            myLDATE.Cyclic = plain.myLDATE;
            myTIME_OF_DAY.Cyclic = plain.myTIME_OF_DAY;
            myLTIME_OF_DAY.Cyclic = plain.myLTIME_OF_DAY;
            myDATE_AND_TIME.Cyclic = plain.myDATE_AND_TIME;
            myLDATE_AND_TIME.Cyclic = plain.myLDATE_AND_TIME;
            myCHAR.Cyclic = plain.myCHAR;
            myWCHAR.Cyclic = plain.myWCHAR;
            mySTRING.Cyclic = plain.mySTRING;
            myWSTRING.Cyclic = plain.myWSTRING;
        }

        public async virtual Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public async Task<Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives> ShadowToPlainAsync()
        {
            Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives plain = new Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives();
            plain.myBOOL = myBOOL.Shadow;
            plain.myBYTE = myBYTE.Shadow;
            plain.myWORD = myWORD.Shadow;
            plain.myDWORD = myDWORD.Shadow;
            plain.myLWORD = myLWORD.Shadow;
            plain.mySINTMin = mySINTMin.Shadow;
            plain.mySINTMax = mySINTMax.Shadow;
            plain.myINT = myINT.Shadow;
            plain.myDINT = myDINT.Shadow;
            plain.myLINT = myLINT.Shadow;
            plain.myUSINT = myUSINT.Shadow;
            plain.myUINT = myUINT.Shadow;
            plain.myUDINT = myUDINT.Shadow;
            plain.myULINT = myULINT.Shadow;
            plain.myREAL = myREAL.Shadow;
            plain.myLREAL = myLREAL.Shadow;
            plain.myTIME = myTIME.Shadow;
            plain.myLTIME = myLTIME.Shadow;
            plain.myDATE = myDATE.Shadow;
            plain.myLDATE = myLDATE.Shadow;
            plain.myTIME_OF_DAY = myTIME_OF_DAY.Shadow;
            plain.myLTIME_OF_DAY = myLTIME_OF_DAY.Shadow;
            plain.myDATE_AND_TIME = myDATE_AND_TIME.Shadow;
            plain.myLDATE_AND_TIME = myLDATE_AND_TIME.Shadow;
            plain.myCHAR = myCHAR.Shadow;
            plain.myWCHAR = myWCHAR.Shadow;
            plain.mySTRING = mySTRING.Shadow;
            plain.myWSTRING = myWSTRING.Shadow;
            return plain;
        }

        protected async Task<Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives> ShadowToPlainAsync(Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives plain)
        {
            plain.myBOOL = myBOOL.Shadow;
            plain.myBYTE = myBYTE.Shadow;
            plain.myWORD = myWORD.Shadow;
            plain.myDWORD = myDWORD.Shadow;
            plain.myLWORD = myLWORD.Shadow;
            plain.mySINTMin = mySINTMin.Shadow;
            plain.mySINTMax = mySINTMax.Shadow;
            plain.myINT = myINT.Shadow;
            plain.myDINT = myDINT.Shadow;
            plain.myLINT = myLINT.Shadow;
            plain.myUSINT = myUSINT.Shadow;
            plain.myUINT = myUINT.Shadow;
            plain.myUDINT = myUDINT.Shadow;
            plain.myULINT = myULINT.Shadow;
            plain.myREAL = myREAL.Shadow;
            plain.myLREAL = myLREAL.Shadow;
            plain.myTIME = myTIME.Shadow;
            plain.myLTIME = myLTIME.Shadow;
            plain.myDATE = myDATE.Shadow;
            plain.myLDATE = myLDATE.Shadow;
            plain.myTIME_OF_DAY = myTIME_OF_DAY.Shadow;
            plain.myLTIME_OF_DAY = myLTIME_OF_DAY.Shadow;
            plain.myDATE_AND_TIME = myDATE_AND_TIME.Shadow;
            plain.myLDATE_AND_TIME = myLDATE_AND_TIME.Shadow;
            plain.myCHAR = myCHAR.Shadow;
            plain.myWCHAR = myWCHAR.Shadow;
            plain.mySTRING = mySTRING.Shadow;
            plain.myWSTRING = myWSTRING.Shadow;
            return plain;
        }

        public async virtual Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives plain)
        {
            myBOOL.Shadow = plain.myBOOL;
            myBYTE.Shadow = plain.myBYTE;
            myWORD.Shadow = plain.myWORD;
            myDWORD.Shadow = plain.myDWORD;
            myLWORD.Shadow = plain.myLWORD;
            mySINTMin.Shadow = plain.mySINTMin;
            mySINTMax.Shadow = plain.mySINTMax;
            myINT.Shadow = plain.myINT;
            myDINT.Shadow = plain.myDINT;
            myLINT.Shadow = plain.myLINT;
            myUSINT.Shadow = plain.myUSINT;
            myUINT.Shadow = plain.myUINT;
            myUDINT.Shadow = plain.myUDINT;
            myULINT.Shadow = plain.myULINT;
            myREAL.Shadow = plain.myREAL;
            myLREAL.Shadow = plain.myLREAL;
            myTIME.Shadow = plain.myTIME;
            myLTIME.Shadow = plain.myLTIME;
            myDATE.Shadow = plain.myDATE;
            myLDATE.Shadow = plain.myLDATE;
            myTIME_OF_DAY.Shadow = plain.myTIME_OF_DAY;
            myLTIME_OF_DAY.Shadow = plain.myLTIME_OF_DAY;
            myDATE_AND_TIME.Shadow = plain.myDATE_AND_TIME;
            myLDATE_AND_TIME.Shadow = plain.myLDATE_AND_TIME;
            myCHAR.Shadow = plain.myCHAR;
            myWCHAR.Shadow = plain.myWCHAR;
            mySTRING.Shadow = plain.mySTRING;
            myWSTRING.Shadow = plain.myWSTRING;
            return this.RetrievePrimitives();
        }

        public void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives CreateEmptyPoco()
        {
            return new Pocos.AxoDataPersistentExchangeExample.InitializedPrimitives();
        }

        private IList<AXSharp.Connector.ITwinObject> Children { get; } = new List<AXSharp.Connector.ITwinObject>();
        public IEnumerable<AXSharp.Connector.ITwinObject> GetChildren()
        {
            return Children;
        }

        private IList<AXSharp.Connector.ITwinElement> Kids { get; } = new List<AXSharp.Connector.ITwinElement>();
        public IEnumerable<AXSharp.Connector.ITwinElement> GetKids()
        {
            return Kids;
        }

        private IList<AXSharp.Connector.ITwinPrimitive> ValueTags { get; } = new List<AXSharp.Connector.ITwinPrimitive>();
        public IEnumerable<AXSharp.Connector.ITwinPrimitive> GetValueTags()
        {
            return ValueTags;
        }

        public void AddValueTag(AXSharp.Connector.ITwinPrimitive valueTag)
        {
            ValueTags.Add(valueTag);
        }

        public void AddKid(AXSharp.Connector.ITwinElement kid)
        {
            Kids.Add(kid);
        }

        public void AddChild(AXSharp.Connector.ITwinObject twinObject)
        {
            Children.Add(twinObject);
        }

        protected AXSharp.Connector.Connector @Connector { get; }

        public AXSharp.Connector.Connector GetConnector()
        {
            return this.@Connector;
        }

        public string GetSymbolTail()
        {
            return this.SymbolTail;
        }

        public AXSharp.Connector.ITwinObject GetParent()
        {
            return this.@Parent;
        }

        public string Symbol { get; protected set; }

        private string _attributeName;
        public System.String AttributeName { get => string.IsNullOrEmpty(_attributeName) ? SymbolTail : _attributeName.Interpolate(this).CleanUpLocalizationTokens(); set => _attributeName = value; }

        public System.String GetAttributeName(System.Globalization.CultureInfo culture)
        {
            return this.Translate(_attributeName, culture).Interpolate(this);
        }

        private string _humanReadable;
        public string HumanReadable { get => string.IsNullOrEmpty(_humanReadable) ? SymbolTail : _humanReadable.Interpolate(this).CleanUpLocalizationTokens(); set => _humanReadable = value; }

        public System.String GetHumanReadable(System.Globalization.CultureInfo culture)
        {
            return this.Translate(_humanReadable, culture);
        }

        protected System.String @SymbolTail { get; set; }

        protected AXSharp.Connector.ITwinObject @Parent { get; set; }

        public Translator Interpreter => throw new NotImplementedException();

        //public AXSharp.Connector.Localizations.Translator Interpreter => global::axopen_data_app.PlcTranslator.Instance;
    }
}

namespace Pocos
{
    namespace AxoDataPersistentExchangeExample
    {
        public partial class PersistentRootObject : AXSharp.Connector.IPlain
        {
            public Boolean NotPersistentVariable { get; set; }

            public Int16 PersistentVariable_1 { get; set; }

            public Int16 PersistentVariable_2 { get; set; }

            public AxoDataPersistentExchangeExample.ObjectWithPersistentMember PropertyWithPersistentMember { get; set; } = new AxoDataPersistentExchangeExample.ObjectWithPersistentMember();
        }

        public partial class ObjectWithPersistentMember : AXSharp.Connector.IPlain
        {
            public Int16 NotPersistentVariable { get; set; }

            public AxoDataPersistentExchangeExample.InitializedPrimitives InitializedPrimitives { get; set; } = new AxoDataPersistentExchangeExample.InitializedPrimitives();
        }

        public partial class InitializedPrimitives : AXSharp.Connector.IPlain
        {
            public Boolean myBOOL { get; set; }

            public Byte myBYTE { get; set; }

            public UInt16 myWORD { get; set; }

            public UInt32 myDWORD { get; set; }

            public UInt64 myLWORD { get; set; }

            public SByte mySINTMin { get; set; }

            public SByte mySINTMax { get; set; }

            public Int16 myINT { get; set; }

            public Int32 myDINT { get; set; }

            public Int64 myLINT { get; set; }

            public Byte myUSINT { get; set; }

            public UInt16 myUINT { get; set; }

            public UInt32 myUDINT { get; set; }

            public UInt64 myULINT { get; set; }

            public Single myREAL { get; set; }

            public Double myLREAL { get; set; }

            public TimeSpan myTIME { get; set; } = default(TimeSpan);
            public TimeSpan myLTIME { get; set; } = default(TimeSpan);
            public DateOnly myDATE { get; set; } = default(DateOnly);
            public DateOnly myLDATE { get; set; } = default(DateOnly);
            public TimeSpan myTIME_OF_DAY { get; set; } = default(TimeSpan);
            public TimeSpan myLTIME_OF_DAY { get; set; } = default(TimeSpan);
            public DateTime myDATE_AND_TIME { get; set; } = default(DateTime);
            public DateTime myLDATE_AND_TIME { get; set; } = default(DateTime);
            public Char myCHAR { get; set; }

            public Char myWCHAR { get; set; }

            public string mySTRING { get; set; } = string.Empty;
            public string myWSTRING { get; set; } = string.Empty;
        }

    }
}
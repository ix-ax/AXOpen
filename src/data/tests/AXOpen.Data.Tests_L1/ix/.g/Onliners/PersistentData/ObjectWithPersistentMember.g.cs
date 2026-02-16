using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;
using AXOpen.Core;
using AXOpen;
using AXOpen.Data;

namespace Tests_L1.PersistentData
{
    public partial class ObjectWithPersistentMember : AXSharp.Connector.ITwinObject
    {
        public OnlinerInt NotPersistentVariable { get; }

        [Persistent("2")]
        public Tests_L1.Primitives.InitializedPrimitives InitializedPrimitives { get; }

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
            InitializedPrimitives = new Tests_L1.Primitives.InitializedPrimitives(this, "InitializedPrimitives", "InitializedPrimitives");
            parent.AddChild(this);
            parent.AddKid(this);
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async virtual Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public async Task<global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember> OnlineToPlainAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain = new global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember();
            await this.ReadAsync<IgnoreOnPocoOperation>(priority);
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
#pragma warning disable CS0612
            plain.InitializedPrimitives = await InitializedPrimitives._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task<global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember> _OnlineToPlainNoacAsync()
        {
            global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain = new global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember();
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
#pragma warning disable CS0612
            plain.InitializedPrimitives = await InitializedPrimitives._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember> _OnlineToPlainNoacAsync(global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain)
        {
            plain.NotPersistentVariable = NotPersistentVariable.LastValue;
#pragma warning disable CS0612
            plain.InitializedPrimitives = await InitializedPrimitives._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async virtual Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain, eAccessPriority priority = eAccessPriority.Normal)
        {
#pragma warning disable CS0612
            NotPersistentVariable.LethargicWrite(plain.NotPersistentVariable);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.InitializedPrimitives._PlainToOnlineNoacAsync(plain.InitializedPrimitives);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>(priority);
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain)
        {
#pragma warning disable CS0612
            NotPersistentVariable.LethargicWrite(plain.NotPersistentVariable);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.InitializedPrimitives._PlainToOnlineNoacAsync(plain.InitializedPrimitives);
#pragma warning restore CS0612
        }

        public async virtual Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public async Task<global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember> ShadowToPlainAsync()
        {
            global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain = new global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember();
            plain.NotPersistentVariable = NotPersistentVariable.Shadow;
            plain.InitializedPrimitives = await InitializedPrimitives.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember> ShadowToPlainAsync(global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain)
        {
            plain.NotPersistentVariable = NotPersistentVariable.Shadow;
            plain.InitializedPrimitives = await InitializedPrimitives.ShadowToPlainAsync();
            return plain;
        }

        public async virtual Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain)
        {
            NotPersistentVariable.Shadow = plain.NotPersistentVariable;
            await this.InitializedPrimitives.PlainToShadowAsync(plain.InitializedPrimitives);
            return this.RetrievePrimitives();
        }

        ///<inheritdoc/>
        public async virtual Task<bool> AnyChangeAsync<T>(T plain)
        {
            return await this.DetectsAnyChangeAsync((dynamic)plain);
        }

        ///<summary>
        ///Compares if the current plain object has changed from the previous object.This method is used by the framework to determine if the object has changed and needs to be updated.
        ///[!NOTE] Any member in the hierarchy that is ignored by the compilers (e.g. when CompilerOmitAttribute is used) will not be compared, and therefore will not be detected as changed.
        ///</summary>
        public async Task<bool> DetectsAnyChangeAsync(global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember plain, global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (plain.NotPersistentVariable != NotPersistentVariable.LastValue)
                    somethingChanged = true;
                if (await InitializedPrimitives.DetectsAnyChangeAsync(plain.InitializedPrimitives, latest.InitializedPrimitives))
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember CreateEmptyPoco()
        {
            return new global::Pocos.Tests_L1.PersistentData.ObjectWithPersistentMember();
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
            if (string.IsNullOrEmpty(_attributeName))
            {
                return SymbolTail;
            }

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
        public AXSharp.Connector.Localizations.Translator Interpreter => global::axopen_data_tests_l1.PlcTranslator.Instance;
    }
}
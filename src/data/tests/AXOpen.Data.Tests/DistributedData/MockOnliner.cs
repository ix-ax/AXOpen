using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;
using AXOpen.Core;
using AXOpen.Data;

namespace DistributedDataTest
{
    public partial class Context : AXOpen.Core.AxoContext
    {
        [DistributedData("Group_1")]
        public DistributedDataTest.HeaderManager HeaderManager_1 { get; }

        [DistributedData("Group_1", "Group_2")]
        public DistributedDataTest.HeaderManager HeaderManager_2 { get; }

        [DistributedData("Group_1", "Group_2", "Group_3")]
        public DistributedDataTest.StationManager StationManager_1 { get; }

        [DistributedData("Group_1", "Group_2", "Group_3", "Group_4")]
        public DistributedDataTest.StationManager StationManager_2 { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public Context(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            HeaderManager_1 = new DistributedDataTest.HeaderManager(this, "HeaderManager_1", "HeaderManager_1");
            HeaderManager_2 = new DistributedDataTest.HeaderManager(this, "HeaderManager_2", "HeaderManager_2");
            StationManager_1 = new DistributedDataTest.StationManager(this, "StationManager_1", "StationManager_1");
            StationManager_2 = new DistributedDataTest.StationManager(this, "StationManager_2", "StationManager_2");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.Context> OnlineToPlainAsync()
        {
            global::Pocos.DistributedDataTest.Context plain = new global::Pocos.DistributedDataTest.Context();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.HeaderManager_1 = await HeaderManager_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.HeaderManager_2 = await HeaderManager_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.StationManager_1 = await StationManager_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.StationManager_2 = await StationManager_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.DistributedDataTest.Context> _OnlineToPlainNoacAsync()
        {
            global::Pocos.DistributedDataTest.Context plain = new global::Pocos.DistributedDataTest.Context();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.HeaderManager_1 = await HeaderManager_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.HeaderManager_2 = await HeaderManager_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.StationManager_1 = await StationManager_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.StationManager_2 = await StationManager_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.Context> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.Context plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.HeaderManager_1 = await HeaderManager_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.HeaderManager_2 = await HeaderManager_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.StationManager_1 = await StationManager_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.StationManager_2 = await StationManager_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.Context plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.HeaderManager_1._PlainToOnlineNoacAsync(plain.HeaderManager_1);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.HeaderManager_2._PlainToOnlineNoacAsync(plain.HeaderManager_2);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.StationManager_1._PlainToOnlineNoacAsync(plain.StationManager_1);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.StationManager_2._PlainToOnlineNoacAsync(plain.StationManager_2);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.Context plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.HeaderManager_1._PlainToOnlineNoacAsync(plain.HeaderManager_1);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.HeaderManager_2._PlainToOnlineNoacAsync(plain.HeaderManager_2);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.StationManager_1._PlainToOnlineNoacAsync(plain.StationManager_1);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.StationManager_2._PlainToOnlineNoacAsync(plain.StationManager_2);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.Context> ShadowToPlainAsync()
        {
            global::Pocos.DistributedDataTest.Context plain = new global::Pocos.DistributedDataTest.Context();
            await base.ShadowToPlainAsync(plain);
            plain.HeaderManager_1 = await HeaderManager_1.ShadowToPlainAsync();
            plain.HeaderManager_2 = await HeaderManager_2.ShadowToPlainAsync();
            plain.StationManager_1 = await StationManager_1.ShadowToPlainAsync();
            plain.StationManager_2 = await StationManager_2.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.Context> ShadowToPlainAsync(global::Pocos.DistributedDataTest.Context plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.HeaderManager_1 = await HeaderManager_1.ShadowToPlainAsync();
            plain.HeaderManager_2 = await HeaderManager_2.ShadowToPlainAsync();
            plain.StationManager_1 = await StationManager_1.ShadowToPlainAsync();
            plain.StationManager_2 = await StationManager_2.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.Context plain)
        {
            await base.PlainToShadowAsync(plain);
            await this.HeaderManager_1.PlainToShadowAsync(plain.HeaderManager_1);
            await this.HeaderManager_2.PlainToShadowAsync(plain.HeaderManager_2);
            await this.StationManager_1.PlainToShadowAsync(plain.StationManager_1);
            await this.StationManager_2.PlainToShadowAsync(plain.StationManager_2);
            return this.RetrievePrimitives();
        }

        ///<inheritdoc/>
        public async override Task<bool> AnyChangeAsync<T>(T plain)
        {
            return await this.DetectsAnyChangeAsync((dynamic)plain);
        }

        ///<summary>
        ///Compares if the current plain object has changed from the previous object.This method is used by the framework to determine if the object has changed and needs to be updated.
        ///[!NOTE] Any member in the hierarchy that is ignored by the compilers (e.g. when CompilerOmitAttribute is used) will not be compared, and therefore will not be detected as changed.
        ///</summary>
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.DistributedDataTest.Context plain, global::Pocos.DistributedDataTest.Context latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (await HeaderManager_1.DetectsAnyChangeAsync(plain.HeaderManager_1, latest.HeaderManager_1))
                    somethingChanged = true;
                if (await HeaderManager_2.DetectsAnyChangeAsync(plain.HeaderManager_2, latest.HeaderManager_2))
                    somethingChanged = true;
                if (await StationManager_1.DetectsAnyChangeAsync(plain.StationManager_1, latest.StationManager_1))
                    somethingChanged = true;
                if (await StationManager_2.DetectsAnyChangeAsync(plain.StationManager_2, latest.StationManager_2))
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.DistributedDataTest.Context CreateEmptyPoco()
        {
            return new global::Pocos.DistributedDataTest.Context();
        }
    }

    public partial class HeaderManager : AXOpen.Data.AxoDataExchange<DistributedDataTest.HeaderData, Pocos.DistributedDataTest.HeaderData>
    {
        [AXOpen.Data.AxoDataEntityAttribute]
        [Container(Layout.Stack)]
        public DistributedDataTest.HeaderData Set { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public HeaderManager(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Set = new DistributedDataTest.HeaderData(this, "Header", "Set");
            Set.AttributeName = "Header";
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.HeaderManager> OnlineToPlainAsync()
        {
            global::Pocos.DistributedDataTest.HeaderManager plain = new global::Pocos.DistributedDataTest.HeaderManager();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Set = await Set._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.DistributedDataTest.HeaderManager> _OnlineToPlainNoacAsync()
        {
            global::Pocos.DistributedDataTest.HeaderManager plain = new global::Pocos.DistributedDataTest.HeaderManager();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Set = await Set._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.HeaderManager> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.HeaderManager plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Set = await Set._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.HeaderManager plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Set._PlainToOnlineNoacAsync(plain.Set);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.HeaderManager plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Set._PlainToOnlineNoacAsync(plain.Set);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.HeaderManager> ShadowToPlainAsync()
        {
            global::Pocos.DistributedDataTest.HeaderManager plain = new global::Pocos.DistributedDataTest.HeaderManager();
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.HeaderManager> ShadowToPlainAsync(global::Pocos.DistributedDataTest.HeaderManager plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.HeaderManager plain)
        {
            await base.PlainToShadowAsync(plain);
            await this.Set.PlainToShadowAsync(plain.Set);
            return this.RetrievePrimitives();
        }

        ///<inheritdoc/>
        public async override Task<bool> AnyChangeAsync<T>(T plain)
        {
            return await this.DetectsAnyChangeAsync((dynamic)plain);
        }

        ///<summary>
        ///Compares if the current plain object has changed from the previous object.This method is used by the framework to determine if the object has changed and needs to be updated.
        ///[!NOTE] Any member in the hierarchy that is ignored by the compilers (e.g. when CompilerOmitAttribute is used) will not be compared, and therefore will not be detected as changed.
        ///</summary>
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.DistributedDataTest.HeaderManager plain, global::Pocos.DistributedDataTest.HeaderManager latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (await Set.DetectsAnyChangeAsync(plain.Set, latest.Set))
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.DistributedDataTest.HeaderManager CreateEmptyPoco()
        {
            return new global::Pocos.DistributedDataTest.HeaderManager();
        }
    }

    public partial class HeaderData : AXOpen.Data.AxoDataEntity
    {
        public OnlinerString ComponentType { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public HeaderData(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            ComponentType = @Connector.ConnectorAdapter.AdapterFactory.CreateSTRING(this, "ComponentType", "ComponentType");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.HeaderData> OnlineToPlainAsync()
        {
            global::Pocos.DistributedDataTest.HeaderData plain = new global::Pocos.DistributedDataTest.HeaderData();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.ComponentType = ComponentType.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.DistributedDataTest.HeaderData> _OnlineToPlainNoacAsync()
        {
            global::Pocos.DistributedDataTest.HeaderData plain = new global::Pocos.DistributedDataTest.HeaderData();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.ComponentType = ComponentType.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.HeaderData> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.ComponentType = ComponentType.LastValue;
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            ComponentType.LethargicWrite(plain.ComponentType);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            ComponentType.LethargicWrite(plain.ComponentType);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.HeaderData> ShadowToPlainAsync()
        {
            global::Pocos.DistributedDataTest.HeaderData plain = new global::Pocos.DistributedDataTest.HeaderData();
            await base.ShadowToPlainAsync(plain);
            plain.ComponentType = ComponentType.Shadow;
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.HeaderData> ShadowToPlainAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.ComponentType = ComponentType.Shadow;
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
            await base.PlainToShadowAsync(plain);
            ComponentType.Shadow = plain.ComponentType;
            return this.RetrievePrimitives();
        }

        ///<inheritdoc/>
        public async override Task<bool> AnyChangeAsync<T>(T plain)
        {
            return await this.DetectsAnyChangeAsync((dynamic)plain);
        }

        ///<summary>
        ///Compares if the current plain object has changed from the previous object.This method is used by the framework to determine if the object has changed and needs to be updated.
        ///[!NOTE] Any member in the hierarchy that is ignored by the compilers (e.g. when CompilerOmitAttribute is used) will not be compared, and therefore will not be detected as changed.
        ///</summary>
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.DistributedDataTest.HeaderData plain, global::Pocos.DistributedDataTest.HeaderData latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (plain.ComponentType != ComponentType.LastValue)
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.DistributedDataTest.HeaderData CreateEmptyPoco()
        {
            return new global::Pocos.DistributedDataTest.HeaderData();
        }
    }

    public partial class StationManager : AXOpen.Data.AxoDataExchange<DistributedDataTest.StationData, Pocos.DistributedDataTest.StationData>
    {
        [AXOpen.Data.AxoDataEntityAttribute]
        [Container(Layout.Stack)]
        public DistributedDataTest.StationData Set { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public StationManager(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Set = new DistributedDataTest.StationData(this, "Station", "Set");
            Set.AttributeName = "Station";
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.StationManager> OnlineToPlainAsync()
        {
            global::Pocos.DistributedDataTest.StationManager plain = new global::Pocos.DistributedDataTest.StationManager();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Set = await Set._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.DistributedDataTest.StationManager> _OnlineToPlainNoacAsync()
        {
            global::Pocos.DistributedDataTest.StationManager plain = new global::Pocos.DistributedDataTest.StationManager();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Set = await Set._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.StationManager> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.StationManager plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Set = await Set._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.StationManager plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Set._PlainToOnlineNoacAsync(plain.Set);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.StationManager plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Set._PlainToOnlineNoacAsync(plain.Set);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.StationManager> ShadowToPlainAsync()
        {
            global::Pocos.DistributedDataTest.StationManager plain = new global::Pocos.DistributedDataTest.StationManager();
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.StationManager> ShadowToPlainAsync(global::Pocos.DistributedDataTest.StationManager plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.StationManager plain)
        {
            await base.PlainToShadowAsync(plain);
            await this.Set.PlainToShadowAsync(plain.Set);
            return this.RetrievePrimitives();
        }

        ///<inheritdoc/>
        public async override Task<bool> AnyChangeAsync<T>(T plain)
        {
            return await this.DetectsAnyChangeAsync((dynamic)plain);
        }

        ///<summary>
        ///Compares if the current plain object has changed from the previous object.This method is used by the framework to determine if the object has changed and needs to be updated.
        ///[!NOTE] Any member in the hierarchy that is ignored by the compilers (e.g. when CompilerOmitAttribute is used) will not be compared, and therefore will not be detected as changed.
        ///</summary>
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.DistributedDataTest.StationManager plain, global::Pocos.DistributedDataTest.StationManager latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (await Set.DetectsAnyChangeAsync(plain.Set, latest.Set))
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.DistributedDataTest.StationManager CreateEmptyPoco()
        {
            return new global::Pocos.DistributedDataTest.StationManager();
        }
    }

    public partial class StationData : AXOpen.Data.AxoDataEntity
    {
        public OnlinerByte Result { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public StationData(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Result = @Connector.ConnectorAdapter.AdapterFactory.CreateBYTE(this, "Result", "Result");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.StationData> OnlineToPlainAsync()
        {
            global::Pocos.DistributedDataTest.StationData plain = new global::Pocos.DistributedDataTest.StationData();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.Result = Result.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.DistributedDataTest.StationData> _OnlineToPlainNoacAsync()
        {
            global::Pocos.DistributedDataTest.StationData plain = new global::Pocos.DistributedDataTest.StationData();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.Result = Result.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.StationData> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.Result = Result.LastValue;
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            Result.LethargicWrite(plain.Result);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            Result.LethargicWrite(plain.Result);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.StationData> ShadowToPlainAsync()
        {
            global::Pocos.DistributedDataTest.StationData plain = new global::Pocos.DistributedDataTest.StationData();
            await base.ShadowToPlainAsync(plain);
            plain.Result = Result.Shadow;
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.StationData> ShadowToPlainAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Result = Result.Shadow;
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
            await base.PlainToShadowAsync(plain);
            Result.Shadow = plain.Result;
            return this.RetrievePrimitives();
        }

        ///<inheritdoc/>
        public async override Task<bool> AnyChangeAsync<T>(T plain)
        {
            return await this.DetectsAnyChangeAsync((dynamic)plain);
        }

        ///<summary>
        ///Compares if the current plain object has changed from the previous object.This method is used by the framework to determine if the object has changed and needs to be updated.
        ///[!NOTE] Any member in the hierarchy that is ignored by the compilers (e.g. when CompilerOmitAttribute is used) will not be compared, and therefore will not be detected as changed.
        ///</summary>
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.DistributedDataTest.StationData plain, global::Pocos.DistributedDataTest.StationData latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (plain.Result != Result.LastValue)
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.DistributedDataTest.StationData CreateEmptyPoco()
        {
            return new global::Pocos.DistributedDataTest.StationData();
        }
    }
}
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
        [AXOpen.Data.DistributedDataAttribute("Group_1")]
        public DistributedDataTest.HeaderManager HeaderManager_1 { get; }

        [AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2")]
        public DistributedDataTest.HeaderManager HeaderManager_2 { get; }

        [AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2", "Group_3")]
        public DistributedDataTest.StationManager StationManager_1 { get; }

        [AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2", "Group_3", "Group_4")]
        public DistributedDataTest.StationManager StationManager_2 { get; }

        [AXOpen.Data.DistributedDataAttribute("AxoDataFragmentExchange")]
        public DistributedDataTest.FragmentExchange Fragment { get; }

        [AXOpen.Data.DistributedDataAttribute("AxoObjectWrap")]
        public DistributedDataTest.AxoProcess AxoProcess { get; }

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
            Fragment = new DistributedDataTest.FragmentExchange(this, "Fragment", "Fragment");
            AxoProcess = new DistributedDataTest.AxoProcess(this, "AxoProcess", "AxoProcess");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
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
#pragma warning disable CS0612
            plain.Fragment = await Fragment._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.AxoProcess = await AxoProcess._OnlineToPlainNoacAsync();
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
#pragma warning disable CS0612
            plain.Fragment = await Fragment._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.AxoProcess = await AxoProcess._OnlineToPlainNoacAsync();
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
#pragma warning disable CS0612
            plain.Fragment = await Fragment._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.AxoProcess = await AxoProcess._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
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
#pragma warning disable CS0612
            await this.Fragment._PlainToOnlineNoacAsync(plain.Fragment);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.AxoProcess._PlainToOnlineNoacAsync(plain.AxoProcess);
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
#pragma warning disable CS0612
            await this.Fragment._PlainToOnlineNoacAsync(plain.Fragment);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.AxoProcess._PlainToOnlineNoacAsync(plain.AxoProcess);
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
            plain.Fragment = await Fragment.ShadowToPlainAsync();
            plain.AxoProcess = await AxoProcess.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.Context> ShadowToPlainAsync(global::Pocos.DistributedDataTest.Context plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.HeaderManager_1 = await HeaderManager_1.ShadowToPlainAsync();
            plain.HeaderManager_2 = await HeaderManager_2.ShadowToPlainAsync();
            plain.StationManager_1 = await StationManager_1.ShadowToPlainAsync();
            plain.StationManager_2 = await StationManager_2.ShadowToPlainAsync();
            plain.Fragment = await Fragment.ShadowToPlainAsync();
            plain.AxoProcess = await AxoProcess.ShadowToPlainAsync();
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
            await this.Fragment.PlainToShadowAsync(plain.Fragment);
            await this.AxoProcess.PlainToShadowAsync(plain.AxoProcess);
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
                if (await Fragment.DetectsAnyChangeAsync(plain.Fragment, latest.Fragment))
                    somethingChanged = true;
                if (await AxoProcess.DetectsAnyChangeAsync(plain.AxoProcess, latest.AxoProcess))
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

    public partial class AxoProcess : AXOpen.Core.AxoObject
    {
        public DistributedDataTest.HeaderManager Header { get; }
        public DistributedDataTest.StationManager Station_1 { get; }
        public DistributedDataTest.StationManager Station_2 { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public AxoProcess(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Header = new DistributedDataTest.HeaderManager(this, "Header", "Header");
            Station_1 = new DistributedDataTest.StationManager(this, "Station_1", "Station_1");
            Station_2 = new DistributedDataTest.StationManager(this, "Station_2", "Station_2");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.DistributedDataTest.AxoProcess> OnlineToPlainAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            global::Pocos.DistributedDataTest.AxoProcess plain = new global::Pocos.DistributedDataTest.AxoProcess();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Header = await Header._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_1 = await Station_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_2 = await Station_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.DistributedDataTest.AxoProcess> _OnlineToPlainNoacAsync()
        {
            global::Pocos.DistributedDataTest.AxoProcess plain = new global::Pocos.DistributedDataTest.AxoProcess();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Header = await Header._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_1 = await Station_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_2 = await Station_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.AxoProcess> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.AxoProcess plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Header = await Header._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_1 = await Station_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_2 = await Station_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain,priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.AxoProcess plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Header._PlainToOnlineNoacAsync(plain.Header);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.Station_1._PlainToOnlineNoacAsync(plain.Station_1);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.Station_2._PlainToOnlineNoacAsync(plain.Station_2);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.AxoProcess plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Header._PlainToOnlineNoacAsync(plain.Header);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.Station_1._PlainToOnlineNoacAsync(plain.Station_1);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.Station_2._PlainToOnlineNoacAsync(plain.Station_2);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.AxoProcess> ShadowToPlainAsync()
        {
            global::Pocos.DistributedDataTest.AxoProcess plain = new global::Pocos.DistributedDataTest.AxoProcess();
            await base.ShadowToPlainAsync(plain);
            plain.Header = await Header.ShadowToPlainAsync();
            plain.Station_1 = await Station_1.ShadowToPlainAsync();
            plain.Station_2 = await Station_2.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.AxoProcess> ShadowToPlainAsync(global::Pocos.DistributedDataTest.AxoProcess plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Header = await Header.ShadowToPlainAsync();
            plain.Station_1 = await Station_1.ShadowToPlainAsync();
            plain.Station_2 = await Station_2.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.AxoProcess plain)
        {
            await base.PlainToShadowAsync(plain);
            await this.Header.PlainToShadowAsync(plain.Header);
            await this.Station_1.PlainToShadowAsync(plain.Station_1);
            await this.Station_2.PlainToShadowAsync(plain.Station_2);
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
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.DistributedDataTest.AxoProcess plain, global::Pocos.DistributedDataTest.AxoProcess latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (await Header.DetectsAnyChangeAsync(plain.Header, latest.Header))
                    somethingChanged = true;
                if (await Station_1.DetectsAnyChangeAsync(plain.Station_1, latest.Station_1))
                    somethingChanged = true;
                if (await Station_2.DetectsAnyChangeAsync(plain.Station_2, latest.Station_2))
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.DistributedDataTest.AxoProcess CreateEmptyPoco()
        {
            return new global::Pocos.DistributedDataTest.AxoProcess();
        }
    }

    public partial class FragmentExchange : AXOpen.Data.AxoDataFragmentExchange
    {
        [AXOpen.Data.AxoDataFragmentAttribute]
        public DistributedDataTest.HeaderManager Header { get; }

        [AXOpen.Data.AxoDataFragmentAttribute]
        public DistributedDataTest.StationManager Station_1 { get; }

        [AXOpen.Data.AxoDataFragmentAttribute]
        public DistributedDataTest.StationManager Station_2 { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public FragmentExchange(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Header = new DistributedDataTest.HeaderManager(this, "Header", "Header");
            Station_1 = new DistributedDataTest.StationManager(this, "Station_1", "Station_1");
            Station_2 = new DistributedDataTest.StationManager(this, "Station_2", "Station_2");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.DistributedDataTest.FragmentExchange> OnlineToPlainAsync()
        {
            global::Pocos.DistributedDataTest.FragmentExchange plain = new global::Pocos.DistributedDataTest.FragmentExchange();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Header = await Header._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_1 = await Station_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_2 = await Station_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.DistributedDataTest.FragmentExchange> _OnlineToPlainNoacAsync()
        {
            global::Pocos.DistributedDataTest.FragmentExchange plain = new global::Pocos.DistributedDataTest.FragmentExchange();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Header = await Header._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_1 = await Station_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_2 = await Station_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.FragmentExchange> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.FragmentExchange plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Header = await Header._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_1 = await Station_1._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.Station_2 = await Station_2._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.FragmentExchange plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Header._PlainToOnlineNoacAsync(plain.Header);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.Station_1._PlainToOnlineNoacAsync(plain.Station_1);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.Station_2._PlainToOnlineNoacAsync(plain.Station_2);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.FragmentExchange plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Header._PlainToOnlineNoacAsync(plain.Header);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.Station_1._PlainToOnlineNoacAsync(plain.Station_1);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.Station_2._PlainToOnlineNoacAsync(plain.Station_2);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.DistributedDataTest.FragmentExchange> ShadowToPlainAsync()
        {
            global::Pocos.DistributedDataTest.FragmentExchange plain = new global::Pocos.DistributedDataTest.FragmentExchange();
            await base.ShadowToPlainAsync(plain);
            plain.Header = await Header.ShadowToPlainAsync();
            plain.Station_1 = await Station_1.ShadowToPlainAsync();
            plain.Station_2 = await Station_2.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.FragmentExchange> ShadowToPlainAsync(global::Pocos.DistributedDataTest.FragmentExchange plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Header = await Header.ShadowToPlainAsync();
            plain.Station_1 = await Station_1.ShadowToPlainAsync();
            plain.Station_2 = await Station_2.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.FragmentExchange plain)
        {
            await base.PlainToShadowAsync(plain);
            await this.Header.PlainToShadowAsync(plain.Header);
            await this.Station_1.PlainToShadowAsync(plain.Station_1);
            await this.Station_2.PlainToShadowAsync(plain.Station_2);
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
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.DistributedDataTest.FragmentExchange plain, global::Pocos.DistributedDataTest.FragmentExchange latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (await Header.DetectsAnyChangeAsync(plain.Header, latest.Header))
                    somethingChanged = true;
                if (await Station_1.DetectsAnyChangeAsync(plain.Station_1, latest.Station_1))
                    somethingChanged = true;
                if (await Station_2.DetectsAnyChangeAsync(plain.Station_2, latest.Station_2))
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.DistributedDataTest.FragmentExchange CreateEmptyPoco()
        {
            return new global::Pocos.DistributedDataTest.FragmentExchange();
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
            Set = new DistributedDataTest.HeaderData(this, "Shared Header", "Set");
            Set.AttributeName = @"Shared Header";
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
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

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
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
        public OnlinerString HeaderPartialName { get; }
        public OnlinerInt HeaderIndex { get; }
        public OnlinerBool HeaderGlogalPass { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public HeaderData(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            HeaderPartialName = @Connector.ConnectorAdapter.AdapterFactory.CreateSTRING(this, "HeaderPartialName", "HeaderPartialName");
            HeaderIndex = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "HeaderIndex", "HeaderIndex");
            HeaderGlogalPass = @Connector.ConnectorAdapter.AdapterFactory.CreateBOOL(this, "HeaderGlogalPass", "HeaderGlogalPass");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.DistributedDataTest.HeaderData> OnlineToPlainAsync()
        {
            global::Pocos.DistributedDataTest.HeaderData plain = new global::Pocos.DistributedDataTest.HeaderData();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.HeaderPartialName = HeaderPartialName.LastValue;
            plain.HeaderIndex = HeaderIndex.LastValue;
            plain.HeaderGlogalPass = HeaderGlogalPass.LastValue;
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
            plain.HeaderPartialName = HeaderPartialName.LastValue;
            plain.HeaderIndex = HeaderIndex.LastValue;
            plain.HeaderGlogalPass = HeaderGlogalPass.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.HeaderData> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.HeaderPartialName = HeaderPartialName.LastValue;
            plain.HeaderIndex = HeaderIndex.LastValue;
            plain.HeaderGlogalPass = HeaderGlogalPass.LastValue;
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            HeaderPartialName.LethargicWrite(plain.HeaderPartialName);
#pragma warning restore CS0612
#pragma warning disable CS0612
            HeaderIndex.LethargicWrite(plain.HeaderIndex);
#pragma warning restore CS0612
#pragma warning disable CS0612
            HeaderGlogalPass.LethargicWrite(plain.HeaderGlogalPass);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            HeaderPartialName.LethargicWrite(plain.HeaderPartialName);
#pragma warning restore CS0612
#pragma warning disable CS0612
            HeaderIndex.LethargicWrite(plain.HeaderIndex);
#pragma warning restore CS0612
#pragma warning disable CS0612
            HeaderGlogalPass.LethargicWrite(plain.HeaderGlogalPass);
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
            plain.HeaderPartialName = HeaderPartialName.Shadow;
            plain.HeaderIndex = HeaderIndex.Shadow;
            plain.HeaderGlogalPass = HeaderGlogalPass.Shadow;
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.HeaderData> ShadowToPlainAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.HeaderPartialName = HeaderPartialName.Shadow;
            plain.HeaderIndex = HeaderIndex.Shadow;
            plain.HeaderGlogalPass = HeaderGlogalPass.Shadow;
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.HeaderData plain)
        {
            await base.PlainToShadowAsync(plain);
            HeaderPartialName.Shadow = plain.HeaderPartialName;
            HeaderIndex.Shadow = plain.HeaderIndex;
            HeaderGlogalPass.Shadow = plain.HeaderGlogalPass;
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
                if (plain.HeaderPartialName != HeaderPartialName.LastValue)
                    somethingChanged = true;
                if (plain.HeaderIndex != HeaderIndex.LastValue)
                    somethingChanged = true;
                if (plain.HeaderGlogalPass != HeaderGlogalPass.LastValue)
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
            Set.AttributeName = @"Station";
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
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

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.StationManager plain, eAccessPriority priority = eAccessPriority.Normal)
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
        public OnlinerString StationName { get; }
        public OnlinerInt StaionOperation { get; }
        public OnlinerBool StationPass { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public StationData(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            StationName = @Connector.ConnectorAdapter.AdapterFactory.CreateSTRING(this, "StationName", "StationName");
            StaionOperation = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "StaionOperation", "StaionOperation");
            StationPass = @Connector.ConnectorAdapter.AdapterFactory.CreateBOOL(this, "StationPass", "StationPass");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.DistributedDataTest.StationData> OnlineToPlainAsync()
        {
            global::Pocos.DistributedDataTest.StationData plain = new global::Pocos.DistributedDataTest.StationData();
            await this.ReadAsync<IgnoreOnPocoOperation>();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.StationName = StationName.LastValue;
            plain.StaionOperation = StaionOperation.LastValue;
            plain.StationPass = StationPass.LastValue;
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
            plain.StationName = StationName.LastValue;
            plain.StaionOperation = StaionOperation.LastValue;
            plain.StationPass = StationPass.LastValue;
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.DistributedDataTest.StationData> _OnlineToPlainNoacAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
            plain.StationName = StationName.LastValue;
            plain.StaionOperation = StaionOperation.LastValue;
            plain.StationPass = StationPass.LastValue;
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.DistributedDataTest.StationData plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            StationName.LethargicWrite(plain.StationName);
#pragma warning restore CS0612
#pragma warning disable CS0612
            StaionOperation.LethargicWrite(plain.StaionOperation);
#pragma warning restore CS0612
#pragma warning disable CS0612
            StationPass.LethargicWrite(plain.StationPass);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>();
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            StationName.LethargicWrite(plain.StationName);
#pragma warning restore CS0612
#pragma warning disable CS0612
            StaionOperation.LethargicWrite(plain.StaionOperation);
#pragma warning restore CS0612
#pragma warning disable CS0612
            StationPass.LethargicWrite(plain.StationPass);
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
            plain.StationName = StationName.Shadow;
            plain.StaionOperation = StaionOperation.Shadow;
            plain.StationPass = StationPass.Shadow;
            return plain;
        }

        protected async Task<global::Pocos.DistributedDataTest.StationData> ShadowToPlainAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.StationName = StationName.Shadow;
            plain.StaionOperation = StaionOperation.Shadow;
            plain.StationPass = StationPass.Shadow;
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.DistributedDataTest.StationData plain)
        {
            await base.PlainToShadowAsync(plain);
            StationName.Shadow = plain.StationName;
            StaionOperation.Shadow = plain.StaionOperation;
            StationPass.Shadow = plain.StationPass;
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
                if (plain.StationName != StationName.LastValue)
                    somethingChanged = true;
                if (plain.StaionOperation != StaionOperation.LastValue)
                    somethingChanged = true;
                if (plain.StationPass != StationPass.LastValue)
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
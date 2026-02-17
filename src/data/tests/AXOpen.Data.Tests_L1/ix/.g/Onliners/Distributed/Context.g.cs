using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;
using AXOpen.Core;
using AXOpen.Data;

namespace Tests_L1.Distributed
{
    public partial class DistributedDataContext : AXOpen.Core.AxoContext
    {
        public AXOpen.Core.AxoObject _rootObject { get; }

        [AXOpen.Data.DistributedDataAttribute("Group_1")]
        public Tests_L1.SharedEntityHeaderManager HeaderManager_1 { get; }

        [AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2")]
        public Tests_L1.SharedEntityHeaderManager HeaderManager_2 { get; }

        [AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2", "Group_3")]
        public Tests_L1.StationDataManager StationManager_1 { get; }

        [AXOpen.Data.DistributedDataAttribute("Group_1", "Group_2", "Group_3", "Group_4")]
        public Tests_L1.StationDataManager StationManager_2 { get; }

        [AXOpen.Data.DistributedDataAttribute("AxoDataFragmentExchange")]
        public Tests_L1.FragmentData.FragmentProcessDataManager Fragment { get; }

        [AXOpen.Data.DistributedDataAttribute("AxoObjectWrap")]
        public Tests_L1.Distributed.ExchangesWrappedInAxoObject AxoProcess { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public DistributedDataContext(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            _rootObject = new AXOpen.Core.AxoObject(this, "_rootObject", "_rootObject");
            HeaderManager_1 = new Tests_L1.SharedEntityHeaderManager(this, "HeaderManager_1", "HeaderManager_1");
            HeaderManager_2 = new Tests_L1.SharedEntityHeaderManager(this, "HeaderManager_2", "HeaderManager_2");
            StationManager_1 = new Tests_L1.StationDataManager(this, "StationManager_1", "StationManager_1");
            StationManager_2 = new Tests_L1.StationDataManager(this, "StationManager_2", "StationManager_2");
            Fragment = new Tests_L1.FragmentData.FragmentProcessDataManager(this, "Fragment", "Fragment");
            AxoProcess = new Tests_L1.Distributed.ExchangesWrappedInAxoObject(this, "AxoProcess", "AxoProcess");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.Tests_L1.Distributed.DistributedDataContext> OnlineToPlainAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            global::Pocos.Tests_L1.Distributed.DistributedDataContext plain = new global::Pocos.Tests_L1.Distributed.DistributedDataContext();
            await this.ReadAsync<IgnoreOnPocoOperation>(priority);
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain._rootObject = await _rootObject._OnlineToPlainNoacAsync();
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
        public new async Task<global::Pocos.Tests_L1.Distributed.DistributedDataContext> _OnlineToPlainNoacAsync()
        {
            global::Pocos.Tests_L1.Distributed.DistributedDataContext plain = new global::Pocos.Tests_L1.Distributed.DistributedDataContext();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain._rootObject = await _rootObject._OnlineToPlainNoacAsync();
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
        protected async Task<global::Pocos.Tests_L1.Distributed.DistributedDataContext> _OnlineToPlainNoacAsync(global::Pocos.Tests_L1.Distributed.DistributedDataContext plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain._rootObject = await _rootObject._OnlineToPlainNoacAsync();
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

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.Tests_L1.Distributed.DistributedDataContext plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this._rootObject._PlainToOnlineNoacAsync(plain._rootObject);
#pragma warning restore CS0612
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
            return await this.WriteAsync<IgnoreOnPocoOperation>(priority);
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.Tests_L1.Distributed.DistributedDataContext plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this._rootObject._PlainToOnlineNoacAsync(plain._rootObject);
#pragma warning restore CS0612
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

        public new async Task<global::Pocos.Tests_L1.Distributed.DistributedDataContext> ShadowToPlainAsync()
        {
            global::Pocos.Tests_L1.Distributed.DistributedDataContext plain = new global::Pocos.Tests_L1.Distributed.DistributedDataContext();
            await base.ShadowToPlainAsync(plain);
            plain._rootObject = await _rootObject.ShadowToPlainAsync();
            plain.HeaderManager_1 = await HeaderManager_1.ShadowToPlainAsync();
            plain.HeaderManager_2 = await HeaderManager_2.ShadowToPlainAsync();
            plain.StationManager_1 = await StationManager_1.ShadowToPlainAsync();
            plain.StationManager_2 = await StationManager_2.ShadowToPlainAsync();
            plain.Fragment = await Fragment.ShadowToPlainAsync();
            plain.AxoProcess = await AxoProcess.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.Tests_L1.Distributed.DistributedDataContext> ShadowToPlainAsync(global::Pocos.Tests_L1.Distributed.DistributedDataContext plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain._rootObject = await _rootObject.ShadowToPlainAsync();
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

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.Tests_L1.Distributed.DistributedDataContext plain)
        {
            await base.PlainToShadowAsync(plain);
            await this._rootObject.PlainToShadowAsync(plain._rootObject);
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
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.Tests_L1.Distributed.DistributedDataContext plain, global::Pocos.Tests_L1.Distributed.DistributedDataContext latest = null)
        {
            if (latest == null)
                latest = await this._OnlineToPlainNoacAsync();
            var somethingChanged = false;
            return await Task.Run(async () =>
            {
                if (await base.DetectsAnyChangeAsync(plain))
                    return true;
                if (await _rootObject.DetectsAnyChangeAsync(plain._rootObject, latest._rootObject))
                    somethingChanged = true;
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

        public new global::Pocos.Tests_L1.Distributed.DistributedDataContext CreateEmptyPoco()
        {
            return new global::Pocos.Tests_L1.Distributed.DistributedDataContext();
        }
    }
}
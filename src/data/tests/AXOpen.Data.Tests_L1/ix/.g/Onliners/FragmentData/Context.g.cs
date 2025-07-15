using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;
using AXOpen.Core;
using AXOpen.Data;

namespace Tests_L1.FragmentData
{
    public partial class FragmentDataContext : AXOpen.Core.AxoContext
    {
        public AXOpen.Core.AxoObject _rootObject { get; }
        public Tests_L1.FragmentData.FragmentProcessDataManager DataManager { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public FragmentDataContext(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            _rootObject = new AXOpen.Core.AxoObject(this, "_rootObject", "_rootObject");
            DataManager = new Tests_L1.FragmentData.FragmentProcessDataManager(this, "DataManager", "DataManager");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.Tests_L1.FragmentData.FragmentDataContext> OnlineToPlainAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain = new global::Pocos.Tests_L1.FragmentData.FragmentDataContext();
            await this.ReadAsync<IgnoreOnPocoOperation>(priority);
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain._rootObject = await _rootObject._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.DataManager = await DataManager._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public new async Task<global::Pocos.Tests_L1.FragmentData.FragmentDataContext> _OnlineToPlainNoacAsync()
        {
            global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain = new global::Pocos.Tests_L1.FragmentData.FragmentDataContext();
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain._rootObject = await _rootObject._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.DataManager = await DataManager._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `OnlineToPlain` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        protected async Task<global::Pocos.Tests_L1.FragmentData.FragmentDataContext> _OnlineToPlainNoacAsync(global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain)
        {
#pragma warning disable CS0612
            await base._OnlineToPlainNoacAsync(plain);
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain._rootObject = await _rootObject._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
#pragma warning disable CS0612
            plain.DataManager = await DataManager._OnlineToPlainNoacAsync();
#pragma warning restore CS0612
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await this.PlainToOnlineAsync((dynamic)plain, priority);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this._rootObject._PlainToOnlineNoacAsync(plain._rootObject);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.DataManager._PlainToOnlineNoacAsync(plain.DataManager);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>(priority);
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this._rootObject._PlainToOnlineNoacAsync(plain._rootObject);
#pragma warning restore CS0612
#pragma warning disable CS0612
            await this.DataManager._PlainToOnlineNoacAsync(plain.DataManager);
#pragma warning restore CS0612
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<global::Pocos.Tests_L1.FragmentData.FragmentDataContext> ShadowToPlainAsync()
        {
            global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain = new global::Pocos.Tests_L1.FragmentData.FragmentDataContext();
            await base.ShadowToPlainAsync(plain);
            plain._rootObject = await _rootObject.ShadowToPlainAsync();
            plain.DataManager = await DataManager.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.Tests_L1.FragmentData.FragmentDataContext> ShadowToPlainAsync(global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain._rootObject = await _rootObject.ShadowToPlainAsync();
            plain.DataManager = await DataManager.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain)
        {
            await base.PlainToShadowAsync(plain);
            await this._rootObject.PlainToShadowAsync(plain._rootObject);
            await this.DataManager.PlainToShadowAsync(plain.DataManager);
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
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.Tests_L1.FragmentData.FragmentDataContext plain, global::Pocos.Tests_L1.FragmentData.FragmentDataContext latest = null)
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
                if (await DataManager.DetectsAnyChangeAsync(plain.DataManager, latest.DataManager))
                    somethingChanged = true;
                plain = latest;
                return somethingChanged;
            });
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new global::Pocos.Tests_L1.FragmentData.FragmentDataContext CreateEmptyPoco()
        {
            return new global::Pocos.Tests_L1.FragmentData.FragmentDataContext();
        }
    }
}
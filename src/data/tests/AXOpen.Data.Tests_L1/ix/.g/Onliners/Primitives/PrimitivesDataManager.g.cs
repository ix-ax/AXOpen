using System;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using System.Collections.Generic;
using AXSharp.Connector.Localizations;
using AXSharp.Abstractions.Presentation;
using AXOpen.Core;
using AXOpen.Data;

namespace Tests_L1.Primitives
{
    public partial class PrimitivesDataManager : AXOpen.Data.AxoDataExchange<Tests_L1.Primitives.PrimitivesDataEntity, Pocos.Tests_L1.Primitives.PrimitivesDataEntity>
    {
        [AXOpen.Data.AxoDataEntityAttribute]
        public Tests_L1.Primitives.PrimitivesDataEntity Set { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public PrimitivesDataManager(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Set = new Tests_L1.Primitives.PrimitivesDataEntity(this, "Set", "Set");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.Tests_L1.Primitives.PrimitivesDataManager> OnlineToPlainAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain = new global::Pocos.Tests_L1.Primitives.PrimitivesDataManager();
            await this.ReadAsync<IgnoreOnPocoOperation>(priority);
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
        public new async Task<global::Pocos.Tests_L1.Primitives.PrimitivesDataManager> _OnlineToPlainNoacAsync()
        {
            global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain = new global::Pocos.Tests_L1.Primitives.PrimitivesDataManager();
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
        protected async Task<global::Pocos.Tests_L1.Primitives.PrimitivesDataManager> _OnlineToPlainNoacAsync(global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain)
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

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            await base._PlainToOnlineNoacAsync(plain);
#pragma warning disable CS0612
            await this.Set._PlainToOnlineNoacAsync(plain.Set);
#pragma warning restore CS0612
            return await this.WriteAsync<IgnoreOnPocoOperation>(priority);
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain)
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

        public new async Task<global::Pocos.Tests_L1.Primitives.PrimitivesDataManager> ShadowToPlainAsync()
        {
            global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain = new global::Pocos.Tests_L1.Primitives.PrimitivesDataManager();
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.Tests_L1.Primitives.PrimitivesDataManager> ShadowToPlainAsync(global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain)
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
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.Tests_L1.Primitives.PrimitivesDataManager plain, global::Pocos.Tests_L1.Primitives.PrimitivesDataManager latest = null)
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

        public new global::Pocos.Tests_L1.Primitives.PrimitivesDataManager CreateEmptyPoco()
        {
            return new global::Pocos.Tests_L1.Primitives.PrimitivesDataManager();
        }
    }
}
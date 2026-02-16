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
    public partial class ExchangesWrappedInAxoObject : AXOpen.Core.AxoObject
    {
        public Tests_L1.SharedEntityHeaderManager Header { get; }
        public Tests_L1.StationDataManager Station_1 { get; }
        public Tests_L1.StationDataManager Station_2 { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public ExchangesWrappedInAxoObject(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Header = new Tests_L1.SharedEntityHeaderManager(this, "Header", "Header");
            Station_1 = new Tests_L1.StationDataManager(this, "Station_1", "Station_1");
            Station_2 = new Tests_L1.StationDataManager(this, "Station_2", "Station_2");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>(eAccessPriority priority = eAccessPriority.Normal)
        {
            return await (dynamic)this.OnlineToPlainAsync(priority);
        }

        public new async Task<global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject> OnlineToPlainAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain = new global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject();
            await this.ReadAsync<IgnoreOnPocoOperation>(priority);
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
        public new async Task<global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject> _OnlineToPlainNoacAsync()
        {
            global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain = new global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject();
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
        protected async Task<global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject> _OnlineToPlainNoacAsync(global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain)
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

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain, eAccessPriority priority = eAccessPriority.Normal)
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
            return await this.WriteAsync<IgnoreOnPocoOperation>(priority);
        }

        [Obsolete("This method should not be used if you indent to access the controllers data. Use `PlainToOnline` instead.")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        public async Task _PlainToOnlineNoacAsync(global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain)
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

        public new async Task<global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject> ShadowToPlainAsync()
        {
            global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain = new global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject();
            await base.ShadowToPlainAsync(plain);
            plain.Header = await Header.ShadowToPlainAsync();
            plain.Station_1 = await Station_1.ShadowToPlainAsync();
            plain.Station_2 = await Station_2.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject> ShadowToPlainAsync(global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain)
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

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain)
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
        public new async Task<bool> DetectsAnyChangeAsync(global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject plain, global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject latest = null)
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

        public new global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject CreateEmptyPoco()
        {
            return new global::Pocos.Tests_L1.Distributed.ExchangesWrappedInAxoObject();
        }
    }
}
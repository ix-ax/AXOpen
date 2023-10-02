using AXSharp.Connector.ValueTypes;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace axosimple
{
    public partial class SharedProductionData : AXOpen.Data.AxoDataEntity
    {
        public OnlinerInt ComesFrom { get; }

        public OnlinerInt GoesTo { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public SharedProductionData(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            ComesFrom = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "ComesFrom", "ComesFrom");
            GoesTo = @Connector.ConnectorAdapter.AdapterFactory.CreateINT(this, "GoesTo", "GoesTo");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<Pocos.axosimple.SharedProductionData> OnlineToPlainAsync()
        {
            Pocos.axosimple.SharedProductionData plain = new Pocos.axosimple.SharedProductionData();
            await this.ReadAsync();
            await base._OnlineToPlainNoacAsync(plain);
            plain.ComesFrom = ComesFrom.LastValue;
            plain.GoesTo = GoesTo.LastValue;
            return plain;
        }

        protected async Task<Pocos.axosimple.SharedProductionData> OnlineToPlainAsync(Pocos.axosimple.SharedProductionData plain)
        {
            await base._OnlineToPlainNoacAsync(plain);
            plain.ComesFrom = ComesFrom.LastValue;
            plain.GoesTo = GoesTo.LastValue;
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(Pocos.axosimple.SharedProductionData plain)
        {
            await base.PlainToOnlineAsync(plain);
            ComesFrom.Cyclic = plain.ComesFrom;
            GoesTo.Cyclic = plain.GoesTo;
            return await this.WriteAsync();
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<Pocos.axosimple.SharedProductionData> ShadowToPlainAsync()
        {
            Pocos.axosimple.SharedProductionData plain = new Pocos.axosimple.SharedProductionData();
            await base.ShadowToPlainAsync(plain);
            plain.ComesFrom = ComesFrom.Shadow;
            plain.GoesTo = GoesTo.Shadow;
            return plain;
        }

        protected async Task<Pocos.axosimple.SharedProductionData> ShadowToPlainAsync(Pocos.axosimple.SharedProductionData plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.ComesFrom = ComesFrom.Shadow;
            plain.GoesTo = GoesTo.Shadow;
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(Pocos.axosimple.SharedProductionData plain)
        {
            await base.PlainToShadowAsync(plain);
            ComesFrom.Shadow = plain.ComesFrom;
            GoesTo.Shadow = plain.GoesTo;
            return this.RetrievePrimitives();
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new Pocos.axosimple.SharedProductionData CreateEmptyPoco()
        {
            return new Pocos.axosimple.SharedProductionData();
        }
    }

    public partial class SharedProductionDataManager : AXOpen.Data.AxoDataExchange<axosimple.SharedProductionData, Pocos.axosimple.SharedProductionData>
    {
        [AXOpen.Data.AxoDataEntityAttribute]
        [Container(Layout.Stack)]
        public axosimple.SharedProductionData Set { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public SharedProductionDataManager(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Set = new axosimple.SharedProductionData(this, "Set", "Set");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<Pocos.axosimple.SharedProductionDataManager> OnlineToPlainAsync()
        {
            Pocos.axosimple.SharedProductionDataManager plain = new Pocos.axosimple.SharedProductionDataManager();
            await this.ReadAsync();
            await base._OnlineToPlainNoacAsync(plain);
            plain.Set = await Set.OnlineToPlainAsync();
            return plain;
        }

        protected async Task<Pocos.axosimple.SharedProductionDataManager> OnlineToPlainAsync(Pocos.axosimple.SharedProductionDataManager plain)
        {
            await base._OnlineToPlainNoacAsync(plain);
            plain.Set = await Set.OnlineToPlainAsync();
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(Pocos.axosimple.SharedProductionDataManager plain)
        {
            await base.PlainToOnlineAsync(plain);
            await this.Set.PlainToOnlineAsync(plain.Set);
            return await this.WriteAsync();
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<Pocos.axosimple.SharedProductionDataManager> ShadowToPlainAsync()
        {
            Pocos.axosimple.SharedProductionDataManager plain = new Pocos.axosimple.SharedProductionDataManager();
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<Pocos.axosimple.SharedProductionDataManager> ShadowToPlainAsync(Pocos.axosimple.SharedProductionDataManager plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(Pocos.axosimple.SharedProductionDataManager plain)
        {
            await base.PlainToShadowAsync(plain);
            await this.Set.PlainToShadowAsync(plain.Set);
            return this.RetrievePrimitives();
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new Pocos.axosimple.SharedProductionDataManager CreateEmptyPoco()
        {
            return new Pocos.axosimple.SharedProductionDataManager();
        }
    }
}

namespace Pocos
{
    namespace axosimple
    {
        public partial class SharedProductionData : AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
        {
            public Int16 ComesFrom { get; set; }

            public Int16 GoesTo { get; set; }
        }

        public partial class SharedProductionDataManager : AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
        {
            public axosimple.SharedProductionData Set { get; set; } = new axosimple.SharedProductionData();
        }
    }
}
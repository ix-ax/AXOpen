using AXSharp.Connector.ValueTypes;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace axosimple
{
    public partial class ProcessData : AXOpen.Data.AxoDataFragmentExchange
    {
        [AXOpen.Data.AxoDataFragmentAttribute] public axosimple.SharedProductionDataManager Set { get; }

        [AXOpen.Data.AxoDataFragmentAttribute]
        public examples.PneumaticManipulator.FragmentProcessDataManger Manip { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);

        public ProcessData(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent,
            readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Set = new axosimple.SharedProductionDataManager(this, "Set", "Set");
            Manip = new examples.PneumaticManipulator.FragmentProcessDataManger(this, "Manip", "Manip");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<Pocos.axosimple.ProcessData> OnlineToPlainAsync()
        {
            Pocos.axosimple.ProcessData plain = new Pocos.axosimple.ProcessData();
            await this.ReadAsync();
            await base.OnlineToPlainAsync(plain);
            plain.Set = await Set.OnlineToPlainAsync();
            plain.Manip = await Manip.OnlineToPlainAsync();
            return plain;
        }

        protected async Task<Pocos.axosimple.ProcessData> OnlineToPlainAsync(Pocos.axosimple.ProcessData plain)
        {
            await base.OnlineToPlainAsync(plain);
            plain.Set = await Set.OnlineToPlainAsync();
            plain.Manip = await Manip.OnlineToPlainAsync();
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(Pocos.axosimple.ProcessData plain)
        {
            await base.PlainToOnlineAsync(plain);
            await this.Set.PlainToOnlineAsync(plain.Set);
            await this.Manip.PlainToOnlineAsync(plain.Manip);
            return await this.WriteAsync();
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<Pocos.axosimple.ProcessData> ShadowToPlainAsync()
        {
            Pocos.axosimple.ProcessData plain = new Pocos.axosimple.ProcessData();
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            plain.Manip = await Manip.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<Pocos.axosimple.ProcessData> ShadowToPlainAsync(Pocos.axosimple.ProcessData plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            plain.Manip = await Manip.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(Pocos.axosimple.ProcessData plain)
        {
            await base.PlainToShadowAsync(plain);
            await this.Set.PlainToShadowAsync(plain.Set);
            await this.Manip.PlainToShadowAsync(plain.Manip);
            return this.RetrievePrimitives();
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new Pocos.axosimple.ProcessData CreateEmptyPoco()
        {
            return new Pocos.axosimple.ProcessData();
        }
    }
}

namespace Pocos.axosimple
{
    public partial class ProcessData : AXOpen.Data.AxoDataFragmentExchange, AXSharp.Connector.IPlain
    {
        public axosimple.SharedProductionDataManager Set { get; set; } = new axosimple.SharedProductionDataManager();
        public examples.PneumaticManipulator.FragmentProcessDataManger Manip { get; set; } = new examples.PneumaticManipulator.FragmentProcessDataManger();
    }
}

namespace examples.PneumaticManipulator
{
    public partial class FragmentProcessData : AXOpen.Data.AxoDataEntity
    {
        public OnlinerULInt CounterDelay { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public FragmentProcessData(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            CounterDelay = @Connector.ConnectorAdapter.AdapterFactory.CreateULINT(this, "CounterDelay", "CounterDelay");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<Pocos.examples.PneumaticManipulator.FragmentProcessData> OnlineToPlainAsync()
        {
            Pocos.examples.PneumaticManipulator.FragmentProcessData plain = new Pocos.examples.PneumaticManipulator.FragmentProcessData();
            await this.ReadAsync();
            await base.OnlineToPlainAsync(plain);
            plain.CounterDelay = CounterDelay.LastValue;
            return plain;
        }

        protected async Task<Pocos.examples.PneumaticManipulator.FragmentProcessData> OnlineToPlainAsync(Pocos.examples.PneumaticManipulator.FragmentProcessData plain)
        {
            await base.OnlineToPlainAsync(plain);
            plain.CounterDelay = CounterDelay.LastValue;
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(Pocos.examples.PneumaticManipulator.FragmentProcessData plain)
        {
            await base.PlainToOnlineAsync(plain);
            CounterDelay.Cyclic = plain.CounterDelay;
            return await this.WriteAsync();
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<Pocos.examples.PneumaticManipulator.FragmentProcessData> ShadowToPlainAsync()
        {
            Pocos.examples.PneumaticManipulator.FragmentProcessData plain = new Pocos.examples.PneumaticManipulator.FragmentProcessData();
            await base.ShadowToPlainAsync(plain);
            plain.CounterDelay = CounterDelay.Shadow;
            return plain;
        }

        protected async Task<Pocos.examples.PneumaticManipulator.FragmentProcessData> ShadowToPlainAsync(Pocos.examples.PneumaticManipulator.FragmentProcessData plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.CounterDelay = CounterDelay.Shadow;
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(Pocos.examples.PneumaticManipulator.FragmentProcessData plain)
        {
            await base.PlainToShadowAsync(plain);
            CounterDelay.Shadow = plain.CounterDelay;
            return this.RetrievePrimitives();
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new Pocos.examples.PneumaticManipulator.FragmentProcessData CreateEmptyPoco()
        {
            return new Pocos.examples.PneumaticManipulator.FragmentProcessData();
        }
    }

    public partial class FragmentProcessDataManger : AXOpen.Data.AxoDataExchange<examples.PneumaticManipulator.FragmentProcessData, Pocos.examples.PneumaticManipulator.FragmentProcessData>
    {
        [AXOpen.Data.AxoDataEntityAttribute]
        [Container(Layout.Stack)]
        public examples.PneumaticManipulator.FragmentProcessData Set { get; }

        partial void PreConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        partial void PostConstruct(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail);
        public FragmentProcessDataManger(AXSharp.Connector.ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
        {
            Symbol = AXSharp.Connector.Connector.CreateSymbol(parent.Symbol, symbolTail);
            PreConstruct(parent, readableTail, symbolTail);
            Set = new examples.PneumaticManipulator.FragmentProcessData(this, "Set", "Set");
            PostConstruct(parent, readableTail, symbolTail);
        }

        public async override Task<T> OnlineToPlain<T>()
        {
            return await (dynamic)this.OnlineToPlainAsync();
        }

        public new async Task<Pocos.examples.PneumaticManipulator.FragmentProcessDataManger> OnlineToPlainAsync()
        {
            Pocos.examples.PneumaticManipulator.FragmentProcessDataManger plain = new Pocos.examples.PneumaticManipulator.FragmentProcessDataManger();
            await this.ReadAsync();
            await base.OnlineToPlainAsync(plain);
            plain.Set = await Set.OnlineToPlainAsync();
            return plain;
        }

        protected async Task<Pocos.examples.PneumaticManipulator.FragmentProcessDataManger> OnlineToPlainAsync(Pocos.examples.PneumaticManipulator.FragmentProcessDataManger plain)
        {
            await base.OnlineToPlainAsync(plain);
            plain.Set = await Set.OnlineToPlainAsync();
            return plain;
        }

        public async override Task PlainToOnline<T>(T plain)
        {
            await this.PlainToOnlineAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToOnlineAsync(Pocos.examples.PneumaticManipulator.FragmentProcessDataManger plain)
        {
            await base.PlainToOnlineAsync(plain);
            await this.Set.PlainToOnlineAsync(plain.Set);
            return await this.WriteAsync();
        }

        public async override Task<T> ShadowToPlain<T>()
        {
            return await (dynamic)this.ShadowToPlainAsync();
        }

        public new async Task<Pocos.examples.PneumaticManipulator.FragmentProcessDataManger> ShadowToPlainAsync()
        {
            Pocos.examples.PneumaticManipulator.FragmentProcessDataManger plain = new Pocos.examples.PneumaticManipulator.FragmentProcessDataManger();
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        protected async Task<Pocos.examples.PneumaticManipulator.FragmentProcessDataManger> ShadowToPlainAsync(Pocos.examples.PneumaticManipulator.FragmentProcessDataManger plain)
        {
            await base.ShadowToPlainAsync(plain);
            plain.Set = await Set.ShadowToPlainAsync();
            return plain;
        }

        public async override Task PlainToShadow<T>(T plain)
        {
            await this.PlainToShadowAsync((dynamic)plain);
        }

        public async Task<IEnumerable<ITwinPrimitive>> PlainToShadowAsync(Pocos.examples.PneumaticManipulator.FragmentProcessDataManger plain)
        {
            await base.PlainToShadowAsync(plain);
            await this.Set.PlainToShadowAsync(plain.Set);
            return this.RetrievePrimitives();
        }

        public new void Poll()
        {
            this.RetrievePrimitives().ToList().ForEach(x => x.Poll());
        }

        public new Pocos.examples.PneumaticManipulator.FragmentProcessDataManger CreateEmptyPoco()
        {
            return new Pocos.examples.PneumaticManipulator.FragmentProcessDataManger();
        }
    }
}

namespace Pocos.examples.PneumaticManipulator
{
    public partial class FragmentProcessData : Pocos.AXOpen.Data.AxoDataEntity, AXSharp.Connector.IPlain
    {
        public UInt64 CounterDelay { get; set; }
    }

    public partial class FragmentProcessDataManger : Pocos.AXOpen.Data.AxoDataExchange, AXSharp.Connector.IPlain
    {
        public examples.PneumaticManipulator.FragmentProcessData Set { get; set; } = new examples.PneumaticManipulator.FragmentProcessData();
    }
}
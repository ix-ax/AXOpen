namespace Tests_L4
{
    using AXOpen.Data;
    using System;
    using System.Linq;
    using Xunit;
    using Pocos.FragmentExchange_Test_L4;
    using System.Collections.Frozen;
    using AXOpen.Data.Query;
    using AXOpen.Base.Data.Query;

    public abstract class OnlinerFragmentDataExchangeTests_Base
    {
        protected FragmentRepositoryFixture_Base Fixture { get; set; }

        protected FragmentExchange_Test_L4.FragmentProcessDataManager FramgentManager
        { get; set; }

        protected IAxoDataExchange Exchange { get; set; }

        [Fact]
        public void ContainsInitialRecords()
        {
            Assert.Equal(10, Exchange.GetRecords("").Count());
        }

        [Fact]
        public void ContainsInitialRecords_fragmentQuery()
        {
            Assert.Equal(10, Exchange.Repository.FilteredCount(new PredicateContainer()));
        }

        [Fact]
        public void should_return_entities_from_framgents()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<HeaderData>(p => (p.vInt > 3 && p.vInt <= 8));
            pc.AddPredicates<StationData>(p => (p.vInt > 5 && p.vInt <= 7));


            var headerProdicates = pc.GetPredicates<HeaderData>();
            var stationProdicates = pc.GetPredicates<StationData>();

            IEnumerable<string> resultHeader = Fixture.RepositoryHeader.GetEntityIds(pc);
            IEnumerable<string> resultStation = Fixture.RepositoryStation.GetEntityIds(pc);

            var result = Exchange.GetRecords(pc, 1000, 0).ToList();

            Assert.Equal(2, result.Count());

            Assert.Equal("7", result[0]._EntityId);
            Assert.Equal("6", result[1]._EntityId);
        }

        [Fact]
        public void should_return_entities_from_framgents_string()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<HeaderData>(p => (p.vString.Contains("odd 4")));
            pc.AddPredicates<HeaderData>(p => (p.vInt == 4));
            pc.AddPredicates<StationData>(p => (p.vInt == 4));

            var result = Exchange.GetRecords(pc, 1000, 0).ToList();

            Assert.Equal(1, result.Count());

            Assert.Equal("4", result[0]._EntityId);
        }

        [Fact]
        public void should_return_entities_count_framgents_query()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<HeaderData>(p => (p.vString.Contains("odd")));
            pc.AddPredicates<StationData>(p => (p.vInt >= 4) && (p.vInt <= 8));

            var result = Exchange.GetRecords(pc, 100, 0).ToList();

            Assert.Equal(3, result.Count);
            Assert.Equal(3, Exchange.LastFragmentQueryCount);
        }

        [Fact]
        public void should_create_symbol_list()
        {
            var plains = Exchange.GetPlainTypes();

            var plainBuilder_Header  = new PlainSymbolBuilder(plains.First());
            var plainBuilder_Station = new PlainSymbolBuilder(plains.Last());

            var result = plainBuilder_Header.GetSymbols()
                            .Concat(plainBuilder_Station.GetSymbols())
                            .ToList();

            Assert.Equal(15, result.Count);

            // HeaderData members
            Assert.Equal("HeaderData.vString",   result[0]);
            Assert.Equal("HeaderData.vInt",      result[1]);
            Assert.Equal("HeaderData.vBool",     result[2]);
            Assert.Equal("HeaderData.ModifiedAt",result[3]);
            Assert.Equal("HeaderData.CreatedAt", result[4]);
            Assert.Equal("HeaderData._EntityId", result[5]);

            // StationData members
            Assert.Equal("StationData.vString",         result[6]);
            Assert.Equal("StationData.vInt",            result[7]);
            Assert.Equal("StationData.vBool",           result[8]);
            Assert.Equal("StationData.NestObj.vString", result[9]);
            Assert.Equal("StationData.NestObj.vInt",    result[10]);
            Assert.Equal("StationData.NestObj.vBool",   result[11]);
            Assert.Equal("StationData.ModifiedAt",      result[12]);
            Assert.Equal("StationData.CreatedAt",       result[13]);
            Assert.Equal("StationData._EntityId",       result[14]);
        }

        [Fact]
        public void should_build_lambda_from_symbol()
        {
            var plains = Exchange.GetPlainTypes();

            Type plainTypeHeader = plains.First();
            Type plainTypeStation = plains.Last();

            string varNameHeader = "vString";
            Type requiredSymbolTypeHeader = typeof(string);

            string varNameStation = "NestObj.vString";
            Type requiredSymbolTypeStation = typeof(string);

            string requiredSymbolNameHeader = $"{plainTypeHeader.Name}.{varNameHeader}";
            string requiredSymbolNameStation = $"{plainTypeStation.Name}.{varNameStation}";

            var plainSymbolBuilder_header = new PlainSymbolBuilder(plainTypeHeader);
            var plainSymbolBuilder_station = new PlainSymbolBuilder(plainTypeStation);

            List<string> symbols = new();

            symbols.AddRange(plainSymbolBuilder_header.GetSymbols());
            symbols.AddRange(plainSymbolBuilder_station.GetSymbols());

            Assert.Equal(15, symbols.Count());

            var acquiredSymbolHeader = plainSymbolBuilder_header.GetSymbols().Where(p => p == requiredSymbolNameHeader).First(); //SharedHeader.vString"
            var acquiredSymbolStation = plainSymbolBuilder_station.GetSymbols().Where(p => p == requiredSymbolNameStation).First(); //SharedHeader.vString"

            Assert.Equal(requiredSymbolNameHeader, acquiredSymbolHeader);
            Assert.Equal(requiredSymbolNameStation, acquiredSymbolStation);

            var acquiredSymbolTypeHeader = plainSymbolBuilder_header.GetSymbolType(acquiredSymbolHeader);
            var acquiredSymbolTypeStation = plainSymbolBuilder_station.GetSymbolType(acquiredSymbolStation);

            Assert.Equal(requiredSymbolTypeHeader.FullName, acquiredSymbolTypeHeader.FullName);
            Assert.Equal(requiredSymbolTypeStation.FullName, acquiredSymbolTypeStation.FullName);

            var pc = new PredicateContainer();
            var lambdaHeader = PredicateBuilder.BuildLambdaPredicate(plainSymbolBuilder_header.RootType, varNameHeader, "Contains", "odd", "");
            var lambdaStation = PredicateBuilder.BuildLambdaPredicate(plainSymbolBuilder_station.RootType, varNameHeader, "EndsWith", "2", "");

            pc.AddPredicates(plainSymbolBuilder_header.RootType, lambdaHeader);
            pc.AddPredicates(plainSymbolBuilder_station.RootType, lambdaStation);

            var records = Exchange.GetRecords(pc, 100, 0);

            Assert.Equal(1, records.Count());
        }
    }
}
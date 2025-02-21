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

    [Collection("DatabaseTests")]
    public class OnlinerFragmentDataExchange_MongoTests : IClassFixture<MultipleRepository_MongoFixture>
    {
        private readonly MultipleRepository_MongoFixture _fixture;
        private FragmentExchange_Test_L4.FragmentProcessDataManager _FramgentManager;

        private IAxoDataExchange _exchange;

        public OnlinerFragmentDataExchange_MongoTests(MultipleRepository_MongoFixture fixture)
        {
            _fixture = fixture;

            _FramgentManager = axopen_integration_tests_l4.Entry.Plc.FragmentsExchangeContext_Test_L4.DataManager;

            _FramgentManager.CreateDataFragments<FragmentExchange_Test_L4.FragmentProcessDataManager>();

            _FramgentManager.Header.SetRepository(_fixture._headerRepository);
            _FramgentManager.St1.SetRepository(_fixture._stationRepository);

            _exchange = _FramgentManager;
        }

        [Fact]
        public void ContainsInitialRecords()
        {
            Assert.Equal(10, _exchange.GetRecords("").Count());
        }

        [Fact]
        public void ContainsInitialRecords_fragmentQuery()
        {
            Assert.Equal(10, _exchange.Repository.FilteredCount(new PredicateContainer()));
        }

        [Fact]
        public void should_return_entities_from_framgents()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<HeaderData>(p => (p.vInt > 3 && p.vInt <= 8));
            pc.AddPredicates<StationData>(p => (p.vInt > 5 && p.vInt <= 7));

            var headerProdicates = pc.GetPredicates<HeaderData>();
            var stationProdicates = pc.GetPredicates<StationData>();

            IEnumerable<string> resultHeader = _fixture._headerRepository.GetEntityIds(pc);
            IEnumerable<string> resultStation = _fixture._stationRepository.GetEntityIds(pc);

            var result = _exchange.GetRecords(pc, 1000, 0).ToList();

            Assert.Equal(2, result.Count());

            Assert.Equal("6", result[0].DataEntityId);
            Assert.Equal("7", result[1].DataEntityId);
        }

        [Fact]
        public void should_return_entities_from_framgents_string()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<HeaderData>(p => (p.vString.Contains("odd 4")));
            pc.AddPredicates<HeaderData>(p => (p.vInt == 4));
            pc.AddPredicates<StationData>(p => (p.vInt == 4));

            var result = _exchange.GetRecords(pc, 1000, 0).ToList();

            Assert.Equal(1, result.Count());

            Assert.Equal("4", result[0].DataEntityId);
        }

        [Fact]
        public void should_return_entities_count_framgents_query()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<HeaderData>(p => (p.vString.Contains("odd")));
            pc.AddPredicates<StationData>(p => (p.vInt >= 4) && (p.vInt <= 8));

            var result = _exchange.GetRecords(pc,100, 0).ToList();

            Assert.Equal(3, result.Count);
            Assert.Equal(3, _exchange.LastFragmentQueryCount);
        }

        [Fact]
        public void should_create_symbol_list()
        {
            var plains = _exchange.GetPlainObjectType();

            var plainBuilder_Header = new PlainSymbolBuilder(plains.First());
            var plainBuilder_Station = new PlainSymbolBuilder(plains.Last());

            var result_header = plainBuilder_Header.GetSymbols().ToList();
            var result_Station = plainBuilder_Station.GetSymbols().ToList();

            List<string> result = new();

            foreach (var symbol in result_header)
            {
                result.Add(symbol);
            }

            foreach (var symbol in result_Station)
            {
                result.Add(symbol);
            }

            Assert.Equal(11, result.Count());

            Assert.Equal("HeaderData.vString", result[0]);
            Assert.Equal("HeaderData.vInt", result[1]);
            Assert.Equal("HeaderData.vBool", result[2]);
            Assert.Equal("HeaderData.DataEntityId", result[3]);
            Assert.Equal("StationData.vString", result[4]);
            Assert.Equal("StationData.vInt", result[5]);
            Assert.Equal("StationData.vBool", result[6]);
            Assert.Equal("StationData.NestObj.vString", result[7]);
            Assert.Equal("StationData.NestObj.vInt", result[8]);
            Assert.Equal("StationData.NestObj.vBool", result[9]);
            Assert.Equal("StationData.DataEntityId", result[10]);
        }

        [Fact]
        public void should_build_lambda_from_symbol()
        {
            var plains = _exchange.GetPlainObjectType();

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

            Assert.Equal(11, symbols.Count());

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

            var records = _exchange.GetRecords(pc, 100, 0);

            Assert.Equal(1, records.Count());
        }
    }
}
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
            Assert.Equal("vString",   result[0]);
            Assert.Equal("vInt",      result[1]);
            Assert.Equal("vBool",     result[2]);
            Assert.Equal("ModifiedAt",result[3]);
            Assert.Equal("CreatedAt", result[4]);
            Assert.Equal("_EntityId", result[5]);

            // StationData members
            Assert.Equal("vString",         result[6]);
            Assert.Equal("vInt",            result[7]);
            Assert.Equal("vBool",           result[8]);
            Assert.Equal("NestObj.vString", result[9]);
            Assert.Equal("NestObj.vInt",    result[10]);
            Assert.Equal("NestObj.vBool",   result[11]);
            Assert.Equal("ModifiedAt",      result[12]);
            Assert.Equal("CreatedAt",       result[13]);
            Assert.Equal("_EntityId",       result[14]);
        }

        [Fact]
        public void should_build_lambda_from_symbols()
        {
            var plains = Exchange.GetPlainTypes();

            string varNameHeader = "vString";
            Type requiredSymbolTypeHeader = typeof(string);

            string varNameStation = "NestObj.vString";
            Type requiredSymbolTypeStation = typeof(string);

            var builderHeader = new PlainSymbolBuilder(plains.First()); // header
            var builderStation = new PlainSymbolBuilder(plains.Last()); // station

            Assert.Equal(typeof(Pocos.FragmentExchange_Test_L4.HeaderData).FullName, builderHeader.RootTypeName);
            Assert.Equal(typeof(Pocos.FragmentExchange_Test_L4.StationData).FullName, builderStation.RootTypeName);

            var pc = new PredicateContainer();
            var lambdaHeader = PredicateBuilder.BuildLambdaPredicate(builderHeader.RootType, varNameHeader, "Contains", "even", "");
            var lambdaStation = PredicateBuilder.BuildLambdaPredicate(builderStation.RootType, varNameStation, "EndsWith", "2", "");

            pc.AddPredicates(builderHeader.RootType, lambdaHeader);
            pc.AddPredicates(builderStation.RootType, lambdaStation);

            var records = Exchange.GetRecords(pc, 100, 0);

            Assert.Equal(1, records.Count());
        }
    }
}
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
        public void should_contain_initial_records()
        {
            Assert.Equal(10, Exchange.GetRecords("").Count());
        }

        [Fact]
        public void should_contain_initial_records_fragment_query()
        {
            Assert.Equal(10, Exchange.Repository.FilteredCount(new PredicateContainer()));
        }

        [Fact]
        public void should_return_entities_from_fragments()
        {
            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates<HeaderData>(p => (p.vInt > 3 && p.vInt <= 8));
            predicateContainer.AddPredicates<StationData>(p => (p.vInt > 5 && p.vInt <= 7));

            var headerPredicates = predicateContainer.GetPredicates<HeaderData>();
            var stationPredicates = predicateContainer.GetPredicates<StationData>();

            IEnumerable<string> headerEntityIds = Fixture.RepositoryHeader.GetEntityIds(predicateContainer);
            IEnumerable<string> stationEntityIds = Fixture.RepositoryStation.GetEntityIds(predicateContainer);

            var records = Exchange.GetRecords(predicateContainer, 1000, 0).ToList();

            Assert.Equal(2, records.Count());

            Assert.Equal("7", records[0]._EntityId);
            Assert.Equal("6", records[1]._EntityId);
        }

        [Fact]
        public void should_return_entities_from_fragments_string()
        {
            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates<HeaderData>(p => (p.vString.Contains("odd 4")));
            predicateContainer.AddPredicates<HeaderData>(p => (p.vInt == 4));
            predicateContainer.AddPredicates<StationData>(p => (p.vInt == 4));

            var records = Exchange.GetRecords(predicateContainer, 1000, 0).ToList();

            Assert.Equal(1, records.Count());

            Assert.Equal("4", records[0]._EntityId);
        }

        [Fact]
        public void should_return_entities_count_fragments_query()
        {
            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates<HeaderData>(p => (p.vString.Contains("odd")));
            predicateContainer.AddPredicates<StationData>(p => (p.vInt >= 4) && (p.vInt <= 8));

            var records = Exchange.GetRecords(predicateContainer, 100, 0).ToList();

            Assert.Equal(3, records.Count);
            Assert.Equal(3, Exchange.LastFragmentQueryCount);
        }

        [Fact]
        public void should_create_symbol_list()
        {
            var plainTypes = Exchange.GetPlainTypes();

            var headerPlainSymbolBuilder  = new PlainSymbolBuilder(plainTypes.First());
            var stationPlainSymbolBuilder = new PlainSymbolBuilder(plainTypes.Last());

            var symbolPaths = headerPlainSymbolBuilder.GetSymbolPaths()
                                .Concat(stationPlainSymbolBuilder.GetSymbolPaths())
                                .ToList();

            Assert.Equal(15, symbolPaths.Count);

            // HeaderData members
            Assert.Equal("vString",   symbolPaths[0]);
            Assert.Equal("vInt",      symbolPaths[1]);
            Assert.Equal("vBool",     symbolPaths[2]);
            Assert.Equal("ModifiedAt",symbolPaths[3]);
            Assert.Equal("CreatedAt", symbolPaths[4]);
            Assert.Equal("_EntityId", symbolPaths[5]);

            // StationData members
            Assert.Equal("vString",         symbolPaths[6]);
            Assert.Equal("vInt",            symbolPaths[7]);
            Assert.Equal("vBool",           symbolPaths[8]);
            Assert.Equal("NestObj.vString", symbolPaths[9]);
            Assert.Equal("NestObj.vInt",    symbolPaths[10]);
            Assert.Equal("NestObj.vBool",   symbolPaths[11]);
            Assert.Equal("ModifiedAt",      symbolPaths[12]);
            Assert.Equal("CreatedAt",       symbolPaths[13]);
            Assert.Equal("_EntityId",       symbolPaths[14]);
        }

        [Fact]
        public void should_build_lambda_from_symbols()
        {
            var plainTypes = Exchange.GetPlainTypes();

            string headerSymbolPath = "vString";

            string stationSymbolPath = "NestObj.vString";

            var headerPlainSymbolBuilder = new PlainSymbolBuilder(plainTypes.First()); // header
            var stationPlainSymbolBuilder = new PlainSymbolBuilder(plainTypes.Last()); // station

            Assert.Equal(typeof(Pocos.FragmentExchange_Test_L4.HeaderData).FullName, headerPlainSymbolBuilder.RootTypeName);
            Assert.Equal(typeof(Pocos.FragmentExchange_Test_L4.StationData).FullName, stationPlainSymbolBuilder.RootTypeName);

            var predicateContainer = new PredicateContainer();
            var headerLambda = PredicateBuilder.BuildLambdaPredicate(headerPlainSymbolBuilder.RootType, headerSymbolPath, "Contains", "even", "");
            var stationLambda = PredicateBuilder.BuildLambdaPredicate(stationPlainSymbolBuilder.RootType, stationSymbolPath, "EndsWith", "2", "");

            predicateContainer.AddPredicates(headerPlainSymbolBuilder.RootType, headerLambda);
            predicateContainer.AddPredicates(stationPlainSymbolBuilder.RootType, stationLambda);

            var records = Exchange.GetRecords(predicateContainer, 100, 0);

            Assert.Equal(1, records.Count());
        }
    }
}

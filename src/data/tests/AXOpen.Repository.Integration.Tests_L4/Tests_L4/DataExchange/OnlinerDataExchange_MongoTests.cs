namespace Tests_L4
{
    using AXOpen.Base.Data.Query;
    using AXOpen.Data;
    using AXOpen.Data.Query;
    using Exchange_Test_L4;
    using Polly;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    using PredicateBuilder = AXOpen.Data.Query.PredicateBuilder;

    [Collection("DatabaseTests")]
    public class OnlinerDataExchange_MongoTests : IClassFixture<SingleRepository_MongoFixture>
    {
        private readonly SingleRepository_MongoFixture _fixture;

        private AxoDataExchange<ProcessData, Pocos.Exchange_Test_L4.ProcessData> _processExchange;
        private IAxoDataExchange _exchange;

        public OnlinerDataExchange_MongoTests(SingleRepository_MongoFixture fixture)
        {
            _fixture = fixture;

            // initialize exchange
            _processExchange = axopen_integration_tests_l4.Entry.Plc.ExchangeContext_Test_L4.DataManager;
            _processExchange.SetRepository(_fixture._repository);

            _exchange = _processExchange;
        }

        [Fact]
        public void ContainsRecords()
        {
            Assert.Equal(_fixture._repository.Count, 10);
        }

        [Fact]
        public void ContainsInitialRecords_fragmentQuery()
        {
            Assert.Equal(10, _exchange.Repository.FilteredCount(new PredicateContainer()));
        }

        [Fact]
        public void should_return_entities()
        {
            IEnumerable<Expression<Func<Pocos.Exchange_Test_L4.ProcessData, bool>>> predicates = new List<Expression<Func<Pocos.Exchange_Test_L4.ProcessData, bool>>>
                {
                    p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)),
                    p => (p.vBool == true),
                };

            var c = new PredicateContainer();

            c.AddPredicates<Pocos.Exchange_Test_L4.ProcessData>(predicates);

            var result = _exchange.GetRecords(c, 100, 0);

            Assert.Equal(3, result.Count());
        }

        [Fact]
        public void should_create_symbol_list()
        {
            var plains = _exchange.GetPlainObjectType();

            var plainSymbolBuilder = new PlainSymbolBuilder(plains.First());

            var result = plainSymbolBuilder.GetSymbols();

            Assert.Equal(7, result.Count());

            Assert.Equal("ProcessData.vString", result[0]);
            Assert.Equal("ProcessData.vInt", result[1]);
            Assert.Equal("ProcessData.vBool", result[2]);
            Assert.Equal("ProcessData.NestObj.vString", result[3]);
            Assert.Equal("ProcessData.NestObj.vInt", result[4]);
            Assert.Equal("ProcessData.NestObj.vBool", result[5]);
            Assert.Equal("ProcessData.DataEntityId", result[6]);
        }

        [Fact]
        public void should_build_lambda_from_symbol()
        {
            var plains = _exchange.GetPlainObjectType();

            string requiredSymbolName = "ProcessData.vString";
            Type requiredSymbolType = typeof(string);

            var plainSymbolBuilder = new PlainSymbolBuilder(plains.First());

            var allSymbols = plainSymbolBuilder.GetSymbols();

            Assert.Equal(7, allSymbols.Count());

            var result = plainSymbolBuilder.GetSymbols().Where(p => p == requiredSymbolName).First(); //SharedHeader.vString"

            Assert.Equal(requiredSymbolName, result);

            var acquiredSymbolType = plainSymbolBuilder.GetSymbolType(result);

            Assert.Equal(requiredSymbolType.FullName, acquiredSymbolType.FullName);

            var lambda = PredicateBuilder.BuildLambdaPredicate(plainSymbolBuilder.RootType, "vString", "==", "odd 2", "");

            var c = new PredicateContainer();

            c.AddPredicates(plainSymbolBuilder.RootType, lambda);

            var records = _exchange.GetRecords(c, 100, 0);

            Assert.Equal(1, records.Count());
        }

        [Fact]
        public void should_build_lambda_from_query_symbol_with_range()
        {
            var plains = _exchange.GetPlainObjectType();

            string requiredSymbolName = "ProcessData.vInt";
            Type requiredSymbolType = typeof(Int16);

            var plainSymbolBuilder = new PlainSymbolBuilder(plains.First());

            var allSymbols = plainSymbolBuilder.GetSymbols();

            Assert.Equal(7, allSymbols.Count());

            var result = plainSymbolBuilder.GetSymbols().Where(p => p == requiredSymbolName).First(); //SharedHeader.vString"

            Assert.Equal(requiredSymbolName, result);

            var acquiredSymbolType = plainSymbolBuilder.GetSymbolType(result);

            Assert.Equal(requiredSymbolType.FullName, acquiredSymbolType.FullName);

            var range = OperationProvider.GetRangeForType(acquiredSymbolType);

            var operations = OperationProvider.GetOperationsForType(acquiredSymbolType);

            Assert.NotNull(range);

            Assert.Equal(8, operations.Count);

            var myrange = ((Int16)5, (Int16)8);
            var myOperation = operations.Where(o => o == "InRange").First();

            var lambda = PredicateBuilder.BuildLambdaPredicate(plainSymbolBuilder.RootType, "vInt", myOperation, myrange.Item1, myrange.Item2);

            var c = new PredicateContainer();

            c.AddPredicates(plainSymbolBuilder.RootType, lambda);

            var records = _exchange.GetRecords(c, 100, 0);

            Assert.Equal(4, records.Count());
        }

        [Fact]
        public void should_build_lambda_from_query_symbol()
        {
            var plainBuilders = _exchange.GetPlainObjectType().Select(p => new PlainSymbolBuilder(p)).ToList();

            var plainTypeHeaderName = plainBuilders.First().RootTypeName;

            string varNameHeader = "vString";
            string varValueMinHeader = "3";
            string varValueMaxHeader = "";
            string varOperationHeader = "Contains";

            Type requiredSymbolTypeHeader = typeof(string);

            string RequiredSymbolPathWithParent = $"{plainTypeHeaderName}.{varNameHeader}";

            var config = new QuerySymbolConfiguration(
                RequiredSymbolPathWithParent,
                requiredSymbolTypeHeader.FullName,
                varOperationHeader,
                varValueMinHeader,
                varValueMaxHeader);

            // check right set up
            Assert.Equal(RequiredSymbolPathWithParent, config.SymbolPathWithParent);
            Assert.Equal(plainTypeHeaderName, config.ParentTypeName);
            Assert.Equal(varNameHeader, config.Symbol);

            var pc = new PredicateContainer().AddQuerySymbolToPredicates(plainBuilders, config);

            var records = _exchange.GetRecords(pc, 100, 0);

            Assert.Equal(1, records.Count());
        }

        [Fact]
        public void should_build_create_query_symbol()
        {
            var plainBuilders = _exchange.GetPlainObjectType().Select(p => new PlainSymbolBuilder(p)).ToList();

            var plainTypeHeaderName = plainBuilders.First().RootTypeName;

            string varNameHeader = "vString";
            string varValueMinHeader = "3";
            string varOperationHeader = "Contains";

            Type requiredSymbolTypeHeader = typeof(string);

            string RequiredSymbolPathWithParent = $"{plainTypeHeaderName}.{varNameHeader}";

            var config = plainBuilders.CreateNewQuerySymbol(RequiredSymbolPathWithParent);

            config.MinOrValue = varValueMinHeader;
            config.Operation = varOperationHeader;

            // check right set up
            Assert.Equal(RequiredSymbolPathWithParent, config.SymbolPathWithParent);
            Assert.Equal(plainTypeHeaderName, config.ParentTypeName);
            Assert.Equal(varNameHeader, config.Symbol);

            var pc = new PredicateContainer().AddQuerySymbolToPredicates(plainBuilders, config);

            var records = _exchange.GetRecords(pc, 100, 0);

            Assert.Equal(1, records.Count());
        }

        [Fact]
        public void should_build_filter_and_sort_accesing()
        {
            var plains = _exchange.GetPlainObjectType();

            var plainBuilders = plains.Select(p => new PlainSymbolBuilder(p)).ToList();

            var plainTypeHeaderName = plainBuilders.First().RootTypeName;

            string RequiredSymbolPathWithParent = $"{plainTypeHeaderName}.{Constants.MEMBER_NAME_ENTITY_ID}";

            var config = plainBuilders.CreateNewQuerySymbol(RequiredSymbolPathWithParent);

            config.MinOrValue = "";
            config.Operation = "!="; // not empty

            var pc = new PredicateContainer().AddQuerySymbolToPredicates(plainBuilders, config);

            SortSettings sortSettings = new SortSettings() { IsAscending = true };

            pc.AddSortMember(sortSettings, plains.First());

            var records = _exchange.GetRecords(pc, 100, 0).ToList();

            Assert.Equal(10, records.Count());

            Assert.Equal("0", records[0].DataEntityId);
            Assert.Equal("1", records[1].DataEntityId);
            Assert.Equal("2", records[2].DataEntityId);
            Assert.Equal("3", records[3].DataEntityId);
            Assert.Equal("4", records[4].DataEntityId);
            Assert.Equal("5", records[5].DataEntityId);
            Assert.Equal("6", records[6].DataEntityId);
            Assert.Equal("7", records[7].DataEntityId);
            Assert.Equal("8", records[8].DataEntityId);
            Assert.Equal("9", records[9].DataEntityId);
        }

        [Fact]
        public void should_build_filter_and_sort_descesing()
        {
            var plains = _exchange.GetPlainObjectType();

            var plainBuilders = plains.Select(p => new PlainSymbolBuilder(p)).ToList();

            var plainTypeHeaderName = plainBuilders.First().RootTypeName;

            string RequiredSymbolPathWithParent = $"{plainTypeHeaderName}.{Constants.MEMBER_NAME_ENTITY_ID}";

            var config = plainBuilders.CreateNewQuerySymbol(RequiredSymbolPathWithParent);

            config.MinOrValue = "";
            config.Operation = "!="; // not empty

            var pc = new PredicateContainer().AddQuerySymbolToPredicates(plainBuilders, config);

            SortSettings sortSettings = new SortSettings() { IsAscending = false };

            pc.AddSortMember(sortSettings, plains.First());

            var records = _exchange.GetRecords(pc, 100, 0).ToList();

            Assert.Equal(10, records.Count());

            Assert.Equal("9", records[0].DataEntityId);
            Assert.Equal("8", records[1].DataEntityId);
            Assert.Equal("7", records[2].DataEntityId);
            Assert.Equal("6", records[3].DataEntityId);
            Assert.Equal("5", records[4].DataEntityId);
            Assert.Equal("4", records[5].DataEntityId);
            Assert.Equal("3", records[6].DataEntityId);
            Assert.Equal("2", records[7].DataEntityId);
            Assert.Equal("1", records[8].DataEntityId);
            Assert.Equal("0", records[9].DataEntityId);
        }

        [Fact]
        public void should_build_filter_and_sort_from_sortsymbolConfiguraion()
        {
            var plains = _exchange.GetPlainObjectType();

            var plainBuilders = plains.Select(p => new PlainSymbolBuilder(p)).ToList();

            var plainTypeHeaderName = plainBuilders.First().RootTypeName;

            string RequiredSymbolPathWithParent = $"{plainTypeHeaderName}.{Constants.MEMBER_NAME_ENTITY_ID}";

            QuerySymbolConfiguration querySymbol = plainBuilders.CreateNewQuerySymbol(RequiredSymbolPathWithParent);

            querySymbol.MinOrValue = "";
            querySymbol.Operation = "!="; // not empty

            SortSymbolConfiguration sortSymbol = new SortSymbolConfiguration(RequiredSymbolPathWithParent, typeof(string).FullName, false);

            var pc = new PredicateContainer();

            pc.AddQuerySymbolToPredicates(plainBuilders, querySymbol);

            pc.AddSortSymbolToPredicates(plainBuilders, sortSymbol);

            var records = _exchange.GetRecords(pc, 100, 0).ToList();

            Assert.Equal(10, records.Count());

            Assert.Equal("9", records[0].DataEntityId);
            Assert.Equal("8", records[1].DataEntityId);
            Assert.Equal("7", records[2].DataEntityId);
            Assert.Equal("6", records[3].DataEntityId);
            Assert.Equal("5", records[4].DataEntityId);
            Assert.Equal("4", records[5].DataEntityId);
            Assert.Equal("3", records[6].DataEntityId);
            Assert.Equal("2", records[7].DataEntityId);
            Assert.Equal("1", records[8].DataEntityId);
            Assert.Equal("0", records[9].DataEntityId);
        }
        
    }
}
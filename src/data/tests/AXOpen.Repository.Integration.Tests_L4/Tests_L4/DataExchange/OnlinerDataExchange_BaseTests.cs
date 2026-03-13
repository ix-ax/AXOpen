namespace Tests_L4
{
    using AXOpen.Base.Data.Query;
    using AXOpen.Data;
    using AXOpen.Data.Query;
    using Exchange_Test_L4;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    using PredicateBuilder = AXOpen.Data.Query.PredicateBuilder;

    public abstract class OnlinerDataExchange_BaseTests
    {
        protected SingleRepositoryFixture_Base Fixture { get; set; }

        protected AxoDataExchange<ProcessData, Pocos.Exchange_Test_L4.ProcessData> ProcessExchange { get; set; }

        protected IAxoDataExchange Exchange { get; set; }

        [Fact]
        public void should_contain_records()
        {
            Assert.Equal(Fixture.Repository.Count, 10);
        }

        [Fact]
        public void should_contain_initial_records_fragment_query()
        {
            Assert.Equal(10, Exchange.Repository.FilteredCount(new PredicateContainer()));
        }

        [Fact]
        public void should_return_entities()
        {
            IEnumerable<Expression<Func<Pocos.Exchange_Test_L4.ProcessData, bool>>> predicates = new List<Expression<Func<Pocos.Exchange_Test_L4.ProcessData, bool>>>
                {
                    p => (p.vInt > 2 && (p.Primitives.vINT > 3 && p.Primitives.vINT <= 8)),
                    p => (p.vBool == true),
                };

            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates<Pocos.Exchange_Test_L4.ProcessData>(predicates);

            var records = Exchange.GetRecords(predicateContainer, 100, 0);

            Assert.Equal(3, records.Count());
        }

        [Fact]
        public void should_create_symbol_list()
        {
            var plainTypes = Exchange.GetPlainTypes();
            var plainSymbolBuilder = new PlainSymbolBuilder(plainTypes.First());
            var plainSymbolPaths = plainSymbolBuilder.GetSymbolPaths();

            Assert.Equal(33, plainSymbolPaths.Count());

            // ProcessData top-level members
            Assert.Equal("vString",                    plainSymbolPaths[0]);
            Assert.Equal("vInt",                       plainSymbolPaths[1]);
            Assert.Equal("vBool",                      plainSymbolPaths[2]);

            // ProcessData.Primitives nested members
            Assert.Equal("Primitives.vBOOL",           plainSymbolPaths[3]);
            Assert.Equal("Primitives.vBYTE",           plainSymbolPaths[4]);
            Assert.Equal("Primitives.vWORD",           plainSymbolPaths[5]);
            Assert.Equal("Primitives.vDWORD",          plainSymbolPaths[6]);
            Assert.Equal("Primitives.vLWORD",          plainSymbolPaths[7]);
            Assert.Equal("Primitives.vSINT",           plainSymbolPaths[8]);
            Assert.Equal("Primitives.vINT",            plainSymbolPaths[9]);
            Assert.Equal("Primitives.vDINT",           plainSymbolPaths[10]);
            Assert.Equal("Primitives.vLINT",           plainSymbolPaths[11]);
            Assert.Equal("Primitives.vUSINT",          plainSymbolPaths[12]);
            Assert.Equal("Primitives.vUINT",           plainSymbolPaths[13]);
            Assert.Equal("Primitives.vUDINT",          plainSymbolPaths[14]);
            Assert.Equal("Primitives.vULINT",          plainSymbolPaths[15]);
            Assert.Equal("Primitives.vREAL",           plainSymbolPaths[16]);
            Assert.Equal("Primitives.vLREAL",          plainSymbolPaths[17]);
            Assert.Equal("Primitives.vTIME",           plainSymbolPaths[18]);
            Assert.Equal("Primitives.vLTIME",          plainSymbolPaths[19]);
            Assert.Equal("Primitives.vDATE",           plainSymbolPaths[20]);
            Assert.Equal("Primitives.vLDATE",          plainSymbolPaths[21]);
            Assert.Equal("Primitives.vTIME_OF_DAY",    plainSymbolPaths[22]);
            Assert.Equal("Primitives.vLTIME_OF_DAY",   plainSymbolPaths[23]);
            Assert.Equal("Primitives.vDATE_AND_TIME",  plainSymbolPaths[24]);
            Assert.Equal("Primitives.vLDATE_AND_TIME", plainSymbolPaths[25]);
            Assert.Equal("Primitives.vCHAR",           plainSymbolPaths[26]);
            Assert.Equal("Primitives.vWCHAR",          plainSymbolPaths[27]);
            Assert.Equal("Primitives.vSTRING",         plainSymbolPaths[28]);
            Assert.Equal("Primitives.vWSTRING",        plainSymbolPaths[29]);

            // Inherited AxoDataEntity members
            Assert.Equal("ModifiedAt",                 plainSymbolPaths[30]);
            Assert.Equal("CreatedAt",                  plainSymbolPaths[31]);
            Assert.Equal("_EntityId",                  plainSymbolPaths[32]);
        }

        [Fact]
        public void should_build_lambda_from_symbol()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(Exchange.GetPlainTypes().First());

            Type requiredSymbolType = typeof(string);
            string requiredSymbolPath = "vString";

            var resolvedSymbolPath = plainSymbolBuilder.GetSymbolPaths().Where(p => p == requiredSymbolPath).First(); //vString"
            Assert.Equal(requiredSymbolPath, resolvedSymbolPath);

            var acquiredSymbolType = plainSymbolBuilder.GetSymbolType(requiredSymbolPath);

            Assert.Equal(requiredSymbolType.FullName, acquiredSymbolType.FullName);

            var lambda = PredicateBuilder.BuildLambdaPredicate(plainSymbolBuilder.RootType, "vString", "==", "odd 2", "");

            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates(plainSymbolBuilder.RootType, lambda);

            var records = Exchange.GetRecords(predicateContainer, 100, 0);

            Assert.Equal(1, records.Count());
        }

        [Fact]
        public void should_build_lambda_from_query_symbol_with_range()
        {
            var plainTypes = Exchange.GetPlainTypes();

            string requiredSymbolPath = "vInt";
            Type requiredSymbolType = typeof(Int16);

            var plainSymbolBuilder = new PlainSymbolBuilder(plainTypes.First());

            var resolvedSymbolPath = plainSymbolBuilder.GetSymbolPaths().Where(p => p == requiredSymbolPath).First(); //SharedHeader.vString"

            Assert.Equal(requiredSymbolPath, resolvedSymbolPath);

            var acquiredSymbolType = plainSymbolBuilder.GetSymbolType(resolvedSymbolPath);

            Assert.Equal(requiredSymbolType.FullName, acquiredSymbolType.FullName);

            var range = OperationProvider.GetRangeForType(acquiredSymbolType);

            var operations = OperationProvider.GetOperationsForType(acquiredSymbolType);

            Assert.NotNull(range);

            Assert.Equal(8, operations.Count);

            var expectedRange = ((Int16)5, (Int16)8);
            var rangeOperation = operations.Where(o => o == "InRange").First();

            var lambda = PredicateBuilder.BuildLambdaPredicate(plainSymbolBuilder.RootType, "vInt", rangeOperation, expectedRange.Item1, expectedRange.Item2);

            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates(plainSymbolBuilder.RootType, lambda);

            var records = Exchange.GetRecords(predicateContainer, 100, 0);

            Assert.Equal(4, records.Count());
        }

        [Fact]
        public void should_build_lambda_from_query_symbol()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(Exchange.GetPlainTypes().First());

            string symbolPath = "vString";
            string symbolValue = "3";
            string symbolOperation = "Contains";
            
            var querySymbolConfiguration = new QuerySymbolConfiguration(
                plainSymbolBuilder.RootTypeName,
                symbolPath,
                typeof(string).FullName,
                symbolOperation,
                symbolValue,
                "");

            var predicateContainer = new PredicateContainer().AddQuerySymbolToPredicates(plainSymbolBuilder, querySymbolConfiguration);

            var records = Exchange.GetRecords(predicateContainer, 100, 0);

            Assert.Equal(1, records.Count());
        }


        [Fact]
        public void should_build_filter_and_sort_ascending()
        {
            var plainType = Exchange.GetPlainTypes().First();
            var plainSymbolBuilder = new PlainSymbolBuilder(plainType);
                        
            var querySymbolConfiguration = plainSymbolBuilder.CreateNewQuerySymbol(Constants.MEMBER_NAME_ENTITY_ID);

            querySymbolConfiguration.MinOrValue = "";
            querySymbolConfiguration.Operation = "!="; // not empty

            var predicateContainer = new PredicateContainer().AddQuerySymbolToPredicates(plainSymbolBuilder, querySymbolConfiguration);

            SortSettings sortSettings = new SortSettings() { IsAscending = true };

            predicateContainer.AddSortMember(sortSettings, plainType);

            var records = Exchange.GetRecords(predicateContainer, 100, 0).ToList();

            Assert.Equal(10, records.Count());

            Assert.Equal("0", records[0]._EntityId);
            Assert.Equal("1", records[1]._EntityId);
            Assert.Equal("2", records[2]._EntityId);
            Assert.Equal("3", records[3]._EntityId);
            Assert.Equal("4", records[4]._EntityId);
            Assert.Equal("5", records[5]._EntityId);
            Assert.Equal("6", records[6]._EntityId);
            Assert.Equal("7", records[7]._EntityId);
            Assert.Equal("8", records[8]._EntityId);
            Assert.Equal("9", records[9]._EntityId);
        }

        [Fact]
        public void should_build_filter_and_sort_descending()
        {
            var plainType = Exchange.GetPlainTypes().First();
            var plainSymbolBuilder = new PlainSymbolBuilder(plainType);

            var querySymbolConfiguration = plainSymbolBuilder.CreateNewQuerySymbol(Constants.MEMBER_NAME_ENTITY_ID);

            querySymbolConfiguration.MinOrValue = "";
            querySymbolConfiguration.Operation = "!="; // not empty

            var predicateContainer = new PredicateContainer().AddQuerySymbolToPredicates(plainSymbolBuilder, querySymbolConfiguration);

            SortSettings sortSettings = new SortSettings() { IsAscending = false };

            predicateContainer.AddSortMember(sortSettings, plainType);

            var records = Exchange.GetRecords(predicateContainer, 100, 0).ToList();

            Assert.Equal(10, records.Count());

            Assert.Equal("9", records[0]._EntityId);
            Assert.Equal("8", records[1]._EntityId);
            Assert.Equal("7", records[2]._EntityId);
            Assert.Equal("6", records[3]._EntityId);
            Assert.Equal("5", records[4]._EntityId);
            Assert.Equal("4", records[5]._EntityId);
            Assert.Equal("3", records[6]._EntityId);
            Assert.Equal("2", records[7]._EntityId);
            Assert.Equal("1", records[8]._EntityId);
            Assert.Equal("0", records[9]._EntityId);
        }

        [Fact]
        public void should_build_filter_and_sort_from_sort_symbol_configuration()
        {
            var plainType = Exchange.GetPlainTypes().First();
            var plainSymbolBuilder = new PlainSymbolBuilder(plainType);

            var querySymbolConfiguration = plainSymbolBuilder.CreateNewQuerySymbol(Constants.MEMBER_NAME_ENTITY_ID);

            querySymbolConfiguration.MinOrValue = "";
            querySymbolConfiguration.Operation = "!="; // not empty

            SortSymbolConfiguration sortSymbolConfiguration = new SortSymbolConfiguration(plainSymbolBuilder.RootTypeName, Constants.MEMBER_NAME_ENTITY_ID, typeof(string).FullName, false);
            var predicateContainer = new PredicateContainer();

            predicateContainer.AddQuerySymbolToPredicates(plainSymbolBuilder, querySymbolConfiguration);
            predicateContainer.AddSortSymbolToPredicates(plainSymbolBuilder, sortSymbolConfiguration);

            var records = Exchange.GetRecords(predicateContainer, 100, 0).ToList();

            Assert.Equal(10, records.Count());

            Assert.Equal("9", records[0]._EntityId);
            Assert.Equal("8", records[1]._EntityId);
            Assert.Equal("7", records[2]._EntityId);
            Assert.Equal("6", records[3]._EntityId);
            Assert.Equal("5", records[4]._EntityId);
            Assert.Equal("4", records[5]._EntityId);
            Assert.Equal("3", records[6]._EntityId);
            Assert.Equal("2", records[7]._EntityId);
            Assert.Equal("1", records[8]._EntityId);
            Assert.Equal("0", records[9]._EntityId);
        }

        [Fact]
        public void should_filter_and_sort_with_property()
        {
            var plainType = Exchange.GetPlainTypes().First();
            var plainSymbolBuilder = new PlainSymbolBuilder(plainType);

            string symbolPath = "Primitives.vINT";

            QuerySymbolConfiguration querySymbolConfiguration = plainSymbolBuilder.CreateNewQuerySymbol(symbolPath);

            querySymbolConfiguration.MinOrValue = 0;
            querySymbolConfiguration.Operation = "!=";

            SortSymbolConfiguration sortSymbolConfiguration = new SortSymbolConfiguration(plainSymbolBuilder.RootTypeName, symbolPath, typeof(string).FullName, false);

            var predicateContainer = new PredicateContainer();

            predicateContainer.AddQuerySymbolToPredicates(plainSymbolBuilder, querySymbolConfiguration);
            predicateContainer.AddSortSymbolToPredicates(plainSymbolBuilder, sortSymbolConfiguration);

            var records = Exchange.GetRecords(predicateContainer, 100, 0).ToList();
            Assert.Equal(10, records.Count());

        }
    }
}

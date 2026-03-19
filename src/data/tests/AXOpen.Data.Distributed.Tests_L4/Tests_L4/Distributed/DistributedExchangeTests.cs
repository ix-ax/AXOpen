namespace axopen.data.distributed.tests_l4
{
    using AXOpen.Base.Data.Query;
    using AXOpen.Data;
    using AXOpen.Data.Query;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    using PredicateBuilder = AXOpen.Data.Query.PredicateBuilder;
    using PocosHeader = Pocos.axopen_data_distributed_tests_l4.HeaderData;
    using PocosStation = Pocos.axopen_data_distributed_tests_l4.StationData;
    using Microsoft.AspNetCore.Http.HttpResults;

    [Collection("DistributedExchange")]
    public class DistributedExchangeTests
    {
        protected DistributedFixture Fixture { get; set; }


        public DistributedExchangeTests()
        {
            this.Fixture = new DistributedFixture(); // each test gets new instance of fixture
        }

        [Fact]
        public void should_verified_initialized_fixture()
        {
            // repositories should be initialized with 10 items each
            Assert.Equal(Fixture.RepositoryHeader.Count, 10);
            Assert.Equal(Fixture.RepositoryStation.Count, 10);

            // distributed data exchange service should have collected 1 group name
            Assert.Equal(1, Fixture.DataService.ExistingGroupNames.Count);
            Assert.Equal(Constants.DISTRIBUTED_GROUP_NAME, Fixture.DataService.ExistingGroupNames.First());

            Assert.Equal(2, Fixture.DistributedVM.Exchanges.Count());

            List<IAxoDataExchange> exchanges = Fixture.DistributedVM.Exchanges.ToList();

            Assert.Equal("Shared Header", exchanges[0].PresentableInstanceName);
            Assert.Equal("Station", exchanges[1].PresentableInstanceName);

            Assert.NotNull(exchanges[0].Repository);
            Assert.NotNull(exchanges[1].Repository);

        }

        [Fact]
        public async void should_set_external_predicates_and_ids()
        {
            // test external predicates
            var dvm = Fixture.DistributedVM;

            var externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosHeader>(p => p.vString.Contains("even"));
            externalPredicate.AddPredicates<PocosStation>(p => p.NestObj.vInt > 6);

            dvm.SetExternalPredicates(externalPredicate);
            await dvm.FillObservableRecordsAsync();

            var recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "9" }, recs);

            // test external entity ids
            dvm.SetExternalPredicates(null);
            dvm.SetExternalEntityIds(new List<string> { "4", "8" });
            await dvm.FillObservableRecordsAsync();

            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "4", "8" }, recs);

            // test predicates with ids together
            externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosStation>(p => p.NestObj.vInt > 5);

            dvm.SetExternalPredicates(externalPredicate); // should filter out 6,7,8,9,10
            dvm.SetExternalEntityIds(new List<string> { "3", "10" });
            await dvm.FillObservableRecordsAsync();

            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "10" }, recs);

        }

        [Fact]
        public async void should_enable_concat_between_managers()
        {
            // test external predicates
            var dvm = Fixture.DistributedVM;

            // switch on local concat between station and header
            await dvm.TogleLocalEntityIdsInjectionAsync();

            Assert.True(dvm.SelectedManagerVm.ExternalEntityIds.Count == 10); // entities are injected
            var recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList(); // local entities are taken from fist manager
            Assert.Equal(new[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, recs); // 1- 10

            await dvm.SelectManager(dvm.DisplayedExchanges.First()); // explicitly select header manager

            var svm = dvm.SelectedManagerVm;
            Assert.Equal(Constants.SYMBOL_HEADER_MANAGER, svm.RefUIData.Symbol);

            // set predicate on station that should filter out 3,4.
            var headerPredicates = new PredicateContainer();
            headerPredicates.AddPredicates<PocosHeader>(p => (p.vInt > 2) && (p.vInt < 5));

            await svm.FillObservableRecordsAsync(headerPredicates);

            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "3", "4" }, recs);

            await dvm.SelectManager(dvm.DisplayedExchanges.Last()); // explicitly select station manager

            svm = dvm.SelectedManagerVm;
            Assert.Equal(Constants.SYMBOL_STATION_MANAGER, svm.RefUIData.Symbol);

            Assert.Equal(2, svm.ExternalEntityIds.Count);

            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "3", "4" }, recs);


            await dvm.SelectManager(dvm.DisplayedExchanges.First()); // explicitly select header manager
            svm = dvm.SelectedManagerVm;
            Assert.Equal(Constants.SYMBOL_HEADER_MANAGER, svm.RefUIData.Symbol);

            // set predicate that should filter out 1,2.
            var headerPredicates_2 = new PredicateContainer();
            headerPredicates_2.AddPredicates<PocosHeader>(p => (p.vInt < 3));

            await svm.FillObservableRecordsAsync(headerPredicates_2);

            // intersection of [3,4] and [1,2] should be empty
            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Empty(recs);

        }

        [Fact]
        public async void should_combine_concat_and_then_external_predicates()
        {
            // ----------------- PHASE 1 : StationManager, filter with predicates ------------------
            var dvm = Fixture.DistributedVM;

            // switch on local concat between station and header
            await dvm.TogleLocalEntityIdsInjectionAsync();
            await dvm.SelectManager(dvm.DisplayedExchanges.Last()); // select station manager

            var svm = dvm.SelectedManagerVm;
            Assert.Equal(Constants.SYMBOL_STATION_MANAGER, svm.RefUIData.Symbol); // verify symbol of station manager
            Assert.Equal(10, svm.ExternalEntityIds.Count); // local entities are injected
            var recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList(); // local entities are taken from fist manager
            Assert.Equal(new[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, recs); // 1- 10

            // set predicate on station that should filter out 7-10.
            var stationPredicates = new PredicateContainer();
            stationPredicates.AddPredicates<PocosStation>(p => p.NestObj.vInt > 6); // should filter out 7,8,9,10
            await svm.FillObservableRecordsAsync(stationPredicates);

            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8", "9", "10" }, recs);

            // ----------------- PHASE 2 : HeaderManager, verify injected ids ------------------
            await dvm.SelectManager(dvm.DisplayedExchanges.First()); // select header manager
            svm = dvm.SelectedManagerVm;

            Assert.Equal(Constants.SYMBOL_HEADER_MANAGER, svm.RefUIData.Symbol);
            Assert.Equal(4, svm.ExternalEntityIds.Count); // local entities are injected

            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8", "9", "10" }, recs);

            // ----------------- PHASE 3 : DistributedManager, apply external predicates ------------------
            var externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosStation>(p => p.NestObj.vInt < 9); // should filter out 1-8, => INTERSECTION of [7,8,9,10] and [1-8] should be 7,8
            dvm.SetExternalPredicates(externalPredicate); // set external predicates => External predicates will be SET-ON !!!
            Assert.True(dvm.EnableExternalEntityIds);

            // check intersect of extenal predicates 1-8, 
            Assert.Equal(new[] { "1", "2", "3", "4", "5", "6", "7", "8" }, dvm.AllExternalEntityIds.OrderBy(int.Parse).ToList()); // only predicates are applied 
            Assert.Null(dvm.ExternalEntityIds); // explicit id list is not injected

            await dvm.FillObservableRecordsAsync(); // it has to be called becouse that way is not for UI

            // verify that intersection is applied on header manager as well
            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8" }, recs);

            await dvm.TogleExternalEntityIdsInjectionAsync(); // DISABLE, and fill records ...
            Assert.False(dvm.EnableExternalEntityIds);

            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8" }, recs);

        }

        [Fact]
        public async void should_start_with_external_ids_then_concat_and_then__external_intersect()
        {
            // ----------------- PHASE 1 : DistributedManager, with external predicats ------------------
            var dvm = Fixture.DistributedVM;
            var externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosHeader>(p => p.vInt > 8); // should filter out 10
            dvm.SetExternalPredicates(externalPredicate); // set external predicates => External predicates will be SET-ON
            await dvm.FillObservableRecordsAsync(); // refresh selected manager 

            var recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "9", "10" }, recs);

            // ----------------- PHASE 2 : DistributedManager, disable external predicates ------------------
            await dvm.TogleExternalEntityIdsInjectionAsync(); // disable
            Assert.False(dvm.EnableExternalEntityIds);

            // ----------------- PHASE 3 : DistributedManager, enable local entity ids ------------------
            await dvm.TogleLocalEntityIdsInjectionAsync(); // enable
            Assert.True(dvm.EnableLocalConcatEntityIds);
            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, recs); // 1- 10

            var localPredicate = new PredicateContainer();
            localPredicate.AddPredicates<PocosHeader>(p => p.vInt <= 2); // should filter 1,2
            await dvm.SelectedManagerVm.FillObservableRecordsAsync(localPredicate); // set local predicate on header manager

            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "1", "2" }, recs);

            // ----------------- PHASE 4 : StationManager, verify injected ids ------------------
            await dvm.SelectManager(dvm.DisplayedExchanges.Last()); // select station manager
            Assert.Equal(Constants.SYMBOL_STATION_MANAGER, dvm.SelectedManagerVm.RefUIData.Symbol);

            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "1", "2" }, recs);

            // ----------------- PHASE 5 : DistributedManager, intersect local and external predicates ------------------
            await dvm.TogleExternalEntityIdsInjectionAsync(); // enable
            Assert.True(dvm.EnableExternalEntityIds);
            Assert.True(dvm.EnableLocalConcatEntityIds);

            // intersection for [1,2,] and [9,10] should be empty
            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Empty(recs);

            // ----------------- PHASE 6 : DistributedManager, disable both external and local predicates ------------------
            await dvm.TogleExternalEntityIdsInjectionAsync(); // disable
            Assert.False(dvm.EnableExternalEntityIds);

            await dvm.TogleLocalEntityIdsInjectionAsync(); // disable
            Assert.False(dvm.EnableLocalConcatEntityIds);
            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, recs); // 1- 10
        }


        [Fact]
        public async void should_start_with_external_ids_then_concat_only_local_ids()
        {
            // ----------------- PHASE 1 : DistributedManager, with external predicates ------------------
            var dvm = Fixture.DistributedVM;
            var externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosHeader>(p => p.vInt > 8); // should filter out 10
            dvm.SetExternalPredicates(externalPredicate); // set external predicates => External predicates will be SET-ON
            await dvm.FillObservableRecordsAsync(); // refresh selected manager 

            var recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "9", "10" }, recs);

            // ----------------- PHASE 2 : DistributedManager, disabled: external and local-ids ------------------
            await dvm.TogleExternalEntityIdsInjectionAsync(); // disable
            Assert.False(dvm.EnableExternalEntityIds);
            Assert.False(dvm.EnableLocalConcatEntityIds);

            // ----------------- PHASE 3 : StationManager, verify injected ids ------------------
            await dvm.SelectManager(dvm.DisplayedExchanges.Last()); // select station manager
            Assert.Equal(Constants.SYMBOL_STATION_MANAGER, dvm.SelectedManagerVm.RefUIData.Symbol);
            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, recs); // 1- 10, all recs

            // ----------------- PHASE 4 : StationManager, apply local predicates ------------------
            var stationPredicate = new PredicateContainer();
            stationPredicate.AddPredicates<PocosStation>(p => p.NestObj.vInt > 6);
            await dvm.SelectedManagerVm.FillObservableRecordsAsync(stationPredicate);
            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8", "9", "10" }, recs); // 7-10, all recs that satisfy station predicate

            // ----------------- PHASE 5 : StationManager, set local concat ids to distributed exchange ------------------
            await dvm.SelectedManagerVm.TogleDistributedExchangeConcat(); // enable local concat ids
            Assert.True(dvm.EnableLocalConcatEntityIds);
            recs = dvm.LocalConcatEntityIds.OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8", "9", "10" }, recs); // 7-10, all recs that satisfy station predicate

             // ----------------- PHASE 6 : HeaderManager, verify injected ids ------------------
            await dvm.SelectManager(dvm.DisplayedExchanges.First()); // select header manager
            Assert.Equal(Constants.SYMBOL_HEADER_MANAGER, dvm.SelectedManagerVm.RefUIData.Symbol);
            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8", "9", "10" }, recs);


        }






    }
}

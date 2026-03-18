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
            Assert.Equal( Constants.DISTRIBUTED_GROUP_NAME , Fixture.DataService.ExistingGroupNames.First());
            
            Assert.Equal( 2 , Fixture.DistributedVM.Exchanges.Count());

            List<IAxoDataExchange> exchanges = Fixture.DistributedVM.Exchanges.ToList();

            Assert.Equal( "Shared Header"   , exchanges[0].PresentableInstanceName);
            Assert.Equal( "Station"         , exchanges[1].PresentableInstanceName);

            Assert.NotNull( exchanges[0].Repository);
            Assert.NotNull( exchanges[1].Repository);

        }

        [Fact]
        public async void should_set_external_predicates_and_ids()
        {

            // test external predicates
            var dvm = Fixture.DistributedVM;

            var externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosHeader>(p => p.vString.Contains("even"));
            externalPredicate.AddPredicates<PocosStation>(p => p.NestObj.vInt > 6);

            dvm.ExternalPredicates = externalPredicate;
            await dvm.FillObservableRecordsAsync();

            var recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "9" }, recs);

            // test external entity ids
            dvm.ExternalPredicates = null;
            dvm.ExternalEntityIds = new List<string> { "4", "8" };

            await dvm.FillObservableRecordsAsync();

            recs = dvm.SelectedManagerVm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "4", "8" }, recs);

            // test predicates with ids together
            externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosStation>(p => p.NestObj.vInt > 5);

            dvm.ExternalPredicates = externalPredicate; // should filter out 6,7,8,9,10
            dvm.ExternalEntityIds = new List<string> {"3", "10" };

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
            await dvm.TogleLocalEntityIdsInjection();

            await dvm.SelectManager(dvm.DisplayedExchanges.First()); // select header manager
            var svm = dvm.SelectedManagerVm;
            Assert.Equal(Constants.SYMBOL_HEADER_MANAGER, svm.RefUIData.Symbol);

            // set predicate on station that should filter out 3,4.
            var headerPredicates = new PredicateContainer();
            headerPredicates.AddPredicates<PocosHeader>(p => (p.vInt > 2) && (p.vInt < 5) );

            await svm.FillObservableRecordsAsync(headerPredicates);

            var recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "3", "4" }, recs);

            await dvm.SelectManager(dvm.DisplayedExchanges.Last()); // select station manager

            svm = dvm.SelectedManagerVm;
            Assert.Equal(Constants.SYMBOL_STATION_MANAGER, svm.RefUIData.Symbol);

            Assert.Equal(2, svm.EntityIdsInjected.Count);

            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "3", "4" }, recs);

        }

         [Fact]
        public async void should_combine_concat_and_then_external_predicates()
        {
            // ----------------- PHASE 1 : StationManager, filter with predicates ------------------
            var dvm = Fixture.DistributedVM;

            // switch on local concat between station and header
            await dvm.TogleLocalEntityIdsInjection();
            await dvm.SelectManager(dvm.DisplayedExchanges.Last()); // select station manager

            var svm = dvm.SelectedManagerVm;
            Assert.Equal(Constants.SYMBOL_STATION_MANAGER, svm.RefUIData.Symbol);

            var stationPredicates = new PredicateContainer();
            stationPredicates.AddPredicates<PocosStation>(p => p.NestObj.vInt > 6); // should filter out 7,8,9,10
            await svm.FillObservableRecordsAsync(stationPredicates);

            var recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8", "9", "10" }, recs);

            // ----------------- PHASE 2 : HeaderManager, verify injected ids ------------------
            await dvm.SelectManager(dvm.DisplayedExchanges.First()); // select header manager
            svm = dvm.SelectedManagerVm;
            Assert.Equal(Constants.SYMBOL_HEADER_MANAGER, svm.RefUIData.Symbol);

            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7", "8", "9", "10" }, recs);

            // ----------------- PHASE 3 : DistributedManager, apply external predicates ------------------
            var externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosStation>(p => p.NestObj.vInt <= 7); // should filter out 1-6

            dvm.ExternalPredicates = externalPredicate; // set external predicates => External predicates will be SET-ON

            //await svm.FillObservableRecordsAsync(); // apply external predicates

            recs = svm.Records.Select(r => r._EntityId).OrderBy(int.Parse).ToList();
            Assert.Equal(new[] { "7" }, recs);

        }





    }
}

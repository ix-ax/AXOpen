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

            var recs = dvm.SelectedManagerVm.Records.ToList();

            Assert.Equal(2, recs.Count); // 7,9
            Assert.Equal("9", recs[0]._EntityId); 
            Assert.Equal("7", recs[1]._EntityId);

            // test external entity ids
            dvm.ExternalPredicates = null;
            dvm.ExternalEntityIds = new List<string> { "4", "8" };

            await dvm.FillObservableRecordsAsync();

            recs = dvm.SelectedManagerVm.Records.ToList();

            Assert.Equal(2, recs.Count); // 8,4
            Assert.Equal("8", recs[0]._EntityId);
            Assert.Equal("4", recs[1]._EntityId);

            // test predicates with ids together
            externalPredicate = new PredicateContainer();
            externalPredicate.AddPredicates<PocosStation>(p => p.NestObj.vInt > 5);

            dvm.ExternalPredicates = externalPredicate; // should filter out 6,7,8,9,10
            dvm.ExternalEntityIds = new List<string> {"3", "10" };

            await dvm.FillObservableRecordsAsync();
            recs = dvm.SelectedManagerVm.Records.ToList();

            Assert.Equal(1, recs.Count); // 7,4,2
            Assert.Equal("10", recs[0]._EntityId);

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
            Assert.Equal("DistributedContext.DataManager.Header.Set", svm.RefUIData.Symbol);

            // set predicate on station that should filter out 3,4.
            var headerPredicates = new PredicateContainer();
            headerPredicates.AddPredicates<PocosHeader>(p => (p.vInt > 2) && (p.vInt < 5) );

            await svm.FillObservableRecordsAsync(headerPredicates);

            var recs = svm.Records.ToList();
            Assert.Equal(2, recs.Count); // 3,4,
            Assert.Equal("4", recs[0]._EntityId);
            Assert.Equal("3", recs[1]._EntityId);

            await dvm.SelectManager(dvm.DisplayedExchanges.Last()); // select station manager

            svm = dvm.SelectedManagerVm;
            Assert.Equal("DistributedContext.DataManager.St1.Set", svm.RefUIData.Symbol);

            Assert.Equal(2, svm.EntityIdsInjected.Count);

            recs = svm.Records.ToList();
            Assert.Equal(2, recs.Count); // 3,4,
            Assert.Equal("4", recs[0]._EntityId);
            Assert.Equal("3", recs[1]._EntityId);

        }





    }
}

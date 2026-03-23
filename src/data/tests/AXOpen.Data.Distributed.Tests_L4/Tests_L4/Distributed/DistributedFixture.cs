namespace axopen.data.distributed.tests_l4
{
    using AXOpen.Base.Data;
    using AXOpen.Base.Data.Query;
    using AXOpen.Data;
    using AXOpen.Data.InMemory;
    using AXSharp.Connector;
    using Microsoft.AspNetCore.Components.Authorization;
    using Operon.Components.Toast;
    using Pocos.axopen_data_distributed_tests_l4;

    public class DistributedFixture : IDisposable
    {
        internal IRepository<HeaderData> RepositoryHeader;
        internal IRepository<StationData> RepositoryStation;

        internal DistributedDataExchangeService DataService;
        internal AxoDataExchangeConfigurationService ConfigService;

        internal axopen_data_distributed_tests_l4TwinController Plc;

        internal DistributedDataViewModel DistributedVM { set; get; }

        
        public DistributedFixture()
        {
            Plc = new(ConnectorAdapterBuilder.Build().CreateDummy());
            this.RepositoryHeader = AXOpen.Data.InMemory.Repository.Factory<HeaderData>(new InMemoryRepositorySettings<HeaderData>());
            this.RepositoryStation = AXOpen.Data.InMemory.Repository.Factory<StationData>(new InMemoryRepositorySettings<StationData>());

            var ctx = Plc.DistributedContext;
            ctx.DataManager.Header.SetRepository(this.RepositoryHeader);
            ctx.DataManager.St1.SetRepository(this.RepositoryStation);

            DataService = new AXOpen.Data.DistributedDataExchangeService();
            ConfigService = new AXOpen.Data.AxoDataExchangeConfigurationService();

            DataService.CollectAxoDataExchanges(Plc.DistributedContext);

            InitializeData();

            DistributedVM = new DistributedDataViewModel(
                     null,
                     null,
                     this.DataService,
                     this.ConfigService,
                     axopen.data.distributed.tests_l4.Constants.DISTRIBUTED_GROUP_NAME,
                     true,
                     "",
                     null,
                     null
                     );
        }

        internal void InitializeData()
        {
            for (int i = 1; i < 11; i++)
            {
                var h = new HeaderData();
                FillUpData(h, i);
                RepositoryHeader.Create(h._EntityId, h);

                var station = new StationData();
                FillUpData(station, i);
                RepositoryStation.Create(station._EntityId, station);
            }
        }

        private void FillUpData(HeaderData obj, int iteration)
        {
            var isOdd = iteration % 2 == 0;

            obj._EntityId = iteration.ToString();
            obj.vInt = (short)iteration;
            obj.vBool = isOdd;
            obj.vString = (isOdd ? "odd " : "even ") + iteration.ToString();
        }

        private void FillUpData(StationData obj, int iteration)
        {
            var isOdd = iteration % 2 == 0;

            obj._EntityId = iteration.ToString();
            
            obj.vBool = isOdd;
            obj.NestObj.vBool = isOdd;
            obj.vInt = (short)iteration;
            obj.NestObj.vInt = (short)(iteration);

            obj.vString = (isOdd ? "odd " :  "even ") + iteration.ToString();
            obj.NestObj.vString = obj.vString;
        }

        public virtual void Dispose()
        {
            // Clean up
        }
    }
}

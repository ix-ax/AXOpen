using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using MongoDB.Driver;
    
namespace Tests_L4
{
    using Pocos.FragmentExchange_Test_L4;

    public class FragmentDataExchangeMongoFixture : IDisposable
    {
        internal IRepository<HeaderData> _headerRepository;
        internal IRepository<StationData> _stationRepository;

        public FragmentDataExchangeMongoFixture()
        {
            // Initialize shared resource (e.g., open a database connection)
            var headerParameters = new MongoDbRepositorySettings<HeaderData>("mongodb://localhost:27017", "AxOpen_L4", "FragmentHeader");

            var stationParameters = new MongoDbRepositorySettings<StationData>("mongodb://localhost:27017", "AxOpen_L4", "FragmentStation");

            // clean up repository
            headerParameters.Collection.DeleteMany(Builders<HeaderData>.Filter.Empty);
            stationParameters.Collection.DeleteMany(Builders<StationData>.Filter.Empty);

            this._headerRepository = AXOpen.Data.MongoDb.Repository.Factory(headerParameters);
            this._stationRepository = AXOpen.Data.MongoDb.Repository.Factory(stationParameters);
                        
            for (int i = 1; i < 11; i++)
            {
                var h = new HeaderData();
                FillUpData(h, i);
                _headerRepository.Create(h.DataEntityId, h);

                var station = new StationData();
                FillUpData(station, i);
                _stationRepository.Create(station.DataEntityId, station);
            }
        }

        private void FillUpData(HeaderData obj, int iteration)
        {
            obj.DataEntityId = iteration.ToString();
            obj.vBool = true;
            obj.vString = iteration.ToString();
            obj.vInt = (short)iteration;
        }

        private void FillUpData(StationData obj, int iteration)
        {
            obj.DataEntityId = iteration.ToString();
            obj.vBool = true;
            obj.vString = iteration.ToString();
            obj.vInt = (short)iteration;

            obj.NestObj.vString = (iteration + 1).ToString();
            obj.NestObj.vBool = true;
            obj.NestObj.vInt = (short)(iteration + 1);
        }

        public void Dispose()
        {
            // Clean up
        }
    }
}
namespace Tests_L4
{
    using AXOpen.Data.MongoDb;
    using MongoDB.Driver;
    using Pocos.FragmentExchange_Test_L4;

    public class FragmentRepositoryFixture_Mongo : FragmentRepositoryFixture_Base
    {
        public FragmentRepositoryFixture_Mongo()
        {
            // Initialize shared resource (e.g., open a database connection)
            var headerParameters = new MongoDbRepositorySettings<HeaderData>("mongodb://localhost:27017", Constants.MONGO_REPOSITORY_NAME, Constants.MONGO_COMPOUD_HEADER_COLLECTION_NAME);

            var stationParameters = new MongoDbRepositorySettings<StationData>("mongodb://localhost:27017", Constants.MONGO_REPOSITORY_NAME, Constants.MONGO_COMPOUD_STATION_COLLECTION_NAME);

            // clean up repository
            headerParameters.Collection.DeleteMany(Builders<HeaderData>.Filter.Empty);
            stationParameters.Collection.DeleteMany(Builders<StationData>.Filter.Empty);

            this.RepositoryHeader = AXOpen.Data.MongoDb.Repository.Factory(headerParameters);
            this.RepositoryStation = AXOpen.Data.MongoDb.Repository.Factory(stationParameters);

            InitializeData();
        }

        public void Dispose()
        {
            // Clean up
        }
    }
}
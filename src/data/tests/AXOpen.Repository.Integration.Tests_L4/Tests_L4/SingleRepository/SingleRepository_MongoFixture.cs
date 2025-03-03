using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using MongoDB.Driver;

namespace Tests_L4
{
    using Pocos.Exchange_Test_L4;

    public class SingleRepository_MongoFixture : BaseFixture_Simple
    {
        public SingleRepository_MongoFixture()
        {
            // Initialize shared resource (e.g., open a database connection)
            var parameters = new MongoDbRepositorySettings<ProcessData>("mongodb://localhost:27017", Constants.MONGO_REPOSITORY_NAME, Constants.MONGO_SIMPLE_COLLECTION_NAME);

            // clean up repository
            parameters.Collection.DeleteMany(Builders<ProcessData>.Filter.Empty);

            this._repository = AXOpen.Data.MongoDb.Repository.Factory(parameters);

            InitializeData();
        }

        public override void Dispose()
        {
            base.Dispose();
        }
    }
}
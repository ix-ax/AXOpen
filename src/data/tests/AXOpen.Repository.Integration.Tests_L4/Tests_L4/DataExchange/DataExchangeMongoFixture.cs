using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using MongoDB.Driver;

namespace Tests_L4
{
    using Pocos.Exchange_Test_L4;

    public class DataExchangeMongoFixture : IDisposable
    {
        internal IRepository<ProcessData> _repository;

        public DataExchangeMongoFixture()
        {
            // Initialize shared resource (e.g., open a database connection)
            var parameters = new MongoDbRepositorySettings<ProcessData>("mongodb://localhost:27017", "AxOpen_L4", "DataTestObject");

            // clean up repository
            parameters.Collection.DeleteMany(Builders<ProcessData>.Filter.Empty);

            this._repository = AXOpen.Data.MongoDb.Repository.Factory(parameters);

            for (int i = 0; i < 10; i++)
            {
                var item = new ProcessData();

                FillUpData(item, i);

                _repository.Create(item.DataEntityId, item);
            }
        }

        private void FillUpData(ProcessData obj, int iteration)
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
using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using MongoDB.Driver;

namespace Tests_L4
{
    using Pocos.Exchange_Test_L4;

    public class SingleRepository_MongoFixture : IDisposable
    {
        internal IRepository<ProcessData> _repository;

        public SingleRepository_MongoFixture()
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
            obj.vString = "even " + iteration.ToString();
            obj.vInt = (short)iteration;

            obj.NestObj.vString = "odd " + (iteration + 1).ToString();
            obj.NestObj.vBool = true;
            obj.NestObj.vInt = (short)(iteration + 1);

            if (iteration % 2 == 0)
            {
                obj.vBool = false;
                obj.NestObj.vBool = false;
                obj.vString = "odd " + iteration.ToString();
                obj.NestObj.vString = "even " + (iteration + 1).ToString();
            }
        }

        public void Dispose()
        {
            // Clean up
        }
    }
}
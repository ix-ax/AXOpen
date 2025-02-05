using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using MongoDB.Driver;
using Pocos.plc1;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace RepositoryTestProject_L4
{
    public class MongoDatabaseFixture : IDisposable
    {
        internal IRepository<DataTestObject> repository;

        public MongoDatabaseFixture()
        {
            // Initialize shared resource (e.g., open a database connection)
            var parameters = new MongoDbRepositorySettings<DataTestObject>("mongodb://localhost:27017", "AxOpen_L4", "DataTestObject");

            // clean up repository
            parameters.Collection.DeleteMany(Builders<DataTestObject>.Filter.Empty);

            this.repository = AXOpen.Data.MongoDb.Repository.Factory(parameters);

            DateTime initialTime = DateTime.Parse("2025-01-01T09:08:07");

            for (int i = 0; i < 10; i++)
            {
                var item = new DataTestObject();

                item.FillUpData(i, initialTime);

                repository.Create(item.DataEntityId, item);
            }
        }

        public void Dispose()
        {
            // Clean up
        }
    }
}
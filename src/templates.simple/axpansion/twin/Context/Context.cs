using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;

namespace axosimple
{
    public class ContextService
    {
        private ContextService()
        {
            
        }

        private axosimple.Context Context { get; } = Entry.Plc.Context;

        public axosimple.ProcessData ProcessData { get; } = Entry.Plc.Context.ProcessData.CreateBuilder<axosimple.ProcessData>();

        //public string MongoConnectionString { get; private set; }
        //public string MongoDatabaseName { get; private set; }
        //internal MongoDbCredentials Credentials { get; private set; }

        public IRepository<Pocos.axosimple.SharedProductionData> SharedProcessDataRepository { get; private set; }

        public static ContextService Create()
        {
            var retVal = new ContextService();
            return retVal;
        }
        //public static ContextService Create(
        //    string mongoConnectionString = "mongodb://localhost:27017",
        //    string mongoDatabaseName = "axosimple",
        //    string user = "user",
        //    string userpw = "userpwd"
        //    )
        //{
        //    var retVal = new ContextService(mongoConnectionString, mongoDatabaseName, user, userpw);

        //    return retVal;
        //}

        public void SetContextData(IRepository<Pocos.axosimple.SharedProductionData> repository)
        {
            SharedProcessDataRepository = repository;
            ProcessData.Shared.InitializeRemoteDataExchange(repository);

            ProcessData.InitializeRemoteDataExchange();
        }
    }
}

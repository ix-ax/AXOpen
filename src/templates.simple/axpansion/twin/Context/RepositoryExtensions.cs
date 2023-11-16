using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;

namespace axosimple.MongoDb
{
    public static class Repository
    {
        public static IRepository<T> Factory<T>(string collectionName) where T : IBrowsableDataObject
        {
            try
            {
                return new MongoDbRepository<T>(
                            new MongoDbRepositorySettings<T>(
                                connectionString: MongoConnectionString,
                                databaseName: MongoDatabaseName,
                                collectionName: collectionName,
                                credentials: Credentials)
                            );
            }
            catch (Exception ex)
            {
                throw new Exception($"Creation of MongoDb repository failed. Check number, type and value of parameters. For detail see inner exception.", ex);
            }
        }

        public static void InitialzeFactory(string mongoConnectionString = "mongodb://localhost:27017",
                                            string mongoDatabaseName = "axosimple",
                                            string user = "user",
                                            string userpw = "userpwd")
        {
            MongoConnectionString = mongoConnectionString;
            MongoDatabaseName = mongoDatabaseName;
            Credentials = new MongoDbCredentials(MongoDatabaseName, user, userpw);
        }

        public static string MongoConnectionString { get; private set; }
        public static string MongoDatabaseName { get; private set; }
        internal static MongoDbCredentials Credentials { get; private set; }
    }
}
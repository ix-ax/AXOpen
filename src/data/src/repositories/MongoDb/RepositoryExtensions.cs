using System;
using AXOpen.Base.Data;
using AXOpen.Data;

namespace AXOpen.Data.MongoDb
{
    public static class Repository
    {
        private static string MongoConnectionString { get; set; }
        private static string MongoDatabaseName { get; set; }
        private static MongoDbCredentials Credentials { get; set; }

        public static void InitializeFactory(string mongoConnectionString = "mongodb://localhost:27017",
                                             string mongoDatabaseName = "AxOpenData",
                                             string user = "user",
                                             string userpw = "userpwd")
        {
            MongoConnectionString = mongoConnectionString;
            MongoDatabaseName = mongoDatabaseName;
            Credentials = new MongoDbCredentials(MongoDatabaseName, user, userpw);
        }

        public static IRepository<T> Factory<T>(this MongoDbRepositorySettings<T> parameters) where T : IBrowsableDataObject
        {
            try
            {
                return new MongoDbRepository<T>(parameters);
            }
            catch (Exception ex)
            {
                throw new Exception($"Creation of MongoDb repository failed. Check number, type and value of parameters. For detail see inner exception.", ex);
            }
        }

        public static IRepository<T> Factory<T>(string collectionName) where T : IBrowsableDataObject
        {
            try
            {
                var settings = new MongoDbRepositorySettings<T>(
                                connectionString: MongoConnectionString,
                                databaseName: MongoDatabaseName,
                                collectionName: collectionName,
                                credentials: Credentials);

                return new MongoDbRepository<T>(settings);
            }
            catch (Exception ex)
            {
                throw new Exception($"Creation of MongoDb repository failed. Check number, type and value of parameters. For detail see inner exception.", ex);
            }
        }
    }
}

using System;
using System.Linq.Expressions;
using AXOpen.Base.Data;
using AXOpen.Data;

namespace AXOpen.Data.MongoDb
{
    public static class Repository
    {
        //private static string MongoConnectionString { get; set; }
        //private static string MongoDatabaseName { get; set; }
        //private static MongoDbCredentials Credentials { get; set; }

        ///// <summary>
        ///// Initializes the MongoDB repository factory with default connection settings.
        ///// </summary>
        ///// <param name="mongoConnectionString">The MongoDB connection string.</param>
        ///// <param name="mongoDatabaseName">The name of the MongoDB database.</param>
        ///// <param name="user">The username for database access.</param>
        ///// <param name="userpw">The password for database access.</param>
        //public static void InitializeFactory(string mongoConnectionString = "mongodb://localhost:27017",
        //                                     string mongoDatabaseName = "AxOpenData",
        //                                     string user = "user",
        //                                     string userpw = "userpwd")
        //{
        //    MongoConnectionString = mongoConnectionString;
        //    MongoDatabaseName = mongoDatabaseName;
        //    Credentials = new MongoDbCredentials(MongoDatabaseName, user, userpw);
        //}

        /// <summary>
        /// Creates a repository for a specific type using the provided repository settings.
        /// </summary>
        /// <typeparam name="T">The type of the data object for the repository.</typeparam>
        /// <param name="parameters">The settings to be used for the repository.</param>
        /// <returns>An instance of <see cref="IRepository{T}"/>.</returns>
        /// <exception cref="Exception">Thrown when repository creation fails.</exception>
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

        ///// <summary>
        ///// Creates a repository for a specific type and collection name.
        ///// </summary>
        ///// <typeparam name="T">The type of the data object for the repository.</typeparam>
        ///// <param name="collectionName">The name of the MongoDB collection.</param>
        ///// <returns>An instance of <see cref="IRepository{T}"/>.</returns>
        ///// <exception cref="Exception">Thrown when repository creation fails.</exception>
        //public static IRepository<T> Factory<T>(string collectionName) where T : IBrowsableDataObject
        //{
        //    try
        //    {
        //        var settings = new MongoDbRepositorySettings<T>(
        //                        connectionString: MongoConnectionString,
        //                        databaseName: MongoDatabaseName,
        //                        collectionName: collectionName,
        //                        credentials: Credentials);

        //        return new MongoDbRepository<T>(settings);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new Exception($"Creation of MongoDb repository failed. Check number, type and value of parameters. For detail see inner exception.", ex);
        //    }
        //}

        ///// <summary>
        ///// Creates a repository for a specific type, collection name, and ID expression.
        ///// </summary>
        ///// <typeparam name="T">The type of the data object for the repository.</typeparam>
        ///// <param name="collectionName">The name of the MongoDB collection.</param>
        ///// <param name="idExpression">An expression defining the property to use as the MongoDB '_id'.</param>
        ///// <returns>An instance of <see cref="IRepository{T}"/>.</returns>
        ///// <exception cref="Exception">Thrown when repository creation fails.</exception>
        //public static IRepository<T> Factory<T>(MongoDbRepositorySettings<T> settings, Expression<Func<T, object>> idExpression) where T : IBrowsableDataObject
        //{
        //    try
        //    {
        //        var settings = new MongoDbRepositorySettings<T>(
        //                        connectionString: MongoConnectionString,
        //                        databaseName: MongoDatabaseName,
        //                        collectionName: collectionName,
        //                        credentials: Credentials,
        //                        idExpression: idExpression
        //                        );

        //        return new MongoDbRepository<T>(settings);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new Exception($"Creation of MongoDb repository failed. Check number, type and value of parameters. For detail see inner exception.", ex);
        //    }
        //}
    }
}

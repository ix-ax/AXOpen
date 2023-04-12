using System;
using AXOpen.Base.Data;
using AXOpen.Data;
using AXOpen.Data.MongoDb;

namespace Ix.Framework.Repository.Integration.Tests
{
    /**
     * I'm using shared project bcs of these reasons 
     * - Avoid duplication of `DataTestObject` 
     * - When you reference  the assembly with `RepositoryBaseTests` and inherit it in this project, unit test will not be found be NUnit
     * - I need a build time constant to avoid errors with `AlteredStructureTest` - it needs a type from `TcoData.Repository.Unit.Tests` which I don't have.
    **/
    public class MongoDbRepositoryTest : RepositoryBaseTests
    {
        public override void Init()
        {
            if(this.repository == null)
            {
                //var server = new MongoDB.Embedded.EmbeddedMongoDbServer();
                
                var a = new DataTestObject();
#pragma warning disable CS0618 // Type or member is obsolete
                var parameters = new MongoDbRepositorySettings<DataTestObject>("mongodb://localhost:27017", "TestDataBase", "TestCollection");
                var parametersAltered = new MongoDbRepositorySettings<DataTestObjectAlteredStructure>("mongodb://localhost:27017", "TestDataBase", "TestCollection");
#pragma warning restore CS0618 // Type or member is obsolete
                this.repository = AXOpen.Data.MongoDb.Repository.Factory(parameters);

                this.repository_altered_structure = AXOpen.Data.MongoDb.Repository.Factory(parametersAltered);

                this.repository.OnCreate = (id, data) => { data._Created = DateTimeProviders.DateTimeProvider.Now; data._Modified = DateTimeProviders.DateTimeProvider.Now; };
                this.repository.OnUpdate = (id, data) => { data._Modified = DateTimeProviders.DateTimeProvider.Now; };
            }

            foreach (var item in this.repository.GetRecords("*"))
            {
                repository.Delete(item.DataEntityId);
            } 
        }
    }
}

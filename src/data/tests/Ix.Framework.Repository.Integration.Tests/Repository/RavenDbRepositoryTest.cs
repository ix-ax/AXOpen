using Ix.Base.Data;
using Ix.Framework.Data;
using Ix.Framework.RavenDb;
using System.IO;
using System.Reflection;
using Raven.Embedded;

namespace Ix.Framework.Repository.Integration.Tests
{
    public class RavenDbRepositoryTest : RepositoryBaseTests
    {
        private void CleanDatabase()
        {
            if (this.repository != null)
            {
                foreach (var item in this.repository.GetRecords("*"))
                    repository.Delete(item.DataEntityId);
            }

            if (this.repository_altered_structure != null)
            {
                foreach (var item in this.repository_altered_structure.GetRecords("*"))
                    repository_altered_structure.Delete(item.DataEntityId);
            }
        }

        public override void Init()
        {
            if (this.repository == null)
            {
                EmbeddedServer.Instance.StartServer(new ServerOptions
                {
                    DataDirectory = Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory.FullName, "tmp", "data"),
                    AcceptEula = true,
                    ServerUrl = "http://127.0.0.1:8080",
                });
                //var parameters = new RavenDbTestRepositorySettings<DataTestObject>();
                //var parametersAltered = new RavenDbTestRepositorySettings<DataTestObjectAlteredStructure>();
                var parameters = new RavenDbRepositorySettings<DataTestObject>(new string[] { "http://localhost:8080" }, "TestDataBase", "", "credentials");
                var parametersAltered = new RavenDbRepositorySettings<DataTestObjectAlteredStructure>(new string[] { "http://localhost:8080" }, "TestDataBase", "", "");

                this.repository = new RavenDbRepository<DataTestObject>(parameters);
                this.repository_altered_structure = new RavenDbRepository<DataTestObjectAlteredStructure>(parametersAltered);
            }

            this.repository.OnCreate = (id, data) => { data._Created = DateTimeProviders.DateTimeProvider.Now; data._Modified = DateTimeProviders.DateTimeProvider.Now; };
            this.repository.OnUpdate = (id, data) => { data._Modified = DateTimeProviders.DateTimeProvider.Now; };

            CleanDatabase();
        }

        public override void TearDown()
        {
            CleanDatabase();

            base.TearDown();
        }
    }
}

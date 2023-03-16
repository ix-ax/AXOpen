using System.Reflection;
using System.Runtime.CompilerServices;
using IntegrationTests;
using intergrations;
using Ix.Base.Data;
using Ix.Connector;
using Ix.Framework.Data.InMemory;
using Ix.Framework.Data.Json;
using Ix.Framework.Data.MongoDb;
using Ix.Framework.Data.RavenDb;
using Pocos.IntegrationLightDirect;
using Raven.Embedded;


namespace integrations.data
{

    using System;
    using System.Reflection.Metadata;
    using Xunit;

    internal static class Remoting
    {
        private static string _kickoffer = string.Empty;
        private static volatile object _mutex = new();
        public static object KickOff()
        {
            lock (_mutex)
            {
                if (_kickoffer == string.Empty)
                {
                    var assemblyFile = new FileInfo(Assembly.GetExecutingAssembly().Location);
                    var outputFolder = Path.Combine(assemblyFile.Directory.FullName, "storage");

                    if (Directory.Exists(outputFolder))
                    {
                        Directory.Delete(outputFolder, true);
                    }

                    EmbeddedServer.Instance.StartServer(new ServerOptions
                    {
                        DataDirectory =
                            Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory.FullName,
                                "tmp", "data"),
                        AcceptEula = true,
                        ServerUrl = "http://127.0.0.1:8080",
                    });

                    Entry.Plc.Connector.BuildAndStart();
                    _kickoffer = "inits";
                }
            }

            return _kickoffer;
        }
    }

    public abstract class DataExchangeTestBase
    {
        private IntegrationLightDirect.DataExchangeLightTestsContext testContext = 
            Entry.Plc.Integrations.DataExchangeLightTestsContext;

        protected IRepository<Pocos.IntegrationLightDirect.DataSet> Repository { get; set; }

        public DataExchangeTestBase()
        {
            
        }

        [Fact]
        public async Task CreateTest()
        {
            //--Arrange
            var sut = testContext;
            var identifier = "hello-id";
            await sut.CreateTest.Identifier.SetAsync(identifier);

            //-- Act
            await sut.CreateTest.RunTest();

            //-- Assert
            Assert.NotNull(Repository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier));
        }

        [Fact]
        public async Task ReadTest()
        {
            //--Arrange
            var sut = testContext;
            var identifier1 = "hello-id-to-read-1";
            var identifier2 = "hello-id-to-read-2";

            Repository.Create(identifier1, new DataSet());
            Repository.Create(identifier2, new DataSet());
            
            await sut.ReadTest.Identifier.SetAsync(identifier1);
            await sut.ReadTest.RunTest();

            //-- Assert

            var record = Repository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier1);
            Assert.Equal("hello-id-to-read-1", Entry.Plc.Integrations.DM._data.DataEntityId.GetAsync().Result);
        }

        [Fact]
        public async Task UpdateTest()
        {
            //--Arrange
            var sut = testContext;
            var identifier = "hello-id-to-update";
            await sut.UpdateTest.Identifier.SetAsync(identifier);
            Repository.Create(identifier, new() { SomeData = "some data"});

            //-- Act
            await Entry.Plc.Integrations.DM._data.SomeData.SetAsync("this has been modified");
            await sut.UpdateTest.RunTest();

            //-- Assert

            var record = Repository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier);
            Assert.Equal("this has been modified", record.SomeData);
        }

        [Fact]
        public async Task DeleteTest()
        {
            //--Arrange
            var sut = testContext;
            var identifier1 = "hello-id-to-delete-1";
            var identifier2 = "hello-id-to-delete-2";


            Repository.Create(identifier1, new ());
            Repository.Create(identifier2, new());
            
            await sut.DeleteTest.Identifier.SetAsync(identifier1);
            await sut.DeleteTest.RunTest();

            //-- Assert

            var record = Repository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier1);
            Assert.Null(record);
        }
    }

    public class DataExchangeTestInMemory : DataExchangeTestBase
    {
        public DataExchangeTestInMemory() : base()
        {
            Remoting.KickOff();
            this.Repository = new InMemoryRepository<DataSet>(new());

            Entry.Plc.Integrations.DM.DeInitializeRemoteDataExchange();

            Entry.Plc.Integrations.DM
                .InitializeRemoteDataExchange
                    (this.Repository);
        }
    }

    public class DataExchangeTestJson : DataExchangeTestBase
    {
        public DataExchangeTestJson() : base()
        {
            Remoting.KickOff();
            var assemblyFile = new FileInfo(Assembly.GetExecutingAssembly().Location);
            var outputFolder = Path.Combine(assemblyFile.Directory.FullName, "storage");

            if (Directory.Exists(outputFolder))
            {
                Directory.Delete(outputFolder, true);
            }

            this.Repository = new JsonRepository<DataSet>(new(Path.Combine(assemblyFile.Directory.FullName, "storage")));

            Entry.Plc.Integrations.DM.DeInitializeRemoteDataExchange();
            Entry.Plc.Integrations.DM
                .InitializeRemoteDataExchange
                    (Repository);

        }
    }

    public class DataExchangeTestRaven : DataExchangeTestBase
    {
        public DataExchangeTestRaven() : base()
        {
            Remoting.KickOff();
            this.Repository = new RavenDbRepository<DataSet>(new RavenDbRepositorySettings<DataSet>(new string[] { "http://localhost:8080" }, "TestDataBase", "", "credentials"));

            var records = this.Repository.GetRecords().ToList();

            for (int i = 0; i < records.Count; i++)
            {
                this.Repository.Delete(records[i].DataEntityId);
            }
                

            Entry.Plc.Integrations.DM.DeInitializeRemoteDataExchange();
            Entry.Plc.Integrations.DM
                .InitializeRemoteDataExchange
                    (Repository);

        }
    }
}
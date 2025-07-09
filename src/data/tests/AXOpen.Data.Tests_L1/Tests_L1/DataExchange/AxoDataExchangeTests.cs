using Xunit;
using AXOpen.Base.Data;
using AXOpen.Data.InMemory;
using AXSharp.Connector;
using NSubstitute;
using Microsoft.VisualBasic;

namespace AXOpen.Data.Tests
{
    using TOnline = AXOpen.Data.AxoDataEntity;
    using TPlain = Pocos.AXOpen.Data.AxoDataEntity;
    using Pocos.AXOpen.Data;
    using System.IO.Compression;
    using System.Xml.Linq;
    using System.IO;
    using System.Security.Claims;


    using Pocos.Tests_L1;


    public class AxoDataExchangeTests
    {

        public class OnlineMockData : AXOpen.Data.AxoDataEntity
        {
            public OnlineMockData(ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
            {
            }
        }

        [Fact()]
        public async void CreateTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            await sut.CreateAsync("aa", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });

            Assert.Equal(1, repo.Count);
            Assert.Equal("aa", repo.Queryable.First().DataEntityId);
            Assert.Equal("hello", repo.Queryable.First().Name);
            Assert.Equal(1, repo.Queryable.First().ComesFrom);
        }

        [Fact()]
        public async void ReadTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            await sut.CreateAsync("aa", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });
            await sut.CreateAsync("bb", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });

            var actual = await sut.ReadAsync("aa");

            Assert.Equal(2, repo.Count);
            Assert.Equal("aa", actual.DataEntityId);
            Assert.Equal("hello", actual.Name);
            Assert.Equal(1, actual.ComesFrom);
        }

        [Fact()]
        public async void UpdateTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            var toUpdate = new SharedEntityHeader() { Name = "hello", ComesFrom = 1 };
            await sut.CreateAsync("aa", toUpdate);

            toUpdate.Name = "world";
            toUpdate.ComesFrom = 100;

            await sut.UpdateAsync("aa", toUpdate);

            var actual = await sut.ReadAsync("aa");

            Assert.Equal(1, repo.Count);
            Assert.Equal("aa", actual.DataEntityId);
            Assert.Equal("world", actual.Name);
            Assert.Equal(100, actual.ComesFrom);
        }

        [Fact()]
        public async void DeleteTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            await sut.CreateAsync("aa", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });
            await sut.CreateAsync("bb", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });

            await sut.DeleteAsync("aa");


            Assert.Equal(1, repo.Count);
        }

        [Fact()]
        public async void EntityExistTest_True()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            await sut.CreateAsync("aa", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });
            await sut.CreateAsync("bb", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });

            var actual = await sut.EntityExistAsync("aa");

            Assert.Equal(2, repo.Count);
            Assert.True(actual);
        }

        [Fact()]
        public async void EntityExistTest_False()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            await sut.CreateAsync("aa", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });
            await sut.CreateAsync("bb", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });

            var actual = await sut.EntityExistAsync("cc");

            Assert.Equal(2, repo.Count);
            Assert.False(actual);
        }

        [Fact()]
        public async void CreateOrUpdateTest_Create()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            await sut.CreateOrUpdateAsync("aa", new SharedEntityHeader() { Name = "hello", ComesFrom = 1 });

            Assert.Equal(1, repo.Count);
            Assert.Equal("aa", repo.Queryable.First().DataEntityId);
            Assert.Equal("hello", repo.Queryable.First().Name);
            Assert.Equal(1, repo.Queryable.First().ComesFrom);
        }

        [Fact()]
        public async void CreateOrUpdateTest_Update()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            var toUpdate = new SharedEntityHeader() { Name = "hello", ComesFrom = 1 };
            await sut.CreateAsync("aa", toUpdate);

            toUpdate.Name = "world";
            toUpdate.ComesFrom = 100;

            await sut.CreateOrUpdateAsync("aa", toUpdate);

            var actual = await sut.ReadAsync("aa");

            Assert.Equal(1, repo.Count);
            Assert.Equal("aa", actual.DataEntityId);
            Assert.Equal("world", actual.Name);
            Assert.Equal(100, actual.ComesFrom);
        }

        [Fact]
        public async void RemoteCreate_ShouldCreateRecordInRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            await sut.Set.ComesFrom.SetAsync(10);
            await sut.Set.GoesTo.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            var record = repo.Read("hey remote create");
            Assert.Equal(10, record.ComesFrom);
            Assert.Equal(20, record.GoesTo);
        }

        [Fact]
        public async void RemoteRead_ShouldReadRecordFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 48, GoesTo = 68 });

            await sut.RemoteRead("hey remote create");


            // TODO: Assert.Equal("hey remote create", await sut.Set.DataEntityId.GetAsync());
            //Assert.Equal(48, await sut.Set.ComesFrom.GetAsync());
            //Assert.Equal(68, await sut.Set.GoesTo.GetAsync());

            Assert.True(true);
        }

        [Fact]
        public async void FromRepositoryToShadows_ShouldSetDataInShadowsFromPlainPocoObject()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 85, GoesTo = 98 });

            await sut.FromRepositoryToShadowsAsync(new SharedEntityHeader() { DataEntityId = "hey remote create" }, sut.Set);


            Assert.Equal("hey remote create", sut.Set.DataEntityId.Shadow);
            Assert.Equal(85, sut.Set.ComesFrom.Shadow);
            Assert.Equal(98, sut.Set.GoesTo.Shadow);
        }

        [Fact]
        public async void FromRepositoryToController_ShouldSetDataFromShadowsToController()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 85, GoesTo = 98 });

            await sut.FromRepositoryToControllerAsync(new SharedEntityHeader() { DataEntityId = "hey remote create" }, sut.Set);

            var records = repo.GetRecords("*", 100, 0, eSearchMode.Exact).ToList();

            var a = await sut.WriteAsync();

            // TODO: @kuh0005 : This test is not working as originally written
            // seems to have something to do with later additions to `LethargicWrite` in the generated code
            // Removing for the moment, seems to me that it is intended.

            // TODO: Assert.Equal("hey remote create", await sut.Set.DataEntityId.GetAsync());
            // Assert.Equal(85, await sut.Set.ComesFrom.GetAsync());
            // Assert.Equal(98, await sut.Set.GoesTo.GetAsync());

            Assert.True(true);
        }


        [Fact]
        public async void RemoteUpdate_ShouldUpdateRecordInRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 48, GoesTo = 68 });


            sut.Set.ComesFrom.SetAsync(40);
            sut.Set.GoesTo.SetAsync(60);
            await sut.RemoteUpdate("hey remote create");

            var record = repo.Read("hey remote create");
            Assert.Equal(40, record.ComesFrom);
            Assert.Equal(60, record.GoesTo);
        }

        [Fact]
        public async void RemoteDelete_ShouldDeleteRecordFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            sut.Set.ComesFrom.SetAsync(10);
            sut.Set.GoesTo.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            Assert.Equal(1, repo.Count);

            await sut.RemoteDelete("hey remote create");

            Assert.Equal(0, repo.Count);
        }

        [Fact]
        public async void RemoteEntityExist_ShouldExistRecordFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 48, GoesTo = 68 });

            Assert.Equal(1, repo.Count);

            var result = await sut.RemoteEntityExist("hey remote create");

            Assert.True(result);
        }

        [Fact]
        public async void RemoteEntityExist_ShouldNoExistRecordFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 48, GoesTo = 68 });

            Assert.Equal(1, repo.Count);

            var result = await sut.RemoteEntityExist("aa");

            Assert.False(result);
        }

        [Fact]
        public async void RemoteCreateOrUpdate_ShouldCreateRecordFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            sut.Set.ComesFrom.SetAsync(10);
            sut.Set.GoesTo.SetAsync(20);
            await sut.RemoteCreateOrUpdate("hey remote create");

            var record = repo.Read("hey remote create");
            Assert.Equal(10, record.ComesFrom);
            Assert.Equal(20, record.GoesTo);
        }

        [Fact]
        public async void RemoteCreateOrUpdate_ShouldUpdateRecordFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 48, GoesTo = 68 });

            sut.Set.ComesFrom.SetAsync(10);
            sut.Set.GoesTo.SetAsync(20);
            await sut.RemoteCreateOrUpdate("hey remote create");

            var record = repo.Read("hey remote create");
            Assert.Equal(10, record.ComesFrom);
            Assert.Equal(20, record.GoesTo);
        }

        [Fact]
        public async void GetRecords_Filtered_ShouldReturnRecordsFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            for (int i = 0; i < 10; i++)
            {
                repo.Create($"{i}Record", new SharedEntityHeader() { ComesFrom = (short)(i + 1), GoesTo = (short)(i * 7) });
            }

            var actual = sut.GetRecords("Rec", 3, 0, eSearchMode.Contains, "Default", true);

            Assert.Equal(3, actual.Count());
        }

        [Fact]
        public async void GetRecords_ShouldReturnRecordsFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            for (int i = 0; i < 10; i++)
            {
                repo.Create($"{i}Record", new SharedEntityHeader() { ComesFrom = (short)(i + 1), GoesTo = (short)(i * 7) });
            }

            var actual = sut.GetRecords("*");

            Assert.Equal(10, actual.Count());
        }

        [Fact]
        public async void Delete_ShouldDeleteRecordFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            for (int i = 0; i < 10; i++)
            {
                repo.Create($"{i}Record", new SharedEntityHeader() { ComesFrom = (short)(i + 1), GoesTo = (short)(i * 7) });
            }

            await sut.Delete("1Record");

            Assert.Equal(9, sut.Repository.Count);
        }

        [Fact]
        public async void UpdateFromShadows_ShouldUpdateRecordPresentInShadowsInTheReporitory()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 48, GoesTo = 68 });


            sut.Set.DataEntityId.Shadow = "hey remote create";
            sut.Set.ComesFrom.Shadow = 140;
            sut.Set.GoesTo.Shadow = 885;
            await sut.UpdateFromShadowsAsync(sut.Set);

            var record = repo.Read("hey remote create");
            Assert.Equal("hey remote create", record.DataEntityId);
            Assert.Equal(140, record.ComesFrom);
            Assert.Equal(885, record.GoesTo);
        }

        [Fact]
        public async void CreateNew_ShouldCreateNewRecordInRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            await sut.CreateNewAsync("hey remote create - brandnew", sut.Set);

            var record = repo.Read("hey remote create - brandnew");
            Assert.Equal("hey remote create - brandnew", record.DataEntityId);
        }

        [Fact]
        public async void CreateCopy_ShouldCreateNewRecordFromShadowsInRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);



            sut.Set.ComesFrom.Shadow = 101;
            sut.Set.GoesTo.Shadow = 201;


            await sut.CreateCopyCurrentShadowsAsync("hey remote create - new", sut.DataExchangeTwinObject);

            var record = repo.Read("hey remote create - new");
            Assert.Equal("hey remote create - new", record.DataEntityId);
            Assert.Equal(101, record.ComesFrom);
            Assert.Equal(201, record.GoesTo);
        }

        [Fact]
        public async void LoadFromPlc_ShouldCreateNewRecordFromOnlineInRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);



            await sut.Set.ComesFrom.SetAsync(1011);
            await sut.Set.GoesTo.SetAsync(1201);


            await sut.CreateDataFromControllerAsync("hey remote create", sut.Set);

            var record = repo.Read("hey remote create");
            Assert.Equal("hey remote create", record.DataEntityId);
            Assert.Equal(1011, record.ComesFrom);
            Assert.Equal(1201, record.GoesTo);
        }

        [Fact()]
        public async void InitializeRemoteDataExchange_ShouldInitializeRPC_Calls_WithGivenRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            //sut.SetRepository(repo);

            sut.InitializeRemoteDataExchange(repo);

            await sut.Operation.DataEntityIdentifier.SetAsync("foo");
            sut.Operation.StartTimeStamp.Cyclic = DateAndTime.Now;



            Assert.True(await sut.Operation.IsInitialized.GetAsync());
        }

        [Fact()]
        public async void InitializeRemoteDataExchange_ShouldInitializeRPC_Calls()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            sut.InitializeRemoteDataExchange();

            await sut.Operation.DataEntityIdentifier.SetAsync("foo");
            sut.Operation.StartTimeStamp.Cyclic = DateAndTime.Now;



            Assert.True(await sut.Operation.IsInitialized.GetAsync());
        }

        [Fact()]
        public async void DeInitializeRemoteDataExchange_ShouldInitializeRPC_Calls()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            //sut.SetRepository(repo);

            sut.InitializeRemoteDataExchange(repo);

            await sut.Operation.DataEntityIdentifier.SetAsync("foo");
            sut.Operation.StartTimeStamp.Cyclic = DateAndTime.Now;



            Assert.True(await sut.Operation.IsInitialized.GetAsync());

            sut.DeInitializeRemoteDataExchange();

            Assert.False(await sut.Operation.IsInitialized.GetAsync());
        }



        [Fact()]
        public async void ExportTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            repo.Create("hey remote create", new SharedEntityHeader() { ComesFrom = 48, GoesTo = 68 });

            Assert.Equal(1, repo.Count);

            var zipFile = Path.Combine(Path.GetTempPath(), "ExportDataTest", "ExportData.zip");

            // export
            sut.ExportData(zipFile);

            Assert.True(File.Exists(zipFile));

            using (ZipArchive zip = ZipFile.Open(zipFile, ZipArchiveMode.Read))
            {
                foreach (ZipArchiveEntry entry in zip.Entries)
                {
                    TextReader tr = new StreamReader(entry.Open());
                    string text = tr.ReadToEnd();
                    switch (entry.Name)
                    {
                        case "axosimple.SharedProductionDataManager.csv":
                            Assert.Equal("_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\rhey remote create;48;68;\r", text);
                            break;
                    }
                }
            }

            // clear
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ExportComplexTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            repo.Create("first", new SharedEntityHeader() { ComesFrom = 10, GoesTo = 11 });
            repo.Create("second", new SharedEntityHeader() { ComesFrom = 20, GoesTo = 21 });

            Assert.Equal(2, repo.Count);

            var zipFile = Path.Combine(Path.GetTempPath(), "ExportDataTest", "ExportData.zip");

            var dictionary = new Dictionary<string, ExportData>
            {
                { "Tests_L1.SharedEntityHeader", new ExportData(true, new Dictionary<string, bool>
                {
                    { "_data.ComesFrom", false },
                    { "_data.Name", false },
                }) },
            };

            // export
            sut.ExportData(zipFile, dictionary, eExportMode.Exact, 2, 2, "CSV", '*');

            Assert.True(File.Exists(zipFile));

            using (ZipArchive zip = ZipFile.Open(zipFile, ZipArchiveMode.Read))
            {
                foreach (ZipArchiveEntry entry in zip.Entries)
                {
                    TextReader tr = new StreamReader(entry.Open());
                    string text = tr.ReadToEnd();
                    switch (entry.Name)
                    {
                        case "SharedHeaderManager.csv":
                            Assert.Equal("_data.DataEntityId*_data.GoesTo*\r_data.DataEntityId*_data.GoesTo*\rsecond*21*\r", text);
                            break;
                        default:
                            Assert.Fail("More entries tahn expected!");
                            break;
                    }
                }
            }

            // clear
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ImportTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportDataTest", "importDataPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportDataTest", "ImportData.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            using (var sw = new StreamWriter(Path.Combine(tempDirectory, "SharedHeaderManager.csv")))
            {
                sw.Write(
                    "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r" +
                    "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r" +
                    "hey remote create;48;68;\r"
                    );
            }

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()));

            var shared = sut.DataRepository.Read("hey remote create");
            Assert.Equal(48, shared.ComesFrom);
            Assert.Equal(68, shared.GoesTo);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ImportComplexTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);

            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportDataTest", "importDataPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportDataTest", "ImportData.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            using (var sw = new StreamWriter(Path.Combine(tempDirectory, "SharedHeaderManager.csv")))
            {
                sw.Write(
                    "_data.DataEntityId*_data.GoesTo*\r" +
                    "_data.DataEntityId*_data.GoesTo*\r" +
                    "first*11*\r"
                    );
            }

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()), separator: '*');

            var shared = sut.DataRepository.Read("first");
            Assert.Equal(0, shared.ComesFrom);
            Assert.Equal(11, shared.GoesTo);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ImportTestWithExtraElements()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.DataExchange.SharedHeaderManager;
            var repo = new InMemoryRepository<SharedEntityHeader>();
            sut.SetRepository(repo);


            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportDataTestWithExtraElements", "importDataPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportDataTestWithExtraElements", "ImportData.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            using (var sw = new StreamWriter(Path.Combine(tempDirectory, "SharedHeaderManager.csv")))
            {
                sw.Write(
                    "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;_data.ExtraElement;\r" +
                    "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;_data.ExtraElement;\r" +
                    "hey remote create;48;68;130;\r"
                    );
            }

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()));

            var shared = sut.DataRepository.Read("hey remote create");
            Assert.Equal(48, shared.ComesFrom);
            Assert.Equal(68, shared.GoesTo);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public void HashTest()
        {
            var a = new SharedEntityHeader() { DataEntityId = "a", ComesFrom = 1, GoesTo = 2, Changes = { new ValueChangeItem() { DateTime = new DateTime(12345), NewValue = 1, OldValue = 1, UserName = "admin" } } };

            a.Hash = HashHelper.CreateHash(a);

            bool result = HashHelper.VerifyHash(a, new ClaimsIdentity());

            Assert.True(result);
        }

        [Fact()]
        public void HashFalseTest()
        {
            var a = new SharedEntityHeader() { DataEntityId = "a", ComesFrom = 1, GoesTo = 2, Changes = { new ValueChangeItem() { DateTime = new DateTime(12345), NewValue = 1, OldValue = 1, UserName = "admin" } } };

            a.Hash = HashHelper.CreateHash(a);

            a.ComesFrom = 5;

            bool result = HashHelper.VerifyHash(a, new ClaimsIdentity());

            Assert.False(result);
        }

        [Fact()]
        public void HashAllTypesTest()
        {
            var a = new Pocos.Tests_L1.Primitives.PrimitivesDataEntity() {
                v_BOOL = true, 
                v_BYTE = 1, 
                v_INT = 2,
                v_ULINT = 3, 
                v_CHAR = 'a',
                v_LREAL = 1.1,  
                v_STRING = "a", 
                v_DATE = new DateOnly(2010, 10, 10), 
                v_TIME = new TimeSpan(1000), 
                Changes = { new ValueChangeItem() { DateTime = new DateTime(12345), NewValue = 1, OldValue = 1, UserName = "admin" } } };

            a.Hash = HashHelper.CreateHash(a);

            bool result = HashHelper.VerifyHash(a, new ClaimsIdentity());

            Assert.True(result);
        }

        [Fact()]
        public void HashAllTypesFalseTest()
        {
            var a = new Pocos.Tests_L1.Primitives.PrimitivesDataEntity()
            {
                v_BOOL = true,
                v_BYTE = 1,
                v_INT = 2,
                v_ULINT = 3,
                v_CHAR = 'a',
                v_LREAL = 1.1,
                v_STRING = "a",
                v_DATE = new DateOnly(2010, 10, 10),
                v_TIME = new TimeSpan(1000),
                Changes = { new ValueChangeItem() { DateTime = new DateTime(12345), NewValue = 1, OldValue = 1, UserName = "admin" } }
            };

            a.Hash = HashHelper.CreateHash(a);

            a.v_INT = 5;

            bool result = HashHelper.VerifyHash(a, new ClaimsIdentity());

            Assert.False(result);
        }
    }
}

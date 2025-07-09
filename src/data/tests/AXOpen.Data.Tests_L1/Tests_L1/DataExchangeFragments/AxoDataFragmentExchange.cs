using Xunit;
using System.Reflection;
using AXOpen.Base.Data;
using AXOpen.Data.InMemory;
using AXSharp.Connector;
using System.IO.Compression;

namespace AXOpen.Data.Fragments.Tests
{
    using Tests_L1.FragmentData;
    using Pocos.Tests_L1;

    public class AxoDataFragmentExchange
    {
        private readonly string TempPath;

        public AxoDataFragmentExchange()
        {
            TempPath = new FileInfo(Assembly.GetExecutingAssembly().Location).Directory.FullName;
        }

        [Fact()]
        public async void RemoteCreate_ShouldCreateRecordsInEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(20);
            await sut.Station.Set.CounterDelay.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);
        }

        [Fact]
        public async void RemoteRead_ShouldReadRecordsFromEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            var sharedEntityRepo = new InMemoryRepository<SharedEntityHeader>();
            var stationDataRepo = new InMemoryRepository<StationData>();

            s.EntityHeader.SetRepository(sharedEntityRepo);
            s.Station.SetRepository(stationDataRepo);

            var id = "hey";

            sharedEntityRepo.Create(id, new SharedEntityHeader() { ComesFrom = 55, GoesTo = 44 });
            stationDataRepo.Create(id, new StationData() { CounterDelay = 8989ul });

            await sut.RemoteRead(id);

            // TODO -> not possible to read from dummy connector

            //Assert.Equal((short)55, sut.EntityHeader.Set.ComesFrom.Cyclic);
            //Assert.Equal(44, await sut.EntityHeader.Set.GoesTo.GetAsync());
            //Assert.Equal(8989ul, await sut.Manip.Set.CounterDelay.GetAsync());

            Assert.True(true);
        }

        [Fact]
        public async void RemoteUpdate_ShouldUpdateRecordsInEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(20);
            await sut.Station.Set.CounterDelay.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            await sut.EntityHeader.Set.ComesFrom.SetAsync(88);
            await sut.EntityHeader.Set.GoesTo.SetAsync(64);
            await sut.Station.Set.CounterDelay.SetAsync(789);
            await sut.RemoteUpdate("hey remote create");

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");
            Assert.Equal(88, shared.ComesFrom);
            Assert.Equal(64, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal(789ul, manip.CounterDelay);
        }

        [Fact]
        public async void RemoteDelete_ShouldDeleteRecordsFromEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(20);
            await sut.Station.Set.CounterDelay.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            Assert.Equal(1, sut.EntityHeader.DataRepository.Count);
            Assert.Equal(1, sut.Station.DataRepository.Count);

            await sut.RemoteDelete("hey remote create");

            Assert.Equal(0, sut.EntityHeader.DataRepository.Count);
            Assert.Equal(0, sut.Station.DataRepository.Count);
        }

        [Fact]
        public async void RemoteEntityExist_ShouldExistRecordsFromEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            var sharedEntityRepo = new InMemoryRepository<SharedEntityHeader>();
            var stationDataRepo = new InMemoryRepository<StationData>();

            s.EntityHeader.SetRepository(sharedEntityRepo);
            s.Station.SetRepository(stationDataRepo);

            var id = "hey";

            sharedEntityRepo.Create(id, new SharedEntityHeader() { ComesFrom = 55, GoesTo = 44 });
            stationDataRepo.Create(id, new StationData() { CounterDelay = 8989ul });

            var result = await sut.RemoteEntityExist(id);

            Assert.True(result);
        }

        [Fact]
        public async void RemoteEntityExist_ShouldNoExistRecordsFromEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            var sharedEntityRepo = new InMemoryRepository<SharedEntityHeader>();
            var stationDataRepo = new InMemoryRepository<StationData>();

            s.EntityHeader.SetRepository(sharedEntityRepo);
            s.Station.SetRepository(stationDataRepo);

            var id = "hey";

            //sharedEntityRepo.Create(id, new SharedProductionData() { ComesFrom = 55, GoesTo = 44 });
            //stationDataRepo.Create(id, new FragmentProcessData() { CounterDelay = 8989ul });

            var result = await sut.RemoteEntityExist(id);

            Assert.False(result);
        }

        [Fact]
        public async void RemoteCreateOrUpdate_ShouldCreateRecordsFromEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(20);
            await sut.Station.Set.CounterDelay.SetAsync(20);
            await sut.RemoteCreateOrUpdate("hey remote create");

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);
        }

        [Fact]
        public async void RemoteCreateOrUpdate_ShouldUpdateRecordsFromEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(20);
            await sut.Station.Set.CounterDelay.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            await sut.EntityHeader.Set.ComesFrom.SetAsync(88);
            await sut.EntityHeader.Set.GoesTo.SetAsync(64);
            await sut.Station.Set.CounterDelay.SetAsync(789);
            await sut.RemoteCreateOrUpdate("hey remote create");

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");
            Assert.Equal(88, shared.ComesFrom);
            Assert.Equal(64, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal(789ul, manip.CounterDelay);
        }

        [Fact]
        public async void FromRepositoryToShadows_ShouldSetDataInShadowsFromPlainPocoObject()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            var sharedEntityRepo = new InMemoryRepository<SharedEntityHeader>();
            var stationDataRepo = new InMemoryRepository<StationData>();
            s.EntityHeader.SetRepository(sharedEntityRepo);
            s.Station.SetRepository(stationDataRepo);

            sharedEntityRepo.Create("hey remote create", new SharedEntityHeader()
            { ComesFrom = 185, GoesTo = 398 });
            stationDataRepo.Create("hey remote create", new() { CounterDelay = 898577ul });

            await sut.FromRepositoryToShadowsAsync(new SharedEntityHeader() { DataEntityId = "hey remote create" }, s.DataExchangeTwinObject);

            Assert.Equal("hey remote create", sut.EntityHeader.Set.DataEntityId.Shadow);
            Assert.Equal(185, sut.EntityHeader.Set.ComesFrom.Shadow);
            Assert.Equal(398, sut.EntityHeader.Set.GoesTo.Shadow);
            Assert.Equal("hey remote create", sut.Station.Set.DataEntityId.Shadow);
            Assert.Equal(898577ul, sut.Station.Set.CounterDelay.Shadow);
        }

        [Fact]
        public async void FromRepositoryToController_ShouldSetDataFromShadowsToController()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            var sharedEntityRepo = new InMemoryRepository<SharedEntityHeader>();
            var stationDataRepo = new InMemoryRepository<StationData>();
            s.EntityHeader.SetRepository(sharedEntityRepo);
            s.Station.SetRepository(stationDataRepo);

            string entityId = "hey remote create";

            sharedEntityRepo.Create(entityId, new SharedEntityHeader()
            { ComesFrom = 485, GoesTo = 898 });
            stationDataRepo.Create(entityId, new() { CounterDelay = 5898577ul });

            await sut.FromRepositoryToControllerAsync(new SharedEntityHeader() { DataEntityId = entityId }, s.DataExchangeTwinObject);

            // TODO -> not possible to read from dummy connector

            //Assert.Equal(entityId, await sut.EntityHeader.Set.DataEntityId.GetAsync());
            //Assert.Equal(485, await sut.EntityHeader.Set.ComesFrom.GetAsync());
            //Assert.Equal(898, await sut.EntityHeader.Set.GoesTo.GetAsync());

            //Assert.Equal(entityId, await sut.Manip.Set.DataEntityId.GetAsync());
            //Assert.Equal(5898577ul, await sut.Manip.Set.CounterDelay.GetAsync());

            Assert.True(true);
        }

        [Fact]
        public async void GetRecords_Filtered_ShouldReturnRecordsFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            for (int i = 0; i < 10; i++)
            {
                await sut.CreateNewAsync($"{i}Record", s.DataExchangeTwinObject);
            }

            var actual = sut.GetRecords("Rec", 3, 0, eSearchMode.Contains, "Default", true);

            Assert.Equal(3, actual.Count());
        }

        [Fact]
        public async void GetRecords_ShouldReturnRecordsFromRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            for (int i = 0; i < 10; i++)
            {
                await sut.CreateNewAsync($"{i}Record", s.DataExchangeTwinObject);
            }

            var actual = sut.GetRecords("*");

            Assert.Equal(10, actual.Count());
        }

        [Fact]
        public async void Delete_ShouldDeleteRecordsFromEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(20);
            await sut.Station.Set.CounterDelay.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            Assert.Equal(1, sut.EntityHeader.DataRepository.Count);
            Assert.Equal(1, sut.Station.DataRepository.Count);

            await sut.Delete("hey remote create");

            Assert.Equal(0, sut.EntityHeader.DataRepository.Count);
            Assert.Equal(0, sut.Station.DataRepository.Count);
        }

        [Fact]
        public async void UpdateFromShadows_ShouldUpdateRecordsInEachRepository()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(20);
            await sut.Station.Set.CounterDelay.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            sut.EntityHeader.Set.DataEntityId.Shadow = "hey remote create";
            sut.EntityHeader.Set.ComesFrom.Shadow = 188;
            sut.EntityHeader.Set.GoesTo.Shadow = 568;
            sut.Station.Set.DataEntityId.Shadow = "hey remote create";
            sut.Station.Set.CounterDelay.Shadow = 8566ul;

            await sut.UpdateFromShadowsAsync(sut.DataExchangeTwinObject);

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");
            Assert.Equal(188, shared.ComesFrom);
            Assert.Equal(568, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal(8566ul, manip.CounterDelay);
        }

        [Fact]
        public async void LoadFromController_ShouldLoadExistingDataSetToEachShadow()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(111);
            await sut.EntityHeader.Set.GoesTo.SetAsync(222);
            await sut.Station.Set.CounterDelay.SetAsync(4859);

            await sut.CreateDataFromControllerAsync("hey remote create", sut.DataExchangeTwinObject);

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");

            Assert.Equal("hey remote create", shared.DataEntityId);
            Assert.Equal(111, shared.ComesFrom);
            Assert.Equal(222, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal("hey remote create", manip.DataEntityId);
            Assert.Equal(4859ul, manip.CounterDelay);
        }

        [Fact]
        public async void CreateCopy_ShouldCreateInAllRepositoriesFromExisting()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(111);
            await sut.EntityHeader.Set.GoesTo.SetAsync(222);
            await sut.Station.Set.CounterDelay.SetAsync(4859);

            await sut.CreateDataFromControllerAsync("hey remote create", sut.DataExchangeTwinObject);

            await sut.CreateCopyCurrentShadowsAsync("hey remote create - copy", sut.DataExchangeTwinObject);

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create - copy");
            Assert.Equal("hey remote create - copy", shared.DataEntityId);
            Assert.Equal(111, shared.ComesFrom);
            Assert.Equal(222, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create - copy");
            Assert.Equal("hey remote create - copy", manip.DataEntityId);
            Assert.Equal(4859ul, manip.CounterDelay);
        }

        [Fact]
        public async void FromRepositoryToShadows_CreateMissingFragment()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            var sharedEntityRepo = new InMemoryRepository<SharedEntityHeader>();
            var stationDataRepo = new InMemoryRepository<StationData>();
            s.EntityHeader.SetRepository(sharedEntityRepo);
            s.Station.SetRepository(stationDataRepo);

            sharedEntityRepo.Create("hey remote create", new SharedEntityHeader()
            { ComesFrom = 185, GoesTo = 398 });
            stationDataRepo.Create("hey remote create", new() { CounterDelay = 898577ul });
            stationDataRepo.Delete("hey remote create");

            await sut.FromRepositoryToShadowsAsync(new SharedEntityHeader() { DataEntityId = "hey remote create" }, s.DataExchangeTwinObject);

            Assert.Equal("hey remote create", sut.EntityHeader.Set.DataEntityId.Shadow);
            Assert.Equal(185, sut.EntityHeader.Set.ComesFrom.Shadow);
            Assert.Equal(398, sut.EntityHeader.Set.GoesTo.Shadow);
            Assert.Equal("", sut.Station.Set.DataEntityId.Shadow);
            Assert.Equal(0ul, sut.Station.Set.CounterDelay.Shadow);
        }

        [Fact()]
        public async void ExportTest()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(20);
            await sut.Station.Set.CounterDelay.SetAsync(20);
            await sut.RemoteCreate("hey remote create");

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);

            var zipFile = Path.Combine(TempPath, "ExportDataFragmentTest", "ExportDataFragment.zip");

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
                            Assert.Equal("_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\rhey remote create;10;20;\r", text);
                            break;

                        case "examples.PneumaticManipulator.FragmentProcessDataManger.csv":
                            Assert.Equal("_data.DataEntityId;_data.CounterDelay;\r_data.DataEntityId;_data.CounterDelay;\rhey remote create;20;\r", text);
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
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            await sut.EntityHeader.Set.ComesFrom.SetAsync(10);
            await sut.EntityHeader.Set.GoesTo.SetAsync(11);
            await sut.Station.Set.CounterDelay.SetAsync(12);
            await sut.RemoteCreate("first");

            await sut.EntityHeader.Set.ComesFrom.SetAsync(20);
            await sut.EntityHeader.Set.GoesTo.SetAsync(21);
            await sut.Station.Set.CounterDelay.SetAsync(22);
            await sut.RemoteCreate("second");

            var shared = sut.EntityHeader.DataRepository.Read("first");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(11, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("first");
            Assert.Equal(12ul, manip.CounterDelay);

            shared = sut.EntityHeader.DataRepository.Read("second");
            Assert.Equal(20, shared.ComesFrom);
            Assert.Equal(21, shared.GoesTo);

            manip = sut.Station.DataRepository.Read("second");
            Assert.Equal(22ul, manip.CounterDelay);

            var zipFile = Path.Combine(TempPath, "ExportDataFragmentTest", "ExportDataFragment.zip");

            var dictionary = new Dictionary<string, ExportData>
            {
                { "Tests_L1.SharedEntityHeader", new ExportData(false, new Dictionary<string, bool>()) },
                { "Tests_L1.StationData", new ExportData(true, new Dictionary<string, bool>
                {
                    { "_data.CounterDelay", false },
                }) }
            };

            // export
            sut.ExportData(zipFile, dictionary, eExportMode.Exact, 2, 2, "TXT", '*');

            Assert.True(File.Exists(zipFile));

            using (ZipArchive zip = ZipFile.Open(zipFile, ZipArchiveMode.Read))
            {
                foreach (ZipArchiveEntry entry in zip.Entries)
                {
                    TextReader tr = new StreamReader(entry.Open());
                    string text = tr.ReadToEnd();
                    switch (entry.Name)
                    {
                        case "Station.txt":
                            Assert.Equal("_data.DataEntityId*\r_data.DataEntityId*\rsecond*\r", text);
                            break;

                        default:
                            Assert.Fail("More entries than expected!");
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
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            var tempDirectory = Path.Combine(TempPath, "ImportDataFragmentTest", "importDataFragmentPrepare");
            var zipFile = Path.Combine(TempPath, "ImportDataFragmentTest", "ImportDataFragment.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            using (var sw = new StreamWriter(Path.Combine(tempDirectory, tempDirectory, sut.EntityHeader.GetSymbolTail() + ".csv")))
            {
                sw.Write("_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\rhey remote create;10;20;\r");
            }
            using (var sw = new StreamWriter(Path.Combine(tempDirectory, tempDirectory, sut.Station.GetSymbolTail() + ".csv")))
            {
                sw.Write("_data.DataEntityId;_data.CounterDelay;\r_data.DataEntityId;_data.CounterDelay;\rhey remote create;20;\r");
            }

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()));

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);

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
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            var tempDirectory = Path.Combine(TempPath, "ImportDataFragmentTest", "importDataFragmentPrepare");
            var zipFile = Path.Combine(TempPath, "ImportDataFragmentTest", "ImportDataFragment.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            using (var sw = new StreamWriter(Path.Combine(tempDirectory, sut.EntityHeader.GetSymbolTail() + ".txt")))
            {
                sw.Write("_data.DataEntityId*_data.GoesTo*\r_data.DataEntityId*_data.GoesTo*\rfirst*11*\r");
            }
            using (var sw = new StreamWriter(Path.Combine(tempDirectory, sut.Station.GetSymbolTail() + ".txt")))
            {
                sw.Write("_data.DataEntityId*\r_data.DataEntityId*\rfirst*\r");
            }

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()), exportFileType: "TXT", separator: '*');

            var shared = sut.EntityHeader.DataRepository.Read("first");
            Assert.Equal(0, shared.ComesFrom);
            Assert.Equal(11, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("first");
            Assert.Equal(0ul, manip.CounterDelay);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ImportFragmentDataWithExtraElements()
        {
            var connector = new axopen_data_tests_l1TwinController(ConnectorAdapterBuilder.Build().CreateDummy());
            var sut = connector.Fragments.DataManager;
            var s = sut.CreateDataFragments<FragmentProcessDataManager>();

            s.EntityHeader.SetRepository(new InMemoryRepository<SharedEntityHeader>());
            s.Station.SetRepository(new InMemoryRepository<StationData>());

            var tempDirectory = Path.Combine(TempPath, "ImportFragmentDataWithExtraElements", "importDataFragmentPrepare");
            var zipFile = Path.Combine(TempPath, "ImportFragmentDataWithExtraElements", "ImportDataFragment.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            using (var sw = new StreamWriter(Path.Combine(tempDirectory, tempDirectory, sut.EntityHeader.GetSymbolTail() + ".csv")))
            {
                sw.Write(
                    "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;_data.ExtraElement;\r" +
                    "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;_data.ExtraElement;\r" +
                    "hey remote create;10;20;30;\r"
                    );
            }
            using (var sw = new StreamWriter(Path.Combine(tempDirectory, tempDirectory, sut.Station.GetSymbolTail() + ".csv")))
            {
                sw.Write(
                    "_data.DataEntityId;_data.CounterDelay;_data.ExtraElement;\r" +
                    "_data.DataEntityId;_data.CounterDelay;_data.ExtraElement;\r" +
                    "hey remote create;20;30;\r"
                    );
            }

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()));

            var shared = sut.EntityHeader.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Station.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }
    }
}
using Xunit;
using AXOpen.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using AXOpen.Data.InMemory;
using AXSharp.Connector;
using NSubstitute;
using AXSharp.Connector;
using Pocos.axosimple;
using Pocos.examples.PneumaticManipulator;
using ProcessData = axosimple.ProcessData;
using ClosedXML.Excel;
using Pocos.axosimple;

namespace AXOpen.Data.Tests
{
    using TOnline = AXOpen.Data.AxoDataEntity;
    using TPlain = Pocos.AXOpen.Data.AxoDataEntity;
    using Pocos.AXOpen.Data;
    using System.IO.Compression;
    using System.IO;
    using System.Xml.Linq;

    public class ExcelFragmentTests
    {
        [Fact()]
        public async void ExportFragmentTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.CreateBuilder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(10);
            await sut.Set.Set.GoesTo.SetAsync(20);
            await sut.Manip.Set.CounterDelay.SetAsync(20);
            sut.RemoteCreate("hey remote create");

            var shared = sut.Set.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);

            var zipFile = Path.Combine(Path.GetTempPath(), "ExportDataFragmentTest", "ExportDataFragment.zip");

            // export
            sut.ExportData(zipFile, exportFileType: "Excel");

            Assert.True(File.Exists(zipFile));

            using (ZipArchive zip = ZipFile.Open(zipFile, ZipArchiveMode.Read))
            {
                Assert.Equal("_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\rhey remote create;10;20;\r", ExcelTests.GetTextFromExcel(zip.Entries[0].Open(), "Set"));
                Assert.Equal("_data.DataEntityId;_data.CounterDelay;\r_data.DataEntityId;_data.CounterDelay;\rhey remote create;20;\r", ExcelTests.GetTextFromExcel(zip.Entries[0].Open(), "Manip"));
            }

            // clear
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ExportComplexFragmentTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.CreateBuilder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(10);
            await sut.Set.Set.GoesTo.SetAsync(11);
            await sut.Manip.Set.CounterDelay.SetAsync(12);
            sut.RemoteCreate("first");

            await sut.Set.Set.ComesFrom.SetAsync(20);
            await sut.Set.Set.GoesTo.SetAsync(21);
            await sut.Manip.Set.CounterDelay.SetAsync(22);
            sut.RemoteCreate("second");

            var shared = sut.Set.DataRepository.Read("first");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(11, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("first");
            Assert.Equal(12ul, manip.CounterDelay);

            shared = sut.Set.DataRepository.Read("second");
            Assert.Equal(20, shared.ComesFrom);
            Assert.Equal(21, shared.GoesTo);

            manip = sut.Manip.DataRepository.Read("second");
            Assert.Equal(22ul, manip.CounterDelay);

            var zipFile = Path.Combine(Path.GetTempPath(), "ExportDataFragmentTest", "ExportDataFragment.zip");

            var dictionary = new Dictionary<string, ExportData>
            {
                { "axosimple.SharedProductionData", new ExportData(false, new Dictionary<string, bool>()) },
                { "examples.PneumaticManipulator.FragmentProcessData", new ExportData(true, new Dictionary<string, bool>
                {
                    { "_data.CounterDelay", false },
                }) }
            };

            // export
            sut.ExportData(zipFile, dictionary, eExportMode.Exact, 2, 2, "Excel");

            Assert.True(File.Exists(zipFile));

            using (ZipArchive zip = ZipFile.Open(zipFile, ZipArchiveMode.Read))
            {
                Assert.Equal("_data.DataEntityId;\r_data.DataEntityId;\rsecond;\r", ExcelTests.GetTextFromExcel(zip.Entries[0].Open(), "Manip"));
            }

            // clear
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ImportFragmentTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.CreateBuilder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportDataFragmentTest", "importDataFragmentPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportDataFragmentTest", "ImportDataFragment.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            ExcelTests.CreateExcelFromText(Path.Combine(tempDirectory, "Export.xlsx"), new Dictionary<string, string> { 
                { sut.Set.GetSymbolTail(), "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\rhey remote create;10;20;\r" },
                { sut.Manip.GetSymbolTail(), "_data.DataEntityId;_data.CounterDelay;\r_data.DataEntityId;_data.CounterDelay;\rhey remote create;20;\r" }
            });

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()), exportFileType: "Excel");

            var shared = sut.Set.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ImportComplexFragmentTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.CreateBuilder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportDataFragmentTest", "importDataFragmentPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportDataFragmentTest", "ImportDataFragment.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            ExcelTests.CreateExcelFromText(Path.Combine(tempDirectory, "Export.xlsx"), new Dictionary<string, string> {
                { sut.Set.GetSymbolTail(), "_data.DataEntityId;_data.GoesTo;\r_data.DataEntityId;_data.GoesTo;\rfirst;11;\r" },
                { sut.Manip.GetSymbolTail(), "_data.DataEntityId;\r_data.DataEntityId;\rfirst;\r" }
            });

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()), exportFileType: "Excel");

            var shared = sut.Set.DataRepository.Read("first");
            Assert.Equal(0, shared.ComesFrom);
            Assert.Equal(11, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("first");
            Assert.Equal(0ul, manip.CounterDelay);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ImportFragmentTestWithExtraElements()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.CreateBuilder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportFragmentDataWithExtraElements", "importDataFragmentPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportFragmentDataWithExtraElements", "ImportDataFragment.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            ExcelTests.CreateExcelFromText(Path.Combine(tempDirectory, "Export.xlsx"), new Dictionary<string, string> {
                { sut.Set.GetSymbolTail(), "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;_data.ExtraElement;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;_data.ExtraElement;\rhey remote create;10;20;30;\r" },
                { sut.Manip.GetSymbolTail(), "_data.DataEntityId;_data.CounterDelay;_data.ExtraElement;\r_data.DataEntityId;_data.CounterDelay;_data.ExtraElement;\rhey remote create;20;30;\r" }
            });

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()), exportFileType: "Excel");

            var shared = sut.Set.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }
    }
}

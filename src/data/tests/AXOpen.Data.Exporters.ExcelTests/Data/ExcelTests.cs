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
using Microsoft.VisualBasic;
using ClosedXML.Excel;
using Pocos.axosimple;

namespace AXOpen.Data.Tests
{
    using TOnline = AXOpen.Data.AxoDataEntity;
    using TPlain = Pocos.AXOpen.Data.AxoDataEntity;
    using Pocos.AXOpen.Data;
    using System.IO.Compression;
    using System.Xml.Linq;
    using System.IO;
    using System.Security.Claims;
    using DocumentFormat.OpenXml.Spreadsheet;
    using DocumentFormat.OpenXml.Wordprocessing;

    public class ExcelTests
    {

        public static string GetTextFromExcel(Stream stream, string sheet)
        {
            using var wbook = new XLWorkbook(stream);

            var ws = wbook.Worksheets.Where(w => w.Name == sheet);

            Assert.Equal(1, ws.Count());

            string text = "";

            foreach (var row in ws.First().RangeUsed().RowsUsed())
            {
                foreach (var cell in row.CellsUsed())
                {
                    text += cell.GetString() + ';';
                }

                text += '\r';
            }

            return text;
        }

        public static void CreateExcelFromText(string path, Dictionary<string, string> sheets)
        {
            using var wbook = new XLWorkbook();

            foreach (var sheet in sheets)
            {
                var ws = wbook.Worksheets.Add(sheet.Key);

                string[] rows = sheet.Value.Split('\r');

                for (int i = 0; i < rows.Length; i++)
                {
                    string[] cells = rows[i].Split(';');

                    for (int j = 0; j < cells.Length; j++)
                    {
                        ws.Row(i + 1).Cell(j + 1).Value = cells[j];
                    }
                }
            }

            wbook.SaveAs(path);
        }

        [Fact()]
        public async void ExportTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            repo.Create("hey remote create", new Pocos.axosimple.SharedProductionData() { ComesFrom = 48, GoesTo = 68 });

            Assert.Equal(1, repo.Count);

            var zipFile = Path.Combine(Path.GetTempPath(), "ExportDataTest", "ExportData.zip");

            // export
            sut.ExportData(zipFile, exportFileType: "Excel");

            Assert.True(File.Exists(zipFile));

            using (ZipArchive zip = ZipFile.Open(zipFile, ZipArchiveMode.Read))
            {
                Assert.Equal("_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\rhey remote create;48;68;\r", GetTextFromExcel(zip.Entries[0].Open(), "b"));
            }

            // clear
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ExportComplexTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            repo.Create("first", new Pocos.axosimple.SharedProductionData() { ComesFrom = 10, GoesTo = 11 });
            repo.Create("second", new Pocos.axosimple.SharedProductionData() { ComesFrom = 20, GoesTo = 21 });

            Assert.Equal(2, repo.Count);

            var zipFile = Path.Combine(Path.GetTempPath(), "ExportDataTest", "ExportData.zip");

            var dictionary = new Dictionary<string, ExportData>
            {
                { "axosimple.SharedProductionData", new ExportData(true, new Dictionary<string, bool>
                {
                    { "_data.ComesFrom", false },
                }) },
            };

            // export
            sut.ExportData(zipFile, dictionary, eExportMode.Exact, 2, 2, "Excel");

            Assert.True(File.Exists(zipFile));

            using (ZipArchive zip = ZipFile.Open(zipFile, ZipArchiveMode.Read))
            {
                Assert.Equal("_data.DataEntityId;_data.GoesTo;\r_data.DataEntityId;_data.GoesTo;\rsecond;21;\r", GetTextFromExcel(zip.Entries[0].Open(), "b"));
            }

            // clear
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }

        [Fact()]
        public async void ImportTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportDataTest", "importDataPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportDataTest", "ImportData.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            CreateExcelFromText(Path.Combine(tempDirectory, "Export.xlsx"), new Dictionary<string, string> { { "b", "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;\rhey remote create;48;68;\r" } });

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()), exportFileType: "Excel");

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
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportDataTest", "importDataPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportDataTest", "ImportData.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            CreateExcelFromText(Path.Combine(tempDirectory, "Export.xlsx"), new Dictionary<string, string> { { "b", "_data.DataEntityId;_data.GoesTo;\r_data.DataEntityId;_data.GoesTo;\rfirst;11;\r" } });

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()), exportFileType: "Excel");

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
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            var tempDirectory = Path.Combine(Path.GetTempPath(), "ImportDataTestWithExtraElements", "importDataPrepare");
            var zipFile = Path.Combine(Path.GetTempPath(), "ImportDataTestWithExtraElements", "ImportData.zip");

            Directory.CreateDirectory(tempDirectory);

            File.Delete(zipFile);

            CreateExcelFromText(Path.Combine(tempDirectory, "Export.xlsx"), new Dictionary<string, string> { { "b", "_data.DataEntityId;_data.ComesFrom;_data.GoesTo;_data.ExtraElement;\r_data.DataEntityId;_data.ComesFrom;_data.GoesTo;_data.ExtraElement;\rhey remote create;48;68;130;\r" } });

            ZipFile.CreateFromDirectory(tempDirectory, zipFile);

            // import
            sut.ImportData(zipFile, new Microsoft.AspNetCore.Components.Authorization.AuthenticationState(new System.Security.Claims.ClaimsPrincipal()), exportFileType: "Excel");

            var shared = sut.DataRepository.Read("hey remote create");
            Assert.Equal(48, shared.ComesFrom);
            Assert.Equal(68, shared.GoesTo);

            // clear
            if (Directory.Exists(tempDirectory))
                Directory.Delete(tempDirectory, true);
            if (File.Exists(zipFile))
                File.Delete(zipFile);
        }
    }
}

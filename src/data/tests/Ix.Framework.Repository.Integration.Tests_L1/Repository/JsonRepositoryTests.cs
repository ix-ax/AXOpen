using NUnit.Framework;
using System;
using System.IO;
using System.Reflection;
using Ix.Base.Data;
using AXOpen.Data;
using AXOpen.Data.Json;
using Ix.Repository.Json;

namespace Ix.Framework.Repository.Integration.Tests
{
    [TestFixture()]
    public class JsonFileRepositoryTests : RepositoryBaseTests
    { 
        string outputDir = Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory.FullName, "JsonRepositoryTestOutputDir");
     
        public override void Init()
        {
            if (Directory.Exists(outputDir))
            {
                Directory.Delete(outputDir, true);
            }

            this.repository = new JsonRepository<DataTestObject>(new JsonRepositorySettings<DataTestObject>(outputDir));
            this.repository_altered_structure = new JsonRepository<DataTestObjectAlteredStructure>(new JsonRepositorySettings<DataTestObjectAlteredStructure>(outputDir));

            this.repository.OnCreate = (id, data) => { data._Created = DateTimeProviders.DateTimeProvider.Now; data._Modified = DateTimeProviders.DateTimeProvider.Now; };
            this.repository.OnUpdate = (id, data) => { data._Modified = DateTimeProviders.DateTimeProvider.Now; };
        }
    }
}
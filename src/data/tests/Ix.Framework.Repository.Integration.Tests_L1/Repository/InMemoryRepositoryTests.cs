using NUnit.Framework;
using System;
using Ix.Base.Data;
using Ix.Framework.Data;
using Ix.Framework.Data.InMemory;

namespace Ix.Framework.Repository.Integration.Tests
{
    [TestFixture()]
    public class InMemoryRepositoryTests : RepositoryBaseTests
    {        
        
        public override void Init()
        {
            
            this.repository = Data.InMemory.Repository.Factory<DataTestObject>(new InMemoryRepositorySettings<DataTestObject>());
            this.repository_altered_structure = Data.InMemory.Repository.Factory<DataTestObjectAlteredStructure>(new InMemoryRepositorySettings<DataTestObjectAlteredStructure>());
            this.repository.OnCreate = (id, data) => { data._Created = DateTimeProviders.DateTimeProvider.Now; data._Modified = DateTimeProviders.DateTimeProvider.Now; };
            this.repository.OnUpdate = (id, data) => { data._Modified = DateTimeProviders.DateTimeProvider.Now; };
        }
    }
}
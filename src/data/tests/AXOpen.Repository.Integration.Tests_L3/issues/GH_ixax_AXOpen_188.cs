using AXOpen.Base.Data;
using AXOpen.Data;
using AXOpen.Data.MongoDb;
using AXSharp.Connector;
using NUnit.Framework;
using System;
using System.Collections.Generic;

namespace AXOpen.Repository.Integration.Tests
{
    public class GH_ixax_AXOpen_188
    {
        private MongoDbRepository<TestStruct> repository = new (new MongoDbRepositorySettings<TestStruct>("mongodb://localhost:27017", "test", "TestStruct"));

        [Test()]
        public void MongoDbRepositoryCRUDTest()
        {
            repository.Create("a", new TestStruct { _EntityId = "a" });
            Assert.That(1, Is.EqualTo(repository.Count));

            var read = repository.Read("a");
            Assert.That(new DateOnly(1, 1, 1), Is.EqualTo(read.DateOnly));

            read.DateOnly = new DateOnly(2010, 10, 10);
            read.Changes.Add(new ValueChangeItem { DateTime = DateTime.Now, UserName = "a", ValueTag = new ValueItemDescriptor { HumanReadable = "DateOnly", Symbol = "DateOnly" }, OldValue = new DateOnly(1, 1, 1), NewValue = new DateOnly(2010, 10, 10) });

            repository.Update("a", read);
            Assert.That(1, Is.EqualTo(repository.Count));

            read = repository.Read("a");
            Assert.That(new DateOnly(2010, 10, 10), Is.EqualTo(read.DateOnly));

            repository.Delete("a");
        }

        [TearDown]
        public virtual void TearDown()
        {
            repository.Collection.Database.DropCollection("TestStruct");
        }
    }

    public class TestStruct : IBrowsableDataObject
    {
        public dynamic RecordId { get; set; }
        public string _EntityId { get; set; }
        public List<ValueChangeItem> Changes { get; set; } = new();
        public DateOnly DateOnly { get; set; }
    }
}

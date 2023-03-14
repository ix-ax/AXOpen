using IntegrationTests;
using intergrations;
using Ix.Base.Data;
using Ix.Connector;
using Ix.Framework.Data.Json;
using Ix.Framework.Data.InMemory;



namespace integrations.data
{

    using System;
    using Xunit;

    public class DataExchangeTest
    {
        private DataExchangeTestsContext testContext = Entry.Plc.Integrations.DataExchangeTestsContext;
        private IRepository<Pocos.IntegrationTests.DataSet> repository;
        public DataExchangeTest()
        {
            
            repository = Repository.Factory<Pocos.IntegrationTests.DataSet>(new());

            testContext.Create.Manager
                .InitializeRemoteDataExchange
                    (repository);
                
        }

        [Fact]
        public async Task ProbeWithCounterExecutesTest()
        {
            //--Arrange
            var sut = testContext.Create;
            var identifier = "hello-id";
            await sut.Identifier.SetAsync(identifier);

            await sut.Manager.CreateTask.DataEntityIdentifier.SetAsync(identifier);
           // await sut.Manager.CreateTask.RemoteInvoke.SetAsync(true);

            //-- Act
            await sut.RunTest();

            //-- Assert
            Assert.NotNull(repository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier));
        }
    }
}
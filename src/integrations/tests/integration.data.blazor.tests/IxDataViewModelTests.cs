using intergrations;
using ix.framework.core.Interfaces;
using ix.framework.core.ViewModels;
using ix.framework.data;
using AXSharp.Connector;
using Ix.Framework.Data.InMemory;

namespace integration.data.blazor.tests
{
    public class IxDataViewModelTests
    {

        private static integrationsTwinController _plc { get; }
        = new(ConnectorAdapterBuilder.Build()
            .CreateDummy());

        private IDataViewModel _vm;
        public IxDataViewModelTests()
        {
          
            var dataObject = _plc.process_data_manager; 

            var repo = Ix.Framework.Data.InMemory.Repository.Factory(new InMemoryRepositorySettings<Pocos.ixDataExamples.IxProductionData>());
            dataObject.InitializeRepository(repo);

            var data = dataObject.Data;

            var exchangeViewModel = new DataExchangeBaseViewModel{ 
                Model = dataObject,
                };
            _vm = exchangeViewModel.DataViewModel;
            
        }
        [Fact]
        public void test_DataViewModel_NotNull()
        {
            Assert.NotNull(_vm);
        }

        [Fact]
        public void test_DataViewModel_Create()
        {
            //arrange
            var id = "createId";
            _vm.CreateItemId=id;

            //act
            _vm.CreateNew();

            //assert
            var record = _vm.Records.FirstOrDefault(p=> p.DataEntityId == id);
            Assert.NotNull(record);
            Assert.Equal(id, record.DataEntityId);
          
        }

        [Fact]
        public void test_DataViewModel_Delete()
        {
            //arrange
            var id = "testDelete";
            _vm.CreateItemId=id;

            //act
            _vm.CreateNew();
            var record = _vm.Records.FirstOrDefault(p=> p.DataEntityId == id);

            _vm.SelectedRecord = new Pocos.ixDataExamples.IxProductionData
            {
                DataEntityId=record.DataEntityId
            };
           _vm.Delete();

            //assert
            var recordNull = _vm.Records.FirstOrDefault(p=> p.DataEntityId == id);
            Assert.Null(recordNull);
          
        }

        [Fact]
        public void test_DataViewModel_Edit()
        {
            //arrange
            var id = "testEdit";
            var recipe = "recipeName";
            _vm.CreateItemId=id;

            //act
            _vm.CreateNew();
            var record = _vm.Records.FirstOrDefault(p=> p.DataEntityId == id);

             _vm.SelectedRecord = new Pocos.ixDataExamples.IxProductionData
            {
                DataEntityId=record.DataEntityId,
                RecipeName=recipe
            };
            
           _vm.Edit();

            //assert
            var foundRecord = _vm.Records.FirstOrDefault(p=> p.DataEntityId == id);
            Assert.NotNull(foundRecord);
            Assert.Equal(recipe,((Pocos.ixDataExamples.IxProductionData)foundRecord).RecipeName);
          
        }

        [Fact]
        public void test_DataViewModel_Copy()
        {
             //arrange
            var id = "testCopy";
            _vm.CreateItemId=id;
            _vm.SelectedRecord = new Pocos.ixDataExamples.IxProductionData
            {
                DataEntityId=id,
            };
            var copyId = $"Copy of {_vm.SelectedRecord.DataEntityId}";

            //act

            _vm.CreateNew();
            _vm.Copy();

            //assert
            var foundRecord = _vm.Records.FirstOrDefault(p=> p.DataEntityId == copyId);
            Assert.NotNull(foundRecord);
            Assert.Equal(copyId,((Pocos.ixDataExamples.IxProductionData)foundRecord).DataEntityId);

        }
    }
}
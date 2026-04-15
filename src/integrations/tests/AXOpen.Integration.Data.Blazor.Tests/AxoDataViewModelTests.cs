using AxoDataExamplesDocu;
using axopen_integrations;
using AXOpen.Data.Interfaces;
using AXOpen.Data;
using AXSharp.Connector;
using AXOpen.Data.InMemory;


namespace integration.data.blazor.tests
{
    public class AxoDataViewModelTests
    {

        private static axopen_integrationsTwinController _plc { get; }
        = new(ConnectorAdapterBuilder.Build()
            .CreateDummy());

        private DataExchangeViewModel _vm;
        public AxoDataViewModelTests()
        {
          
            var dataObject = _plc.process_data_manager; 

            var repo = AXOpen.Data.InMemory.Repository.Factory(new InMemoryRepositorySettings<Pocos.AxoDataExamples.AxoProductionData>());
            dataObject.SetRepository(repo);

            var data = dataObject.DataEntity;

            var exchangeViewModel = new DataExchangeViewModel
            {
                Model = dataObject,
                //AlertDialogService = new AlertDialogServiceBase()
                };
            _vm = exchangeViewModel;
            
        }
        [Fact]
        public void test_DataViewModel_NotNull()
        {
            Assert.NotNull(_vm);
        }

        [Fact]
        public async void test_DataViewModel_Create()
        {
            //arrange
            var id = "createId";
            _vm.CreateItemId=id;

            //act
            await _vm.CreateNew();

            //assert
            var record = _vm.Records.FirstOrDefault(p=> p._EntityId == id);
            Assert.NotNull(record);
            Assert.Equal(id, record._EntityId);
          
        }

        [Fact]
        public async void test_DataViewModel_Delete()
        {
            //arrange
            var id = "testDelete";
            _vm.CreateItemId=id;

            //act
            await _vm.CreateNew();
            var record = _vm.Records.FirstOrDefault(p=> p._EntityId == id);

            _vm.SelectedRecord = new Pocos.AxoDataExamples.AxoProductionData
            {
                _EntityId=record._EntityId
            };
           _vm.Delete();

            //assert
            var recordNull = _vm.Records.FirstOrDefault(p=> p._EntityId == id);
            Assert.Null(recordNull);
          
        }

        [Fact]
        public async void test_DataViewModel_Edit()
        {
            //arrange
            var id = "testEdit";
            var recipe = "recipeName";
            _vm.CreateItemId=id;

            //act
            await _vm.CreateNew();
            var record = _vm.Records.FirstOrDefault(p=> p._EntityId == id);

             _vm.SelectedRecord = new Pocos.AxoDataExamples.AxoProductionData
            {
                _EntityId=record._EntityId,
                RecipeName=recipe
            };

            //await _vm.DataExchange.RefUIData.PlainToShadow(_vm.SelectedRecord);
            await _vm.DataExchange.FromRepositoryToShadowsAsync(_vm.SelectedRecord, _vm.DataExchange.DataExchangeTwinObject);
            await _vm.Edit();

            //assert
            var foundRecord = _vm.Records.FirstOrDefault(p=> p._EntityId == id);
            Assert.NotNull(foundRecord);
            Assert.Equal(recipe,((Pocos.AxoDataExamples.AxoProductionData)foundRecord).RecipeName);
          
        }

        [Fact]
        public async void test_DataViewModel_Copy()
        {
             //arrange
            var id = "testCopy";
            var p = new Pocos.AxoDataExamples.AxoProductionData
            {
                _EntityId = id,
            };

            _vm.DataExchange.Repository.Create(id, p);

            _vm.SelectedRecord = p;


            //act
            _vm.CreateItemId = id;
            // await _vm.CreateNew();

            var copyId = $"Copy of {_vm.SelectedRecord._EntityId}";
            _vm.CreateItemId = copyId;
            await _vm.Copy();

            //assert
            var foundRecord = _vm.Records.FirstOrDefault(p=> p._EntityId == copyId);
            Assert.NotNull(foundRecord);
            Assert.Equal(copyId,((Pocos.AxoDataExamples.AxoProductionData)foundRecord)._EntityId);

        }
    }
}
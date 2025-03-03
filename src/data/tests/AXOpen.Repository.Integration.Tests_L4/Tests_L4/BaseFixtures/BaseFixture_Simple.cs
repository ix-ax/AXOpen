using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using MongoDB.Driver;

namespace Tests_L4
{
    using Pocos.Exchange_Test_L4;

    public class BaseFixture_Simple : IDisposable
    {
        internal IRepository<ProcessData> _repository;

        public BaseFixture_Simple()
        {
            if (_repository != null)
            {
                InitializeData();
            }
        }

        internal void InitializeData()
        {
            for (int i = 0; i < 10; i++)
            {
                var item = new ProcessData();

                this.FillUpData(item, i);

                _repository.Create(item.DataEntityId, item);
            }
        }

        private void FillUpData(ProcessData obj, int iteration)
        {
            obj.DataEntityId = iteration.ToString();
            obj.vBool = true;
            obj.vString = "even " + iteration.ToString();
            obj.vInt = (short)iteration;

            obj.NestObj.vString = "odd " + (iteration + 1).ToString();
            obj.NestObj.vBool = true;
            obj.NestObj.vInt = (short)(iteration + 1);

            if (iteration % 2 == 0)
            {
                obj.vBool = false;
                obj.NestObj.vBool = false;
                obj.vString = "odd " + iteration.ToString();
                obj.NestObj.vString = "even " + (iteration + 1).ToString();
            }
        }

        public virtual void Dispose()
        {
            // Clean up
        }
    }
}
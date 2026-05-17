using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using MongoDB.Driver;

namespace Tests_L4
{
    using AXOpen.Data.Query;
    using Pocos.Exchange_Test_L4;

    public class SingleRepositoryFixture_Base : IDisposable
    {
        public IRepository<ProcessData> Repository;

        public DateTime InitialTestTime;

        public SingleRepositoryFixture_Base()
        {
            if (Repository != null)
            {
                InitializeData();
            }

            PlainSymbolBuilder.ClearStaticConfiguration();
        }

        internal void InitializeData()
        {
            InitialTestTime = DateTime.Now;

            for (int i = 0; i < 10; i++)
            {
                var item = new ProcessData();

                this.FillUpData(item, i);

                Repository.Create(item._EntityId, item);
            }
        }

        /// <summary>
        /// Populates a fixture record with deterministic test data.
        /// </summary>

        private void FillUpData(ProcessData obj, int iteration)
        {
            obj._EntityId = iteration.ToString();

            var isEvenIteration = iteration % 2 == 0;

            obj.vBool = true;
            obj.vString = "even " + iteration.ToString();
            obj.vInt = (short)iteration;

            obj.Primitives.vSTRING = "odd " + (iteration + 1).ToString();
            obj.Primitives.vBOOL = true;

            if (isEvenIteration)
            {
                obj.vBool = false;
                obj.vString = "odd " + iteration.ToString();
                obj.Primitives.vBOOL = false;
                obj.Primitives.vSTRING = "even " + (iteration + 1).ToString();
            }

            var val = iteration + 1;
            obj.Primitives.vBYTE = (byte)val;
            obj.Primitives.vWORD = (ushort)val;
            obj.Primitives.vDWORD = (uint)val;
            obj.Primitives.vLWORD = (ulong)val;
            obj.Primitives.vSINT = (sbyte)val;
            obj.Primitives.vINT = (short)val;
            obj.Primitives.vLINT= (long)val;
            obj.Primitives.vUSINT = (byte)val;
            obj.Primitives.vUINT = (ushort)val;
            obj.Primitives.vREAL = (float)val;

        }

        public virtual void Dispose()
        {
            // Clean up
        }
    }
}

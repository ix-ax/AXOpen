using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using MongoDB.Driver;
using Pocos.FragmentExchange_Test_L4;

namespace Tests_L4
{
    public class BaseFixture_Fragment : IDisposable
    {
        internal IRepository<HeaderData> _headerRepository;
        internal IRepository<StationData> _stationRepository;

        public BaseFixture_Fragment()
        {
            if (_headerRepository != null && _stationRepository != null)
            {
                InitializeData();
            }
        }

        internal void InitializeData()
        {
            for (int i = 1; i < 11; i++)
            {
                var h = new HeaderData();
                FillUpData(h, i);
                _headerRepository.Create(h.DataEntityId, h);

                var station = new StationData();
                FillUpData(station, i);
                _stationRepository.Create(station.DataEntityId, station);
            }
        }

        private void FillUpData(HeaderData obj, int iteration)
        {
            obj.DataEntityId = iteration.ToString();
            obj.vBool = true;
            obj.vString = "even " + iteration.ToString();
            obj.vInt = (short)iteration;

            if (iteration % 2 == 0)
            {
                obj.vBool = false;
                obj.vString = "odd " + iteration.ToString();
            }
        }

        private void FillUpData(StationData obj, int iteration)
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
namespace Tests_L4
{
    using AXOpen.Base.Data;
    using Pocos.FragmentExchange_Test_L4;

    public class FragmentRepositoryFixture_Base : IDisposable
    {
        internal IRepository<HeaderData> RepositoryHeader;
        internal IRepository<StationData> RepositoryStation;

        public FragmentRepositoryFixture_Base()
        {
            if (RepositoryHeader != null && RepositoryStation != null)
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
                RepositoryHeader.Create(h.DataEntityId, h);

                var station = new StationData();
                FillUpData(station, i);
                RepositoryStation.Create(station.DataEntityId, station);
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
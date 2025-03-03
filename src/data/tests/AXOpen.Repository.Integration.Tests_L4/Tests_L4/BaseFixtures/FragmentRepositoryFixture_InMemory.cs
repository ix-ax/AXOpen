namespace Tests_L4
{
    using AXOpen.Data.InMemory;
    using Pocos.FragmentExchange_Test_L4;

    public class FragmentRepositoryFixture_InMemory : FragmentRepositoryFixture_Base
    {
        public FragmentRepositoryFixture_InMemory()
        {
            this.RepositoryHeader = AXOpen.Data.InMemory.Repository.Factory<HeaderData>(new InMemoryRepositorySettings<HeaderData>());

            this.RepositoryStation = AXOpen.Data.InMemory.Repository.Factory<StationData>(new InMemoryRepositorySettings<StationData>());

            InitializeData();
        }

        public void Dispose()
        {
            // Clean up
        }
    }
}
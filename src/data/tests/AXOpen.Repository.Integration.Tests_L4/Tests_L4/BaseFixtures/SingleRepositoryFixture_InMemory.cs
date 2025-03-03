namespace Tests_L4
{
    using AXOpen.Data.InMemory;
    using Pocos.Exchange_Test_L4;

    public class SingleRepositoryFixture_InMemory : SingleRepositoryFixture_Base
    {
        public SingleRepositoryFixture_InMemory()
        {
            this.Repository = AXOpen.Data.InMemory.Repository.Factory<ProcessData>(new InMemoryRepositorySettings<ProcessData>());

            InitializeData();
        }

        public override void Dispose()
        {
            base.Dispose();
        }
    }
}
namespace Tests_L4
{

    [Collection(Constants.TESTS_MONGO)]
    public class FragmentRepositoryTests_Mongo : FragmentRepositoryTests_Base, IClassFixture<FragmentRepositoryFixture_Mongo>
    {
        public FragmentRepositoryTests_Mongo(FragmentRepositoryFixture_Mongo fixture)
        {
            this.Fixture = fixture;
        }
    }
}
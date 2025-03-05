namespace Tests_L4
{
    [Collection(Constants.TESTS_MEMORY)]
    public class FragmentRepositoryTests_InMemory : FragmentRepositoryTests_Base, IClassFixture<FragmentRepositoryFixture_InMemory>
    {
        public FragmentRepositoryTests_InMemory(FragmentRepositoryFixture_InMemory fixture)
        {
            this.Fixture = fixture;
        }
    }
}
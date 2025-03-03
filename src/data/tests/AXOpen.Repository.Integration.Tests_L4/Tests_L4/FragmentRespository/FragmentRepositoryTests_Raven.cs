namespace Tests_L4
{
    [Collection(Constants.TESTS_RAVEN)]
    public class FragmentRepositoryTests_Raven : FragmentRepositoryTests_Base, IClassFixture<FragmentRepositoryFixture_Raven>
    {
        public FragmentRepositoryTests_Raven(FragmentRepositoryFixture_Raven fixture)
        {
            this.Fixture = fixture;
        }
    }
}
namespace Tests_L4
{
    [Collection(Constants.TESTS_JSON)]
    public class FragmentRepositoryTests_Json : FragmentRepositoryTests_Base, IClassFixture<FragmentRepositoryFixture_Json>
    {
        public FragmentRepositoryTests_Json(FragmentRepositoryFixture_Json fixture)
        {
            this.Fixture = fixture;
        }
    }
}
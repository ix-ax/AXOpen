namespace Tests_L4
{
    using AXOpen.Data.Json;
    using Pocos.FragmentExchange_Test_L4;
    using System.Reflection;

    public class FragmentRepositoryFixture_Json : FragmentRepositoryFixture_Base
    {
        private string OutDir = Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory.FullName, Constants.JSON_REPOSITORY_FOLDER_NAME);

        public FragmentRepositoryFixture_Json()
        {
            if (Directory.Exists(OutDir))
            {
                Directory.Delete(OutDir, true);
            }

            this.RepositoryHeader = new JsonRepository<HeaderData>(new JsonRepositorySettings<HeaderData>(OutDir));

            this.RepositoryStation = new JsonRepository<StationData>(new JsonRepositorySettings<StationData>(OutDir));

            InitializeData();
        }

        public void Dispose()
        {
            // Clean up
        }
    }
}
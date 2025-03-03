namespace Tests_L4
{
    using AXOpen.Data.Json;
    using Pocos.FragmentExchange_Test_L4;
    using System.Reflection;

    public class FragmentRepositoryFixture_Json : FragmentRepositoryFixture_Base
    {
        private string OutDirHeader = Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory.FullName, Constants.JSON_REPO_HEADER_DATA_FOLDER_NAME);

        private string OutDirStation = Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory.FullName, Constants.JSON_REPO_STATION_DATA_FOLDER_NAME);

        public FragmentRepositoryFixture_Json()
        {
            if (Directory.Exists(OutDirHeader))
            {
                Directory.Delete(OutDirHeader, true);
            }

            if (Directory.Exists(OutDirStation))
            {
                Directory.Delete(OutDirStation, true);
            }

            this.RepositoryHeader = new JsonRepository<HeaderData>(new JsonRepositorySettings<HeaderData>(OutDirHeader));

            this.RepositoryStation = new JsonRepository<StationData>(new JsonRepositorySettings<StationData>(OutDirStation));

            InitializeData();
        }

        public void Dispose()
        {
            // Clean up
        }
    }
}
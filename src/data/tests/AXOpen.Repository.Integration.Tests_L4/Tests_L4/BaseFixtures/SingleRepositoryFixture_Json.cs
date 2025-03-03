namespace Tests_L4
{
    using AXOpen.Data.Json;
    using Pocos.Exchange_Test_L4;
    using System.Reflection;

    public class SingleRepositoryFixture_Json : SingleRepositoryFixture_Base
    {
        private string OutDir = Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory.FullName, Constants.JSON_REPO_PROCESS_DATA_FOLDER_NAME);

        public SingleRepositoryFixture_Json()
        {
            if (Directory.Exists(OutDir))
            {
                Directory.Delete(OutDir, true);
            }

            this.Repository = new JsonRepository<ProcessData>(new JsonRepositorySettings<ProcessData>(OutDir));

            InitializeData();
        }

        public override void Dispose()
        {
            base.Dispose();
        }
    }
}
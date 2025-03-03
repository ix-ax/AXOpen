namespace Tests_L4
{
    using AXOpen.Base.Data.Query;
    using Pocos.Exchange_Test_L4;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    [Collection(Constants.TESTS_JSON)]
    public class SingleRepositoryTest_Json : SingleRepositoryTests_Base, IClassFixture<SingleRepositoryFixture_Json>
    {
        public SingleRepositoryTest_Json(SingleRepositoryFixture_Json fixture)
        {
            this.Fixture = fixture;
        }
    }
}
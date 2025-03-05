namespace Tests_L4
{
    using AXOpen.Base.Data.Query;
    using Pocos.Exchange_Test_L4;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    [Collection(Constants.TESTS_MONGO)]
    public class SingleRepositoryTest_Mongo : SingleRepositoryTests_Base, IClassFixture<SingleRepositoryFixture_Mongo>
    {
        public SingleRepositoryTest_Mongo(SingleRepositoryFixture_Mongo fixture)
        {
            this.Fixture = fixture;
        }
    }
}
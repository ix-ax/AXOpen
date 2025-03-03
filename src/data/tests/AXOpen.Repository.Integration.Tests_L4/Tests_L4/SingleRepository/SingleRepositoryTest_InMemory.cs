namespace Tests_L4
{
    using AXOpen.Base.Data.Query;
    using Pocos.Exchange_Test_L4;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    [Collection(Constants.TESTS_MEMORY)]
    public class SingleRepositoryTest_InMemory : SingleRepositoryTests_Base, IClassFixture<SingleRepositoryFixture_InMemory>
    {
        public SingleRepositoryTest_InMemory(SingleRepositoryFixture_InMemory fixture)
        {
            this.Fixture = fixture;
        }
    }
}
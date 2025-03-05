namespace Tests_L4
{
    using AXOpen.Data;
    using System;
    using System.Linq;
    using Xunit;
    using Pocos.FragmentExchange_Test_L4;
    using System.Collections.Frozen;
    using AXOpen.Data.Query;
    using AXOpen.Base.Data.Query;

    [Collection(Constants.TESTS_JSON)]
    public class OnlinerFragmentDataExchangeTests_Json : OnlinerFragmentDataExchangeTests_Base, IClassFixture<FragmentRepositoryFixture_Json>
    {
        public OnlinerFragmentDataExchangeTests_Json(FragmentRepositoryFixture_Json fixture)
        {
            Fixture = fixture;

            FramgentManager = axopen_integration_tests_l4.Entry.Plc.FragmentsExchangeContext_Test_L4.DataManager;

            FramgentManager.CreateDataFragments<FragmentExchange_Test_L4.FragmentProcessDataManager>();

            FramgentManager.Header.SetRepository(Fixture.RepositoryHeader);
            FramgentManager.St1.SetRepository(Fixture.RepositoryStation);

            Exchange = FramgentManager;
        }
    }
}
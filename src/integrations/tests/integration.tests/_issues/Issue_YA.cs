using System.Runtime.InteropServices;
using IntegrationTests;
using intergrations;
using Ix.Connector;
using Siemens.Simatic.S7.Webserver.API.Enums;
using Siemens.Simatic.S7.Webserver.API.Models;
using Siemens.Simatic.S7.Webserver.API.Services;
using Siemens.Simatic.S7.Webserver.API.Services.RequestHandling;


namespace integartions.issues
{
    using Siemens.Simatic.S7.Webserver.API.Models.Responses;
    using System;
    using System.Security.Cryptography;
    using Xunit;
    using Xunit.Abstractions;

    public class  BUG_Fails_to_access_inherited_members_in_some_object_composition_scenarios_51
    {
        private DataExchangeTestsContext testContext = Entry.Plc.Integrations.DataExchangeTestsContext;

        private readonly ITestOutputHelper output;


        public BUG_Fails_to_access_inherited_members_in_some_object_composition_scenarios_51(ITestOutputHelper output)
        {
            this.output = output;
        }

        [Fact]
        public async Task Replicate()
        {
            var serviceFactory = new ApiStandardServiceFactory();
            var reqHandler = await serviceFactory.GetApiHttpClientRequestHandlerAsync("192.168.0.4", "Everybody", "");

            // Throws
            var mystery = Entry.Plc.Integrations.DataExchangeTestsContext.Create.Manager.CreateTask;
            var works = Entry.Plc.process_data_manager.CreateTask;

            Assert.True(mystery.GetType() == works.GetType());

            output.WriteLine($"\"TGlobalVariablesDB\".{works.Status.Symbol}");
            output.WriteLine($"\"TGlobalVariablesDB\".{mystery.Status.Symbol}");

            var apiBrowseResponse = await reqHandler.PlcProgramBrowseAsync(ApiPlcProgramBrowseMode.Var, $"\"TGlobalVariablesDB\".{works.Status.Symbol}");

            await Assert.ThrowsAsync<Siemens.Simatic.S7.Webserver.API.Exceptions.ApiInvalidAddressException>(async () => await reqHandler.PlcProgramBrowseAsync(ApiPlcProgramBrowseMode.Var, $"\"TGlobalVariablesDB\".{mystery.Status.Symbol}"));
        }
    }
}
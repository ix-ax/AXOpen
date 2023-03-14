using System.Runtime.InteropServices;
using IntegrationTests;
using intergrations;
using Ix.Connector;
using Siemens.Simatic.S7.Webserver.API.Enums;
using Siemens.Simatic.S7.Webserver.API.Models;
using Siemens.Simatic.S7.Webserver.API.Services;
using Siemens.Simatic.S7.Webserver.API.Services.RequestHandling;

// Addressing https://github.com/ix-ax/ix.framework/issues/51

namespace integartions.issues
{
    using Siemens.Simatic.S7.Webserver.API.Models.Responses;
    using System;
    using System.Security.Cryptography;
    using Xunit;
    using Xunit.Abstractions;

    public class GH_IXF_51
    {
        private DataExchangeTestsContext testContext = Entry.Plc.Integrations.DataExchangeTestsContext;

        private readonly ITestOutputHelper output;


        public GH_IXF_51(ITestOutputHelper output)
        {
            this.output = output;
        }

        [Fact]
        public async Task Replicate()
        {
            var serviceFactory = new ApiStandardServiceFactory();
            var reqHandler = await serviceFactory.GetApiHttpClientRequestHandlerAsync(Environment.GetEnvironmentVariable("AXTARGET"), "Everybody", "");

            var mystery = Entry.Plc.GH_IXF_51.DataExchangeTestsContext.Create.Manager.CreateTask;
            var works = Entry.Plc.GH_IXF_51.process_data_manager.CreateTask;

            output.WriteLine($"\"TGlobalVariablesDB\".{works.Status.Symbol}");
            output.WriteLine($"\"TGlobalVariablesDB\".{mystery.Status.Symbol}");


            // Both objects are of the same tyep
            Assert.True(mystery.GetType() == works.GetType());
            
            // Works
            await reqHandler.PlcProgramBrowseAsync(ApiPlcProgramBrowseMode.Var, $"\"TGlobalVariablesDB\".{works.Status.Symbol}");

            await Assert.ThrowsAsync<Siemens.Simatic.S7.Webserver.API.Exceptions.ApiInvalidAddressException>(async () => await reqHandler.PlcProgramBrowseAsync(ApiPlcProgramBrowseMode.Var, $"\"TGlobalVariablesDB\".{mystery.Status.Symbol}"));
        }
    }
}
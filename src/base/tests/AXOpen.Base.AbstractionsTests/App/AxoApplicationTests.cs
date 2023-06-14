using Xunit;
using AXOpen;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Logging;

namespace AXOpen.Tests
{
    public class AxoApplicationTests
    {
        [Fact()]
        public void CreateBuilderTest()
        {
            var builder = AxoApplication.CreateBuilder();
            Assert.NotNull(builder as IAxoApplicationBuilder);
        }

        [Fact()]
        public void ConfigureLoggerTest()
        {
            var builder = AxoApplication.CreateBuilder();
            builder.ConfigureLogger(new DummyLogger());
            Assert.IsType<DummyLogger>(AxoApplication.Current.Logger);
        }

        [Fact()]
        public void BuildTest()
        {
            var builder = AxoApplication.CreateBuilder();
            Assert.True(builder.Build() is IAxoApplication);
        }
    }
}
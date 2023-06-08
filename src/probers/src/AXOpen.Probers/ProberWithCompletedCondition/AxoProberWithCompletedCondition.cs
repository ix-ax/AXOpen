using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Core;

namespace AXOpen.Probers
{
    public partial class AxoProberWithCompletedCondition
    {
        /// <summary>
        /// Runs this test in the PLC
        /// </summary>
        /// <returns>Task</returns>
        public async Task RunTest()
        {
            this.Restore();

            while (true)
            {
                var state = (eAxoTaskState)await Status.GetAsync();

                if (state == eAxoTaskState.Ready && !this.RemoteRestore.GetAsync().Result)
                {
                    break;
                }

                Task.Delay(1).Wait();
            }

            this.ExecuteAsync(new GenericIdentity("Tester"));

            while (true)
            {
                var state = (eAxoTaskState)await Status.GetAsync();
                if (state == eAxoTaskState.Done && !this.RemoteInvoke.GetAsync().Result)
                {
                    break;
                }

                if (state == eAxoTaskState.Error && !this.RemoteInvoke.GetAsync().Result)
                {
                    var failureDescription = await this.ErrorDetails.GetAsync();
                    throw new Exception(failureDescription);
                }

                Task.Delay(1).Wait();
            }
        }
}
}

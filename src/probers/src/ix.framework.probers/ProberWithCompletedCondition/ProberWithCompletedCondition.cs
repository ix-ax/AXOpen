using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Core;

namespace ix.framework.probers
{
    public partial class ProberWithCompletedCondition
    {
        /// <summary>
        /// Runs this test in the PLC
        /// </summary>
        /// <returns>Task</returns>
        public async Task RunTest()
        {
            await this.Restore();

            while (true)
            {
                var state = (eIxTaskState)await Status.GetAsync();

                if (state == eIxTaskState.Ready && !this.RemoteRestore.GetAsync().Result)
                {
                    break;
                }

                Task.Delay(1).Wait();
            }

            this.Execute();

            while (true)
            {
                var state = (eIxTaskState)await Status.GetAsync();
                if (state == eIxTaskState.Done && !this.RemoteInvoke.GetAsync().Result)
                {
                    break;
                }

                if (state == eIxTaskState.Error && !this.RemoteInvoke.GetAsync().Result)
                {
                    var failureDescription = await this.ErrorDetails.GetAsync();
                    throw new Exception(failureDescription);
                }

                Task.Delay(1).Wait();
            }
        }
}
}

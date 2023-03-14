using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ix.framework.core;

namespace ix.framework.probers
{
    public partial class ProberWithCounterBase
    {
        /// <summary>
        /// Runs this test in the PLC.
        /// </summary>
        /// <param name="numberOfCycles">Number of context cycle runs.</param>
        /// <returns>Task</returns>
        public async Task RunTest(uint numberOfCycles)
        {
            await this.Restore();

            await this.RequredNumberOfCycles.SetAsync(numberOfCycles);
            
            this.Execute();

            while (true)
            {
                var state = (eIxTaskState)await Status.GetAsync();
                if (state == eIxTaskState.Done)
                {
                    break;
                }

                if (state == eIxTaskState.Error)
                {
                    throw new Exception(await this.FailureDescription.GetAsync());
                }

                Task.Delay(100).Wait();
            }
        }
}
}

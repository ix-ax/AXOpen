using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Core;

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

            while (true)
            {
                var state = (eAxoTaskState)await Status.GetAsync();

                if (state == eAxoTaskState.Ready && !this.RemoteRestore.GetAsync().Result)
                {
                    break;
                }

                Task.Delay(1).Wait();
            }

            await this.RequredNumberOfCycles.SetAsync(numberOfCycles);
            
            this.Execute();

            while (true)
            {
                var state = (eAxoTaskState)await Status.GetAsync();
                if (state == eAxoTaskState.Done)
                {
                    break;
                }

                if (state == eAxoTaskState.Error)
                {
                    throw new Exception(await this.ErrorDetails.GetAsync());
                }

                Task.Delay(10).Wait();
            }
        }
}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Core;

namespace AXOpen.Probers
{
    public partial class AxoProberWithCounterBase
    {
        /// <summary>
        /// Runs this test in the PLC.
        /// </summary>
        /// <param name="numberOfCycles">Number of context cycle runs.</param>
        /// <returns>Task</returns>
        public async Task RunTest(uint numberOfCycles)
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

            await this.RequredNumberOfCycles.SetAsync(numberOfCycles);
            
            this.ExecuteAsync();

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

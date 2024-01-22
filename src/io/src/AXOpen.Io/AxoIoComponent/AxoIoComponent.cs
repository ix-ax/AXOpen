using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Io
{
    public partial class AxoIoComponent
    {
        public async Task WriteTaskDurationToConsole()
        {
            foreach (var task in this.GetChildren().OfType<AxoTask>())
            {
                Console.WriteLine($"{task.Symbol} : {await task.Duration.GetAsync()}");
            }
        }
    }
}

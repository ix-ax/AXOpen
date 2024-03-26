using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Template.Axolibrary
{
    public partial class TemplateComponent
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
